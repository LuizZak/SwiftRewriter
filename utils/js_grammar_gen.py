# Requires Python 3.10.0 or later.

import shutil
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


def generate_js_antlr_grammar():
    base_path = grammars_path("JsGrammar")

    print(
        f"Generating JavaScript grammar files @ {ConsoleColor.CYAN(make_relative(SOURCE_ROOT_PATH, base_path))}..."
    )

    output_path = base_path.joinpath("gen")
    grammar_files = [
        base_path.joinpath("JavaScriptLexer.g4"),
        base_path.joinpath("JavaScriptParser.g4"),
    ]

    generate_antlr_grammar(output_path, grammar_files)

    # Copy -LexerBase.swift/-ParserBase.swift to generated folder
    lexer_file_name = "JavaScriptLexerBase.swift"
    parser_file_name = "JavaScriptParserBase.swift"

    lexer_base = base_path.joinpath(lexer_file_name)
    parser_base = base_path.joinpath(parser_file_name)

    lexer_base_target = output_path.joinpath(lexer_file_name)
    parser_base_target = output_path.joinpath(parser_file_name)

    shutil.copy(lexer_base, lexer_base_target)
    shutil.copy(parser_base, parser_base_target)

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
        "Sources",
        "Frontend",
        "JavaScript",
        "JsParserAntlr",
    )

    copy_generated_files(output_path, target_parser_path)
