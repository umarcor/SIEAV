#!/usr/bin/env python3

from os import environ, name
from pathlib import Path
from subprocess import check_call
from vunit import VUnit

ROOT = Path(__file__).resolve().parent

VU = VUnit.from_argv()
VU.add_verification_components()

LIB = VU.add_library("lib")
LIB.add_source_files([
    ROOT / "src" / "*.vhd",
    ROOT / "test" / "*.vhd",
])

check_call(["gcc", "-fPIC", "-shared", str(ROOT / "c" / "caux.c"), "-o",
    # FIXME: it should be possible to use a custom location on Windows (MSYS2) or with LLVM backend, instead of PWD;
    #        currently it works with mcode on Linux only
    # str(ROOT / "libcaux.so")
    "libcaux.so"
])

# FIXME: this should allow LLVM to compile on Linux, regardless of the custom location of libcaux.so;
#        it does not; moreover, it cannot be used with mcode backend (-Wl is not supported)
#for tb in LIB.get_test_benches(pattern="*tb_axi*", allow_empty=False):
#    tb.set_sim_option("ghdl.elab_flags", ["-Wl,-L" + str(ROOT), "-Wl,-lcaux"])

# FIXME: maybe these can be used on Windows (MSYS2)?
#LDVAR = "PATH"
#PSEP = ";"

if name == 'posix':
    LDVAR = "LD_LIBRARY_PATH"
    LDPATH = environ.get(LDVAR)
    # FIXME: libcaux.so should be located in ROOT, so here str(ROOT) should be added instead of "."
    environ[LDVAR] = (LDPATH + ":" if LDPATH else '') + "."

VU.main()
