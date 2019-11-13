#!/bin/bash

echo "N workers =" $WORKERS
echo "N events  =" $NEVENTS
echo "Generator =" $GENERATOR
echo "Extra Opt =" $EXTRAOPT
echo "N Inst    =" $NINSTANCES
pwd

#echo "Simulation starts" >> mon.log

PROCESSES=""
MONITORPROCESSES=""
for (( n=1; n<=$NINSTANCES; n++ )); do
    mkdir -v ./$n
    pushd ./$n
    o2-sim -j $WORKERS -n $NEVENTS -g $GENERATOR $EXTRAOPT 1>simlog.out 2>simlog.err &
    PROCESSES="$PROCESSES $!"
    echo "Sumbitted instance $n/${NINSTANCES} with PID $!"
    ../checkjobstatus.sh "$!" &
    MONITORPROCESSES="$MONITORPROCESSES $!"
    popd
done

# Waiting for all processes to finish
echo "ALL JOBS PIDs: $PROCESSES"
for i in $MONITORPROCESSES; do
    wait $i
done

#echo "Digitization starts" >> mon.log
#o2-sim-digitizer-workflow --tpc-lanes $WORKERS |tee digitization.log

echo "run.sh terminated!"
date

