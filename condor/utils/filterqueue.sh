#!/bin/bash

CONDOR_Q_FILE="condorqueue.txt"
if [[ ${1} == "-h" ]]; then
    echo "Script to filter only ALICE jobs in the queue"
    exit
fi

./utils/checkqueue.sh -b

ALICEJOBTAG="ali"
NALICEJOBS=0
ALICEJOBS=""
while read line; do
    # echo $line
    if [[ $line == *"${ALICEJOBTAG}"* ]]; then
        # echo "Has ${ALICEJOBTAG}"
        ((NALICEJOBS++))
        JOBID=$(echo ${line#*ID:} | head -n1 | awk '{print $1;}')
        # echo $JOBID
        ALICEJOBS="$ALICEJOBS $JOBID"
    fi
done < $CONDOR_Q_FILE

echo "Found ${NALICEJOBS} jobs for ALICE"
echo $ALICEJOBS

MASTERJOBS=""
SERVANTJOBS=""
ORPHANJOBS=""
for i in $ALICEJOBS; do
    # echo $i
    if [[ $SERVANTJOBS == *"$i"* ]]; then
        continue
    fi
    SERVANT=$i
    ((SERVANT++))
    # echo "ServantJob $SERVANT"
    if [[ ${ALICEJOBS} == *"${SERVANT}"* ]]; then
        # echo "Is a good master"
        MASTERJOBS="$MASTERJOBS $i"
        SERVANTJOBS="$SERVANTJOBS $SERVANT"
    else
        ORPHANJOBS="$ORPHANJOBS $i"
    fi
done

echo "MASTERS: $MASTERJOBS"
echo $MASTERJOBS > "${CONDOR_Q_FILE%.txt}_masters.txt"
echo "SERVANTS: $SERVANTJOBS"
echo $SERVANTJOBS > "${CONDOR_Q_FILE%.txt}_servants.txt"
echo "ORPHANS: $ORPHANJOBS"
echo $ORPHANJOBS > "${CONDOR_Q_FILE%.txt}_orphans.txt"
