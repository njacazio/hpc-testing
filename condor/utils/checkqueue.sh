#!/bin/bash

CONDOR_Q_FILE="condorqueue.txt"
if [[ ${1} == "-h" ]]; then
    echo "Output is written in a file: ${CONDOR_Q_FILE}"
    echo "-id JobID argument to check its status (optional)!"
    echo "-b to avoid printing output"
    exit
fi

DONTPRINT=""
JOBID=""
while [ -n "$1" ]; do # while loop starts
    case "$1" in
        -b) DONTPRINT="YES"
        ;;
        -id) JOBID="$2"
            shift
        ;;
        *) echo "Option $1 not recognized, aborting"
            exit
        ;; # In case you typed a different option other than a,b,c
    esac
    shift
done

source "initCE.sh"

condor_q -name $CE -pool $CE:$PORT ${JOBID} > ${CONDOR_Q_FILE}

if [[ -z $DONTPRINT ]]; then
    cat ${CONDOR_Q_FILE}
fi
