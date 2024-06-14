# Requires Python 3.10.0 or later.

import argparse
import sys
import subprocess

from antlr_grammar_gen import (
    build_swift_gen_transformer,
    validate_antlr_version,
)
from objc_grammar_gen import generate_objc_antlr_grammar
from js_grammar_gen import generate_js_antlr_grammar
from console_color import ConsoleColor


def do_parser_generation(antlr_version: str | None = None, skip_build: bool = False):
    validate_antlr_version(antlr_version)

    if not skip_build:
        print("Prebuilding Swift project...")
        build_swift_gen_transformer()

    generate_objc_antlr_grammar(antlr_version)
    generate_js_antlr_grammar(antlr_version)

    print(ConsoleColor.GREEN("Success!"))


def make_argparser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Facility for preparing Antlr grammar files for use in SwiftRewriter",
    )
    populate_argparser(parser)

    return parser


def populate_argparser(parser: argparse.ArgumentParser):
    parser.add_argument(
        "--antlr_version",
        type=str,
        dest="antlr_version",
        help="Optional ANTLR4 tag to pass during 'antlr4' invocations. If not specified, defaults to latest version from Maven, depending on how antlr4 was installed.",
    )
    parser.add_argument(
        "--skip-build",
        default=False,
        action="store_true",
        dest="skip_build",
        help="Whether to skip building the Swift AntlrGrammars package prior to generating the parser. May result in failures if the package is not already built.",
    )


def main() -> int:
    argparser = make_argparser()
    args = argparser.parse_args()

    do_parser_generation(args.antlr_version, args.skip_build)

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as err:
        sys.exit(err.returncode)
    except KeyboardInterrupt:
        sys.exit(1)
