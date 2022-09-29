# Requires Python 3.10.0 or later.

import sys
import subprocess

from antlr_grammar_gen import (
    build_swift_gen_transformer,
    validate_antlr_version,
)
from objc_grammar_gen import generate_objc_antlr_grammar
from js_grammar_gen import generate_js_antlr_grammar
from paths import GRAMMAR_TRANSFORMER_ROOT_PATH, SOURCE_ROOT_PATH, make_relative
from console_color import ConsoleColor


def do_parser_generation():
    validate_antlr_version()

    print(
        f"Prebuilding Swift project @ {make_relative(SOURCE_ROOT_PATH, GRAMMAR_TRANSFORMER_ROOT_PATH)}..."
    )
    build_swift_gen_transformer()

    generate_objc_antlr_grammar()
    generate_js_antlr_grammar()

    print(ConsoleColor.GREEN("Success!"))


def main() -> int:
    do_parser_generation()

    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as err:
        sys.exit(err.returncode)
    except KeyboardInterrupt:
        sys.exit(1)
