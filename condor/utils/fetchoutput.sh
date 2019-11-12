#!/bin/bash

if [[ ${1} == "-h" ]]; then
    echo "Please provide JobID as argument to fetch its output!"
    echo "If a second argument is given this is used as a tag"
    exit
fi

JOBID=${1}
JOBTAG=${@:2}

if [[ -z ${JOBID} ]]; then
    echo "Please pass JobID"
    exit
fi

if [[ ! -f "initCE.sh" ]]; then
    echo "Please provide a initCE.sh file"
    exit
fi

source "initCE.sh"

echo "Retrieving output for JobID ${JOBID}"

condor_transfer_data -name ${CE} -pool ${CE}:${PORT} ${JOBID}

JOBTARGETDIR="output/${JOBID}"

mkdir -v -p "${JOBTARGETDIR}"

TOMOVE="htcp308.log htcp308.out htcp308.err"
for i in ${TOMOVE}; do
    mv -v $i "${JOBTARGETDIR}/"
done

ln -sfn ${JOBTARGETDIR} latest

if [[ -z ${JOBTAG} ]]; then
    ln -sfn ${JOBTARGETDIR} ${JOBTAG}
fi

