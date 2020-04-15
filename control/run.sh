#!/bin/sh

set -e

cd $(dirname $0)

mkdir -p wrk

ghdl_args="--std=08 --workdir=wrk"

echo "> Analyze src"
ghdl -a $ghdl_args ./src/*

echo "> Analyze test"
ghdl -a $ghdl_args ./test/*

for item in "soft_singleproc" "soft_singleproc_bin" "soft_singleproc_binvec"; do
  echo "> Analyze elaborate and run $item"
  ghdl --elab-run $ghdl_args tb_"$item" --wave=wave_"$item".ghw
done
