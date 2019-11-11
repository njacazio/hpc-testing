#!/bin/bash
while :
do
        ./getperf.py >>mon.log
	sleep 60
done
