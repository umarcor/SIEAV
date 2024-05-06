#!/usr/bin/env python3

from pathlib import Path
from vunit import VUnit

ROOT = Path(__file__).resolve().parent

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()
vu.add_vhdl_builtins()

# Create library 'lib'
lib = vu.add_library("lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files(ROOT / "*.vhd")

# Run vunit function
vu.main()
