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

condor_transfer_data -name ${CE} -pool ${CE}:${PORT} ${JOBID}

JOBTARGETDIR="output/${JOBID}"

mkdir -v -p "${JOBTARGETDIR}"

TOMOVE="htcp308.log htcp308.out htcp308.err"
for i in ${TOMOVE}; do
    mv -v $i "${JOBTARGETDIR}/"
done

ln -sfn ${JOBTARGETDIR} latest

# set -x
if [[ -f latest/htcp308.out ]]; then
    SIMTAG=$(grep -F "SimTag=" latest/htcp308.out)
    SIMTAG=${SIMTAG#SimTag=}
    # echo ${SIMTAG}
    if [[ ! -z $SIMTAG ]]; then
        ln -sfn ${JOBTARGETDIR} ${SIMTAG}
    fi
    NINST=$(cat latest/htcp308.out | grep "N Inst    =" | head -1)
    NINST=${NINST#N Inst    = }
    if [[ ! -z $NINST ]]; then
        echo "So far terminated $(cat latest/htcp308.out | grep "just terminated" | wc -l)/$NINST"
    fi
fi
# set +x

