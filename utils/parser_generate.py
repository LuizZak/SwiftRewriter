# Requires Python 3.10.0 or later.

import argparse
import sys
import subprocess

from antlr_grammar_gen import (
    build_swift_gen_transformer,
    validate_antlr_version,
)
from objc_grammar_gen import generate_objc_antlr_grammar


def do_parser_generation(antlr_version: str | None = None):
    validate_antlr_version(antlr_version)

    print("Prebuilding Swift project...")
    build_swift_gen_transformer()

    generate_objc_antlr_grammar(antlr_version)

    print("Success!")


def make_argparser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Facility for preparing Antlr grammar files for use in SwiftRewriter",
    )
    parser.add_argument(
        "--antlr_version",
        type=str,
        dest="antlr_version",
        help="Optional ANTLR4 tag to pass during 'antlr4' invocations. If not specified, defaults to latest version from Maven, depending on how antlr4 was installed.",
    )

    return parser


def main() -> int:
    argparser = make_argparser()
    args = argparser.parse_args()

    do_parser_generation(args.antlr_version)

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as err:
        sys.exit(err.returncode)
    except KeyboardInterrupt:
        sys.exit(1)
