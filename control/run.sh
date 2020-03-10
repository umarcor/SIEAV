#!/bin/sh

cd $(dirname $0)

mkdir -p wrk

ghdl_args="--std=08 --workdir=wrk"

ghdl -a $ghdl_args ./src/*
ghdl -a $ghdl_args ./test/*

ghdl --elab-run $ghdl_args tb --wave=wave.ghw

