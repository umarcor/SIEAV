from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).resolve().parent

vu = VUnit.from_argv()
lib = vu.add_library("lib").add_source_files([
    ROOT / "src" / "*.vhd",
    ROOT / "test" / "*.vhd",
])
vu.main()
