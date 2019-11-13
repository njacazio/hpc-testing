#!/bin/bash

CONDOR_Q_FILE="condorqueue_masters.txt"

if [[ ! -f $CONDOR_Q_FILE ]]; then
    echo "Master job file not found"
    exit
fi

while [[ 1 ]]; do
    ./utils/filterqueue.sh
    MASTERJOBS=$(cat $CONDOR_Q_FILE | xargs)
    for i in $MASTERJOBS; do
        ./utils/fetchoutput.sh $i
    done
    sleep 1800
done
