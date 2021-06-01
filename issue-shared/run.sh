#!/usr/bin/env sh

set -e

cd $(dirname "$0")

ORIG_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"

ghdl -a tb.vhd

gcc -shared caux.c -o libcaux.so

export LD_LIBRARY_PATH="$ORIG_LD_LIBRARY_PATH:$(pwd)"

ghdl elab-run tb
