from os import PathLike
from pathlib import Path

SOURCE_ROOT_PATH = Path(__file__).parents[1]
SCRIPTS_ROOT_PATH = Path(__file__).parents[0]
GRAMMARS_ROOT_PATH = Path(__file__).parents[1].joinpath("AntlrGrammars")
GRAMMAR_TRANSFORMER_ROOT_PATH = GRAMMARS_ROOT_PATH.joinpath("GrammarTransformer")


def path(root: Path | str, *args: str | PathLike[str]) -> Path:
    return Path(root).joinpath(*args)


def srcroot_path(*args: str | PathLike[str]) -> Path:
    return path(SOURCE_ROOT_PATH, *args)


def scripts_path(*args: str | PathLike[str]) -> Path:
    return path(SCRIPTS_ROOT_PATH, *args)


def grammars_path(*args: str | PathLike[str]) -> Path:
    return path(GRAMMARS_ROOT_PATH, *args)


def grammar_transformer_package_path(*args: str | PathLike[str]) -> Path:
    return path(GRAMMAR_TRANSFORMER_ROOT_PATH, *args)


def make_relative(
    base_path: str | PathLike[str], other_path: str | PathLike[str]
) -> Path:
    return Path(other_path).relative_to(base_path)
