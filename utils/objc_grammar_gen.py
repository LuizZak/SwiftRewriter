# Requires Python 3.10.0 or later.

from paths import (
    SOURCE_ROOT_PATH,
    grammars_path,
    make_relative,
    srcroot_path,
)
from antlr_grammar_gen import (
    copy_generated_files,
    generate_antlr_grammar,
    transform_source,
)
from console_color import ConsoleColor


def generate_objc_antlr_grammar(antlr_v: str | None = None):
    base_path = grammars_path("ObjcGrammar")
    two_step_path = base_path.joinpath("two-step-processing")

    print(
        f"Generating Objective-C grammar files @ {ConsoleColor.CYAN(make_relative(SOURCE_ROOT_PATH, base_path))}..."
    )

    output_path = base_path.joinpath("gen")
    grammar_files = [
        base_path.joinpath("ObjectiveCParser.g4"),
        base_path.joinpath("ObjectiveCLexer.g4"),
        two_step_path.joinpath("ObjectiveCPreprocessorLexer.g4"),
        two_step_path.joinpath("ObjectiveCPreprocessorParser.g4"),
    ]

    generate_antlr_grammar(output_path, grammar_files, antlr_v)

    swift_files = list(output_path.glob("*.swift"))
    swift_files = list(
        filter(
            lambda path: str(path).endswith("Parser.swift")
            or str(path).endswith("Lexer.swift"),
            swift_files,
        )
    )

    print("Transforming source files...")
    transform_source(swift_files)

    # Copy files now
    target_parser_path = srcroot_path(
        "Sources", "Frontend", "Objective-C", "ObjcParserAntlr"
    )

    copy_generated_files(output_path, target_parser_path)
