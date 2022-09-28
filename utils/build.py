# Requires Python 3.10.0 or later.

import argparse
from dataclasses import dataclass
from enum import Enum, unique
import inspect
import json
from os import PathLike
from pathlib import Path
import sys
import subprocess
from typing import Any, Callable, Generator, List, Optional, TypeVar

from parser_generate import do_parser_generation
from process import run, run_output
from paths import GRAMMARS_ROOT_PATH, SOURCE_ROOT_PATH

debug_args: list[str] = []
release_args: list[str] = []


def make_argparser() -> argparse.ArgumentParser:
    # Argument parser with support for specifying default subcommand parser
    # https://stackoverflow.com/a/37593636
    class DefaultSubcommandArgParse(argparse.ArgumentParser):
        __default_subparser: Any = None

        def set_default_subparser(self, name):
            self.__default_subparser = name

        def _parse_known_args(self, arg_strings, *args, **kwargs):
            in_args = set(arg_strings)
            d_sp = self.__default_subparser
            if d_sp is not None and not {"-h", "--help"}.intersection(in_args):
                for x in self._subparsers._actions:
                    subparser_found = isinstance(
                        x, argparse._SubParsersAction
                    ) and in_args.intersection(x._name_parser_map.keys())
                    if subparser_found:
                        break
                else:
                    # insert default in first position, this implies no
                    # global options without a sub_parsers specified
                    arg_strings = [d_sp] + arg_strings
            return super(DefaultSubcommandArgParse, self)._parse_known_args(
                arg_strings, *args, **kwargs
            )

    def add_executable_arg(parser: argparse.ArgumentParser):
        parser.add_argument(
            "executable",
            type=str,
            default=None,
            nargs="?",
            help="The executable to run.",
        )

    def add_cross_module_optimization_arg(parser: argparse.ArgumentParser):
        parser.add_argument(
            "-cross-module-optimization",
            dest="enable_cross_module_optimization",
            default=False,
            action="store_true",
            help="Whether to pass '-Xswiftc -cross-module-optimization' as a build argument for release builds.",
        )

    def add_target_arg(parser: argparse.ArgumentParser):
        parser.add_argument(
            "-t",
            "--target",
            type=str,
            dest="target",
            help="Optional target to build/test/run against. Must be one of the targets specified in Package.swift.",
        )

    def add_common_args(parser: argparse.ArgumentParser):
        parser.add_argument(
            "-c",
            "--configuration",
            type=str,
            dest="configuration",
            default="debug",
            help="Build configuration to use. Can either be 'debug' or 'release'. Defaults to 'debug'.",
        )

        parser.add_argument(
            "-d",
            action="append",
            type=str,
            dest="definitions",
            help="A list of -D parameters to pass to -Xswiftc during compilation. Used to enable/disable '#if <DEFINITION_NAME>' in Swift code.",
        )

    argparser = DefaultSubcommandArgParse(
        description="Builds ImagineUI-Win and/or sample project."
    )
    argparser.set_default_subparser("build")

    subparsers = argparser.add_subparsers(dest="command")

    build_parser = subparsers.add_parser(
        "build", help="Facilitates running builds of Swift targets on Windows."
    )
    test_parser = subparsers.add_parser(
        "test", help="Facilitates running tests of Swift targets on Windows."
    )
    run_parser = subparsers.add_parser(
        "run", help="Facilitates running executable targets on Windows."
    )
    subparsers.add_parser("gen-parsers", help="Main scripting entry point for .")

    add_common_args(test_parser)
    add_common_args(build_parser)
    add_common_args(run_parser)

    add_cross_module_optimization_arg(build_parser)
    add_cross_module_optimization_arg(run_parser)
    add_target_arg(build_parser)
    add_target_arg(run_parser)
    add_executable_arg(run_parser)

    return argparser


def toSwiftCDefList(definitions: list[str] | None) -> Generator:
    if definitions is None:
        return []

    for d in definitions:
        yield "-Xswiftc"
        yield f"-D{d}"


# Arguments for a build command.
@dataclass
class BuildCommandArgs:
    target_name: str | None
    config: str
    manifest_path: Path | None
    definitions: list[str] | None
    enable_cross_module_optimization: bool

    def swift_build_args(self) -> List[str]:
        args = []

        if self.target_name is not None:
            args.extend(["--target", self.target_name])

        args.extend(["--configuration", self.config])

        if self.config == "release":
            args.extend(release_args)
        else:
            args.extend(debug_args)

        args.extend(toSwiftCDefList(self.definitions))

        if self.config == "release" and self.enable_cross_module_optimization:
            args.extend(["-Xswiftc", "-cross-module-optimization"])

        return args


