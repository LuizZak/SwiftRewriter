# Requires Python 3.10.0 or later.

from pathlib import Path
import re
import shutil

from typing import Any

from paths import SOURCE_ROOT_PATH, grammar_transformer_package_path, make_relative
from process import run, run_output
from console_color import ConsoleColor

# Minimum required ANTLR version
antlr_req = "4.11"  # major.minor

swift_build_args = ["-c=release"]


def call_swift(*args: Any):
    run("swift", *args, cwd=grammar_transformer_package_path("."))


def build_swift_gen_transformer():
    call_swift("build", *swift_build_args)


def transform_source(swift_files: list[Path]):
    call_swift("run", *swift_build_args, "--skip-build", "AntlrGrammars", *swift_files)


def generate_antlr_grammar(
    output_path: Path, files: list[Path], antlr_v: str | None = None
):
    cwd = Path.cwd()
    normalized_paths = map(lambda path: make_relative(cwd, path), files)
    rel_output_path = make_relative(cwd, output_path)

    print(f"Generating Antlr grammar files to {rel_output_path}...")

    args = [
        "-Dlanguage=Swift",
        "-visitor",
        *normalized_paths,
        "-o",
        str(rel_output_path),
        "-Xexact-output-dir",
    ]

    if antlr_v is not None:
        args = [
            "-v",
            antlr_v,
        ] + args

    result = run_output("antlr4", *args)
    if result.find("error(") > -1:
        raise Exception(f"ANTLR4 failed to execute! Check output bellow:\n\n{result}.")

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


def validate_antlr_version(antlr_v: str | None = None):
    # Validate setup
    antlr_call: str

    if antlr_v is not None:
        antlr_call = run_output("antlr4", "-v", antlr_v, echo=False)
    else:
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

    antlr_version = antlr_version_match.group(1)

    if not antlr_version.startswith(antlr_req):
        print(f"Expected Antlr version {antlr_req}.*, but found {antlr_version}!")
        exit(1)


def copy_generated_files(output_path, target_parser_path):
    if not target_parser_path.is_dir():
        print(
            ConsoleColor.RED(
                f"Error: Could not find path for placing generated files @ {ConsoleColor.CYAN(make_relative(SOURCE_ROOT_PATH, target_parser_path))}"
            )
        )
        exit(1)

    files_to_copy = list(output_path.glob("*.swift"))

    print(
        f"Copying {ConsoleColor.CYAN(len(files_to_copy))} file(s) to {ConsoleColor.CYAN(make_relative(SOURCE_ROOT_PATH, target_parser_path))}..."
    )

    for file in files_to_copy:
        shutil.copy(file, target_parser_path)
