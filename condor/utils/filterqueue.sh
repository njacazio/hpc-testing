#!/bin/bash

CONDOR_Q_FILE="condorqueue.txt"
if [[ ${1} == "-h" ]]; then
    echo "Script to filter only ALICE jobs in the queue"
    exit
fi

./checkqueue.sh -b

ALICEJOBTAG="cms"
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
SLAVEJOBS=""
ORPHANJOBS=""
for i in $ALICEJOBS; do
    # echo $i
    if [[ $SLAVEJOBS == *"$i"* ]]; then
        continue
    fi
    SLAVE=$i
    ((SLAVE++))
    # echo "SlaveJob $SLAVE"
    if [[ ${ALICEJOBS} == *"${SLAVE}"* ]]; then
        # echo "Is a good master"
        MASTERJOBS="$MASTERJOBS $i"
        SLAVEJOBS="$SLAVEJOBS $SLAVE"
    else
        ORPHANJOBS="$ORPHANJOBS $i"
    fi
done

echo "MASTERS: $MASTERJOBS"
echo $MASTERJOBS > "${CONDOR_Q_FILE%.txt}_masters.txt"
echo "SLAVES: $SLAVEJOBS"
echo $SLAVEJOBS > "${CONDOR_Q_FILE%.txt}_slaves.txt"
echo "ORPHANS: $ORPHANJOBS"
echo $ORPHANJOBS > "${CONDOR_Q_FILE%.txt}_orphans.txt"
