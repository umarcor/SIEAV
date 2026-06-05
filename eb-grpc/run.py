#!/usr/bin/env python3

from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv()
VU.add_vhdl_builtins()
VU.add_verification_components()
VU.enable_location_preprocessing()

ROOT = Path(__file__).parent

VU.add_library("lib").add_source_files([
  ROOT / "rtl/*.vhd",
  ROOT / "test/tb_*.vhd"
])

VU.main()
