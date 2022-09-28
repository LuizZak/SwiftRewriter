# Requires Python 3.10.0 or later.

import sys
import subprocess

from antlr_grammar_gen import (
    build_swift_gen_transformer,
    validate_antlr_version,
)
from objc_grammar_gen import generate_objc_antlr_grammar


def do_parser_generation():
    validate_antlr_version()

    print("Prebuilding Swift project...")
    build_swift_gen_transformer()

    generate_objc_antlr_grammar()

    print("Success!")


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
