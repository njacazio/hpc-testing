#!/bin/bash

CONDOR_Q_FILE_M="condorqueue_masters.txt"
CONDOR_Q_FILE_O="condorqueue_orphans.txt"

while [[ 1 ]]; do
    ./utils/filterqueue.sh
    if [[ ! -f $CONDOR_Q_FILE_M ]]; then
        echo "Master job file not found"
        exit
    fi
    if [[ ! -f $CONDOR_Q_FILE_O ]]; then
        echo "Orphan job file not found"
        exit
    fi
    
    MASTERJOBS=$(cat $CONDOR_Q_FILE_M | xargs)
    ORPHANJOBS=$(cat $CONDOR_Q_FILE_O | xargs)
    echo "Fetching master jobs"
    for i in $MASTERJOBS; do
        ./utils/fetchoutput.sh $i
    done
    echo "Fetching orphan jobs"
    for i in $ORPHANJOBS; do
        ./utils/fetchoutput.sh $i
    done
    sleep 1800
done
