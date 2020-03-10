"""
Octave: cosimulation based on VHPIDIRECT
"""

from sys import argv
from os import makedirs
from os.path import join, dirname
from subprocess import check_call
from shutil import copyfile
import re
from vunit import VUnit, ROOT


PROOT = join(dirname(__file__), "..")
EXT_SRCS = join(ROOT, "vunit", "vhdl", "data_types", "src", "external", "ghdl")
BUILD_ONLY = False
if "--build" in argv:
    argv.remove("--build")
    BUILD_ONLY = True

# Compile C applications to objects
C_OBJ = join(PROOT, "c", "main.o")

check_call(
    [
        "gcc",
        "-fPIC",
        "-DTYPE=int32_t",
        "-I",
        EXT_SRCS,
        "-c",
        join(PROOT, "c", "main.c"),
        "-o",
        C_OBJ,
    ]
)

# Enable the external feature for strings/byte_vectors and integer_vectors
vu = VUnit.from_argv(vhdl_standard="2008", compile_builtins=False)
vu.add_builtins({"string": True, "integer": True})
vu.add_array_util()
vu.add_verification_components()

LIB = vu.add_library("lib")
LIB.add_source_files(
    [
        join(PROOT, "..", "srcs", "*.vhd"),
        join(PROOT, "*.vhd"),
        join(PROOT, "c", "*.vhd"),  # add 'c' testbench only
    ]
)

# Add the C object to the elaboration of GHDL
for tb in LIB.get_test_benches(pattern="*tb_*", allow_empty=False):
    tb.set_sim_option(
        "ghdl.elab_flags",
        ["-Wl," + C_OBJ, "-Wl,-Wl,--version-script=" + join(EXT_SRCS, "grt.ver")],
        overwrite=True,
    )

if BUILD_ONLY:
    vu.set_sim_option("ghdl.elab_e", True)
    vu._args.elaborate = True  # pylint: disable=protected-access

    def post_func(results):
        """
        Copy runtime args for each test/executable to output dir 'cosim'
        """
        report = results.get_report()
        cosim_args_dir = join(report.output_path, "cosim")
        try:
            makedirs(cosim_args_dir)
        except FileExistsError:
            pass
        for key, val in report.tests.items():
            copyfile(
                join(val.path, "ghdl", "args.json"),
                join(cosim_args_dir, "%s.json" % re.search(r"lib\.(.+)\.all", key)[1]),
            )

    vu.main(post_run=post_func)
else:
    vu.main()
