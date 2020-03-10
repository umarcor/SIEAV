"""
Octave: regular VUnit simulation
"""

import csv
from os import makedirs
from os.path import join, dirname, isdir
from random import randrange
from vunit import VUnit

SRC = join(dirname(__file__), "src")

vu = VUnit.from_argv()

vu.add_array_util()
vu.add_verification_components()

vu.add_library("lib").add_source_files(
    [
        join(SRC, "*.vhd"),
        join(SRC, "test", "tb_vc_axis_stage.vhd"),
        join(SRC, "test", "tb_py_axis_stage.vhd"),  # add 'py' testbench only
    ]
)

MAT = [[randrange(255) for e in range(20)] for e in range(40)]

DATA = join(SRC, "test", "data")

if not isdir(DATA):
    makedirs(DATA)

with open(join(DATA, "in.csv"), mode="w") as fptr:
    HND = csv.writer(fptr, delimiter=",", quotechar='"', quoting=csv.QUOTE_MINIMAL)
    for ind in range(10):
        HND.writerow(MAT[ind])

vu.main()
