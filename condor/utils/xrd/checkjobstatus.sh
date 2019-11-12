#!/bin/bash

while kill -0 "$1" >/dev/null 2>&1; do
    # echo "PROCESS $1 IS RUNNING"
    sleep 1
    continue
done

echo "JOB PID $1 just terminated"
echo "-- run $1 terminated in ${PWD}" >> ../mon.log