# Arguments for a run command.
@dataclass
class RunCommandArgs:
    target_name: str | None
    executable_name: str | None
    config: str
    manifest_path: Path | None
    definitions: list[str] | None
    enable_cross_module_optimization: bool

    def swift_build_args(self) -> List[str]:
        build_args = BuildCommandArgs(
            None,
            self.config,
            self.manifest_path,
            self.definitions,
            self.enable_cross_module_optimization,
        )

        return build_args.swift_build_args()

    def swift_run_args(self) -> List[str]:
        build_args = BuildCommandArgs(
            None,
            self.config,
            self.manifest_path,
            self.definitions,
            self.enable_cross_module_optimization,
        )

        args = []

        if self.executable_name is not None:
            args.append(self.executable_name)

        args.extend(["--skip-build"])
        args.extend(build_args.swift_build_args())

        return args


# Arguments for a test command.
@dataclass
class TestCommandArgs:
    config: str
    definitions: list[str] | None
    enable_code_coverage: bool = True

    def swift_test_args(self) -> List[str]:
        args = [
            "--configuration",
            self.config,
            *debug_args,
            *toSwiftCDefList(self.definitions),
        ]

        if self.enable_code_coverage:
            args.append("--enable-code-coverage")
        
        return args


# Settings for post-build process.
@dataclass
class PostBuildSettings:
    exe_path: Path
    manifest_path: Path


@unique
class SwiftTargetType(str, Enum):
    REGULAR = "regular"
    EXECUTABLE = "executable"


# A Swift target declared in a Package.swift
class SwiftTarget(object):
    name: str
    type: SwiftTargetType

    def __init__(self, obj: Any):
        self.name = obj["name"]
        self.type = SwiftTargetType(obj["type"])


T = TypeVar("T")


def deserialize_json(
    target_class: Callable[[Any], T], object_repr: str | bytes | bytearray
) -> T:
    data = json.loads(object_repr)
    signature = inspect.signature(target_class)
    bound_signature = signature.bind(**data)
    bound_signature.apply_defaults()
    return target_class(*bound_signature.arguments)


def print_args(args: Any):
    print("Arguments:")
    v = vars(args)
    for k, v in v.items():
        print(f"  - {k}: {v}")

def find(predicate: Callable[[T], bool], list: List[T]) -> Optional[T]:
    for item in list:
        if predicate(item):
            return item

    return None

def find_index(predicate: Callable[[T], bool], list: List[T]) -> Optional[int]:
    for (i, item) in enumerate(list):
        if predicate(item):
            return i

    return None

def get_package_description() -> Any:
    j = run_output("swift", "package", "dump-package")

    return json.loads(j)


def run_build(settings: BuildCommandArgs, cwd: str | PathLike | None = None):
    run("swift", "--version", silent=False)

    args = settings.swift_build_args()

    run("swift", "build", *args, cwd=cwd)


def run_test(settings: TestCommandArgs, cwd: str | PathLike | None = None):
    args = settings.swift_test_args()
    run("swift", "test", *args, cwd=cwd)


def run_target(settings: RunCommandArgs, cwd: str | PathLike | None = None):
    args = settings.swift_build_args()

    run("swift", "build", *args, cwd=cwd)
    run("swift", "run", *settings.swift_run_args(), cwd=cwd)


def do_build_command(args: Any):
    print("Processing Build request...")
    print_args(args)
    print("")

    settings = BuildCommandArgs(
        args.target,
        args.configuration,
        args.manifest_path,
        args.definitions,
        args.enable_cross_module_optimization,
    )

    # Run build for SwiftRewriter and AntlrGrammars sub-project
    run_build(settings, cwd=SOURCE_ROOT_PATH)
    run_build(settings, cwd=GRAMMARS_ROOT_PATH)

    print("Success!")


def do_test_command(args: Any):
    print("Processing Test request...")
    print_args(args)
    print("")

    settings = TestCommandArgs(args.configuration, args.definitions)

    # Run test for SwiftRewriter and AntlrGrammars sub-project
    run_test(settings, cwd=SOURCE_ROOT_PATH)
    run_test(settings, cwd=GRAMMARS_ROOT_PATH)

    print("Success!")

    return


def do_run_command(args: Any):
    print("Processing Run request...")
    print_args(args)
    print("")

    settings = RunCommandArgs(
        args.target,
        args.executable,
        args.configuration,
        args.manifest_path,
        args.definitions,
        args.enable_cross_module_optimization,
    )

    run_target(settings)

    return

def do_generate_parsers_command(args: Any):
    do_parser_generation()

def main() -> int:
    argparser = make_argparser()
    args = argparser.parse_args()

    match args.command:
        case 'build':
            do_build_command(args)
        case 'test':
            do_test_command(args)
        case 'run':
            do_run_command(args)
        case 'gen-parsers':
            do_generate_parsers_command(args)

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as err:
        sys.exit(err.returncode)
    except KeyboardInterrupt:
        sys.exit(1)
