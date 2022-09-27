# Requires Python 3.10.0 or later.

from pathlib import Path
import re
import sys
import subprocess

from typing import Any

from paths import make_relative, srcroot_path

swift_build_args = ["-c=release"]


def run_output(bin_name: str, *args: Any, echo: bool = True) -> str:
    if echo:
        print(">", bin_name, *list(args))

    return subprocess.check_output([bin_name] + list(args)).decode("UTF8").strip()


def run(bin_name: str, *args: Any, echo: bool = True, silent: bool = False):
    if echo:
        print(">", bin_name, *list(args))

    if silent:
        subprocess.check_output([bin_name] + list(args))
    else:
        subprocess.check_call([bin_name] + list(args))


def call_swift(*args: Any):
    run("swift", *args)


def build_swift():
    call_swift("build", *swift_build_args)


def transform_source(swift_files: list[Path]):
    print("Transforming source files...")

    call_swift("run", *swift_build_args, "--skip-build", "AntlrGrammars", *swift_files)


def generate_antlr_grammar(output_path: Path, files: list[Path]):
    cwd = Path.cwd()
    normalized_paths = map(lambda path: make_relative(cwd, path), files)
    rel_output_path = make_relative(cwd, output_path)

    print(f"Generating Antlr grammar files to {rel_output_path}...")

    run(
        "antlr4",
        "-Dlanguage=Swift",
        "-visitor",
        *normalized_paths,
        "-o",
        rel_output_path,
        "-Xexact-output-dir",
    )

    # Remove extraneous .token and .interp files
    print(f"Removing extraneous generated files in {rel_output_path}...")

    for file in output_path.glob("*.interp"):
        if file.is_file():
            file.unlink()
            print(f"Removed {make_relative(cwd, file)}")

    for file in output_path.glob("*.tokens"):
        if file.is_file():
            file.unlink()
            print(f"Removed {make_relative(cwd, file)}")


def generate_objc_antlr_grammar():
    base_path = srcroot_path("ObjcGrammar")
    two_step_path = base_path.joinpath("two-step-processing")

    output_path = base_path.joinpath("gen")
    grammar_files = [
        base_path.joinpath("ObjectiveCParser.g4"),
        base_path.joinpath("ObjectiveCLexer.g4"),
        two_step_path.joinpath("ObjectiveCPreprocessorLexer.g4"),
        two_step_path.joinpath("ObjectiveCPreprocessorParser.g4"),
    ]

    generate_antlr_grammar(output_path, grammar_files)

    swift_files = list(output_path.glob("*.swift"))
    swift_files = list(
        filter(
            lambda path: str(path).endswith("Parser.swift")
            or str(path).endswith("Lexer.swift"),
            swift_files,
        )
    )

    transform_source(swift_files)


def validate_antlr_version():
    # Validate setup
    antlr_call = run_output("antlr4", echo=False)
    antlr_version_pattern = re.compile(
        r"ANTLR Parser Generator\s+Version\s+((?:\d+\.)+\d+)"
    )
    antlr_version_match = antlr_version_pattern.match(antlr_call)

    if antlr_version_match is None:
        print(
            "Antlr4 not found! Please install Antlr4 before proceeding: https://antlr.org"
        )
        exit(1)

    antlr_req = "4.11"  # major.minor
    antlr_version = antlr_version_match.group(1)

    if not antlr_version.startswith(antlr_req):
        print(f"Expected Antlr version {antlr_req}.*, but found {antlr_version}!")
        exit(1)


def main() -> int:
    validate_antlr_version()

    print("Prebuilding Swift project...")
    build_swift()

    generate_objc_antlr_grammar()

    print("Success!")

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as err:
        sys.exit(err.returncode)
    except KeyboardInterrupt:
        sys.exit(1)
