# Requires Python 3.10.0 or later.

from generator_paths import grammars_package_path
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
