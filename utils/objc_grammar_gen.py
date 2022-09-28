# Requires Python 3.10.0 or later.

import shutil
from generator_paths import (
    SOURCE_ROOT_PATH,
    grammars_package_path,
    make_relative,
    srcroot_path,
)
from antlr_grammar_gen import (
    generate_antlr_grammar,
    transform_source,
)


def generate_objc_antlr_grammar():
    base_path = grammars_package_path("ObjcGrammar")
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

    # Copy files now
    target_parser_path = srcroot_path("Sources", "ObjcParserAntlr")

    if not target_parser_path.is_dir():
        print(
            f"Error: Could not find path for placing generated files @ {make_relative(SOURCE_ROOT_PATH, target_parser_path)}"
        )
        exit(1)

    files_to_copy = list(output_path.glob("*.swift"))

    print(
        f"Copying {len(files_to_copy)} file(s) to {make_relative(SOURCE_ROOT_PATH, target_parser_path)}..."
    )

    for file in files_to_copy:
        shutil.copy(file, target_parser_path)
