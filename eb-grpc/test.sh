#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

DIST=dbhi-gRPC/dist

"$DIST"/server & SERVER_PID=$!
echo "TEST SERVER: $SERVER_PID"

sleep 1

LD_LIBRARY_PATH="$(pwd)/$DIST" "$DIST"/ghdl-manager & MANAGER_PID=$!
echo "TEST MANAGER: $MANAGER_PID"

sleep 2

LD_LIBRARY_PATH="$(pwd)/$DIST" "$DIST"/ghdl-unit & UNIT_PID=$!
echo "TEST UNIT: $UNIT_PID"

sleep 5

while kill -0 $MANAGER_PID >/dev/null 2>&1; do sleep 1; done
kill $UNIT_PID $SERVER_PID
