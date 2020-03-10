"""
Octave: dynamically loading a simulation from Python

TODO This can be removed, since it seems a dup of buffer/cosim.py
"""

import sys
from os.path import join, dirname
from json import load
from cosim.utils import enc_args, dlopen, dlclose, int_buf, read_int_buf


with open(
    join(dirname(__file__), "vunit_out", "cosim", "tb_c_axis_stage.json")
) as json_file:
    ARGS = load(json_file)

XARGS = enc_args(ARGS)

print("\nREGULAR EXECUTION")
GHDL = dlopen(ARGS[0])
try:
    GHDL.main(len(XARGS) - 1, XARGS)
# TOFIX With VHDL 93, the execution is Aborted and Python exits here
except SystemExit as exc:
    if exc.code != 0:
        sys.exit(exc.code)
dlclose(GHDL)

print("\nPYTHON ALLOCATION")
GHDL = dlopen(ARGS[0])

DATA = [111, 122, 133, 144, 155]

BUF = [[] for c in range(2)]
BUF[1] = int_buf(DATA + [0 for x in range(2 * len(DATA))])

BUF[0] = int_buf(
    [-(2 ** 31) + 10, -(2 ** 31), 3, 0, len(DATA)]  # clk_step  # update  # block_length
)

for x, v in enumerate(BUF):
    GHDL.set_string_ptr(x, v)

for i, v in enumerate(read_int_buf(BUF[1])):
    print("py " + str(i) + ": " + str(v))

GHDL.ghdl_main(len(XARGS) - 1, XARGS)

for i, v in enumerate(read_int_buf(BUF[1])):
    print("py " + str(i) + ": " + str(v))

dlclose(GHDL)
