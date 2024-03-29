from os import PathLike
import subprocess

from typing import Any
from paths import make_relative, srcroot_path

from console_color import ConsoleColor


def run_output(
    bin_name: str, *args: Any, cwd: str | PathLike | None = None, echo: bool = True
) -> str:
    if echo:
        if cwd is not None:
            rel = make_relative(srcroot_path("."), cwd)

            print(ConsoleColor.MAGENTA(f"{rel}>", bin_name, *list(args)))
        else:
            print(ConsoleColor.MAGENTA(">", bin_name, *list(args)))

    return (
        subprocess.check_output([bin_name] + list(args), cwd=cwd).decode("UTF8").strip()
    )


def run(
    bin_name: str,
    *args: Any,
    cwd: str | PathLike | None = None,
    echo: bool = True,
    silent: bool = False,
):
    if echo:
        if cwd is not None:
            rel = make_relative(srcroot_path("."), cwd)

            print(ConsoleColor.MAGENTA(f"{rel}>", bin_name, *list(args)))
        else:
            print(ConsoleColor.MAGENTA(">", bin_name, *list(args)))

    if silent:
        subprocess.check_output([bin_name] + list(args), cwd=cwd)
    else:
        subprocess.check_call([bin_name] + list(args), cwd=cwd)
