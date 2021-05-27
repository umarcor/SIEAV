#!/usr/bin/env python3

from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).resolve().parent

VU = VUnit.from_argv()
VU.add_verification_components()

LIB = VU.add_library("lib")
LIB.add_source_files([
    ROOT / "src" / "*.vhd",
    ROOT / "test" / "*.vhd",
])

for tb in LIB.get_test_benches(pattern="*tb_axi*", allow_empty=False):
    tb.set_sim_option("ghdl.elab_flags", ["-Wl," + str(ROOT / "c" / "caux.c")])

VU.main()
