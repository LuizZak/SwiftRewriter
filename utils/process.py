from os import PathLike
import subprocess

from typing import Any


def run_output(bin_name: str, *args: Any, echo: bool = True) -> str:
    if echo:
        print(">", bin_name, *list(args))

    return subprocess.check_output([bin_name] + list(args)).decode("UTF8").strip()


def run(
    bin_name: str,
    *args: Any,
    cwd: str | PathLike | None = None,
    echo: bool = True,
    silent: bool = False,
):
    if echo:
        print(">", bin_name, *list(args))

    if silent:
        subprocess.check_output([bin_name] + list(args), cwd=cwd)
    else:
        subprocess.check_call([bin_name] + list(args), cwd=cwd)
