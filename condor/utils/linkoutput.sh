#!/bin/bash

if [[ -f $1/htcp308.out ]]; then
    SIMTAG=$(grep -F "SimTag=" $1/htcp308.out)
    SIMTAG=${SIMTAG#SimTag=}
    # echo ${SIMTAG}
    if [[ ! -z $SIMTAG ]]; then
        echo "Linking $1 to tag: $SIMTAG"
        ln -sfn $1 ${SIMTAG}
    fi
    NINST=$(cat $1/htcp308.out | grep "N Inst    =" | head -1)
    NINST=${NINST#N Inst    = }
    if [[ ! -z $NINST ]]; then
        echo "So far terminated $(cat $1/htcp308.out | grep "just terminated" | wc -l)/$NINST instances"
    fi
fi