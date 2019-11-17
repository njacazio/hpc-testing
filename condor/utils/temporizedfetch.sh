#!/bin/bash

TIMETOSLEEP=1800
CONDOR_Q_FILE_M="condorqueue_masters.txt"
CONDOR_Q_FILE_S="condorqueue_servants.txt"
CONDOR_Q_FILE_O="condorqueue_orphans.txt"
CONDOR_Q_FILE_SUB="condorqueue_submitted.txt"
CONDOR_Q_FILES="$CONDOR_Q_FILE_M $CONDOR_Q_FILE_S $CONDOR_Q_FILE_O $CONDOR_Q_FILE_SUB"

while [[ 1 ]]; do
    echo "Fetching completed jobs at $(date)"
    ./utils/filterqueue.sh
    # Check on all queue files
    for i in $CONDOR_Q_FILES; do
        if [[ ! -f $i ]]; then
            echo "$i job queue file not found"
            exit
        fi
    done
    
    MASTERJOBS=$(cat $CONDOR_Q_FILE_M | xargs)
    SERVANTJOBS=$(cat $CONDOR_Q_FILE_S | xargs)
    ORPHANJOBS=$(cat $CONDOR_Q_FILE_O | xargs)
    SUBMITTEDJOBS=$(cat $CONDOR_Q_FILE_SUB | xargs)
    
    echo "Fetching submitted jobs"
    for i in $SUBMITTEDJOBS; do
        ./utils/fetchoutput.sh $i
    done
    
    echo "Fetching master jobs"
    for i in $MASTERJOBS; do
        # Checking job is already in submitted jobs
        if [[ $SUBMITTEDJOBS == *$i* ]]; then
            continue
        fi
        ./utils/fetchoutput.sh $i
    done
    
    echo "Fetching orphan jobs"
    for i in $ORPHANJOBS; do
        # Checking job is already in submitted jobs
        if [[ $SUBMITTEDJOBS == *$i* ]]; then
            continue
        fi
        ./utils/fetchoutput.sh $i
    done
    echo "temporizedfetch run completed, now waiting ${TIMETOSLEEP}s for next one!"
    sleep $TIMETOSLEEP
done

