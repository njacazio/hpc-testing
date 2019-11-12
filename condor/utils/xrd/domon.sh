#!/bin/bash

function psmon() {
    echo --- >> psmon.txt
    ps -u $USER -ww -o pid=,ppid=,etimes=,cputime=,vsz=,rsz=,drs=,trs=,cmd= >> psmon.txt
}

while :
do
    ./getperf.py >>mon.log
    psmon
    sleep 60
done
