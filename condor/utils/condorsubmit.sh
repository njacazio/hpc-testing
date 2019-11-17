#!/bin/bash

if [[ ! -f "initCE.sh" ]]; then
    echo "Please provide a initCE.sh file"
    exit
fi

source "initCE.sh"

echo "Submitting Job"

SUBFILE="p308.sub"
SUBLOGFILE="jobsubmit.log"
date | tee -a $SUBLOGFILE
set -x
CONDORJOBID=$(condor_submit -pool ${CE}:${PORT} -remote ${CE} -spool ${SUBFILE})
set +x

echo "${CONDORJOBID}" | tee -a $SUBLOGFILE

EXECFILE=$(cat ${SUBFILE} | grep executable)
EXECFILE=${EXECFILE#*=}
echo "Setup of submitted job"
TOCHECK="WORKERS NEVENTSPERWORK NEVENTS GENERATOR EXTRAOPT NINSTANCES TIMEOUT O2VERS"

for i in $TOCHECK; do
    cat $EXECFILE | grep "export $i=" | grep --invert-match "#" | tail -n1 | tee -a $SUBLOGFILE
done
