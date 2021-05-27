from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).resolve().parent

VU = VUnit.from_argv()
VU.add_verification_components()

VU.add_library("lib").add_source_files([
    ROOT / "src" / "*.vhd",
    ROOT / "test" / "*.vhd",
])

VU.main()
