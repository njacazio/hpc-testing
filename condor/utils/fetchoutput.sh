#!/bin/bash

if [[ ${1} == "-h" ]]; then
    echo "Please provide JobID as argument to fetch its output!"
    echo "If a second argument is given this is used as a tag"
    exit
fi

JOBID=${1}

if [[ -z ${JOBID} ]]; then
    echo "Please pass JobID"
    exit
fi

if [[ ! -f "initCE.sh" ]]; then
    echo "Please provide a initCE.sh file"
    exit
fi

source "initCE.sh"

echo "Retrieving output for JobID ${JOBID} $(date)"

JOBTARGETDIR="output/${JOBID}"

mkdir -v -p "${JOBTARGETDIR}"

pushd ${JOBTARGETDIR}
condor_transfer_data -name ${CE} -pool ${CE}:${PORT} ${JOBID}
echo "Output content:"
ls
popd

ln -sfn ${JOBTARGETDIR} latest

./utils/linkoutput.sh ${JOBTARGETDIR}
