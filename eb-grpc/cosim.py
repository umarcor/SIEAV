#!/usr/bin/env python3

from os import environ, name
from pathlib import Path
from vunit import VUnit

VU = VUnit.from_argv()
VU.add_vhdl_builtins()
VU.add_verification_components()
VU.enable_location_preprocessing()

ROOT = Path(__file__).parent
DIST = ROOT / 'dbhi-grpc/dist'

lib = VU.add_library("lib")
lib.add_source_files([
  ROOT / "rtl/*.vhd",
  ROOT / "test/cosim/tb_*.vhd"
])

for module in ["manager", "unit"]:
  for tb in lib.get_test_benches(pattern=f"*tb_{module}", allow_empty=False):
    tb.set_sim_option("ghdl.elab_flags", [f"-Wl,{item}" for item in [
      ROOT / f"test/cosim/{module}.c",
      f"-I{DIST}",
      f"-L{DIST}",
      "-lgrpc-go"
    ]])

# TODO: Ask Tristan (create issue in ghdl/ghdl) to support OPTION in `-Wl,<OPTION>` containing commas:
# -Wl,../test/cosim/$(TNAME).c,-I../$(DIST),-L../$(DIST),-lgrpc-go
# https://ghdl.github.io/ghdl/using/CommandReference.html#cmdoption-ghdl-Wl-OPTION

if name == 'posix':
  LDPATH = environ.get("LD_LIBRARY_PATH")
  environ["LD_LIBRARY_PATH"] = f"{DIST}:{LDPATH}" if LDPATH else str(DIST)

VU.main()
