#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

DIST=dbhi-gRPC/dist

"$DIST"/server & SERVER_PID=$!
echo "TEST SERVER: $SERVER_PID"

sleep 1

./cosim.py -v lib.tb_manager.* & MANAGER_PID=$!
echo "TEST MANAGER: $MANAGER_PID"

sleep 5

./cosim.py -v lib.tb_unit.* & UNIT_PID=$!
echo "TEST UNIT: $UNIT_PID"

while kill -0 $UNIT_PID >/dev/null 2>&1; do sleep 1; done

sleep 5

kill $SERVER_PID
