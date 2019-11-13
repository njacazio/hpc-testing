#!/bin/bash

# Script to check wether a certain PID is running, refresh rate is every 30 seconds
while kill -0 "$1" >/dev/null 2>&1; do
    # echo "PROCESS $1 IS RUNNING"
    sleep 30
    continue
done

echo "JOB PID $1 just terminated at $(date)"
echo "-- run $1 terminated in ${PWD}" >> ../mon.log
