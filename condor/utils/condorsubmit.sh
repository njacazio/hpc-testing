#!/bin/bash

if [[ ! -f "initCE.sh" ]]; then
    echo "Please provide a initCE.sh file"
    exit
fi

source "initCE.sh"

echo "Submitting Job"

set -x
condor_submit -pool ${CE}:${PORT} -remote ${CE} -spool p308.sub
set +x
