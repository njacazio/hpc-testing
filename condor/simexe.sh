#!/bin/bash

cat /proc/cpuinfo
echo $X509_USER_PROXY
ls $X509_USER_PROXY

# Parameters to be set
export WORKERS=1
export NEVENTS=1
export NEVENTS=$(( $WORKERS*5 ))
export NEVENTS=500
export GENERATOR="pythia8"
export EXTRAOPT="--skipModules ZDC CPV MID"
export NINSTANCES=1

echo "==========="
echo "Sim. Setup "
echo "==========="
echo "N workers =" $WORKERS
echo "N events  =" $NEVENTS
echo "Generator =" $GENERATOR
echo "Extra Opt =" $EXTRAOPT
echo "N Inst    =" $NINSTANCES
echo "SimTag= ${NEVENTS}ev_${WORKERS}w_${NINSTANCES}i_${GENERATOR}"

# Copy the input files via xrd
FILETOGET="run.sh domon.sh getperf.py shiptoalien.sh"
for I in $FILETOGET; do
    singularity exec --bind /cvmfs \
    /cvmfs/alice-nightlies.cern.ch/singularity/alisw/slc7-builder -c \
    /cvmfs/alice-nightlies.cern.ch/bin/alienv setenv VO_ALICE@AliEn-ROOT-Legacy::0.1.1-3 -c \
    xrdcp $SWSRC//$I .
    chmod a+x $I
done


USER=$(whoami)
id $USER

echo "---------------"

ls /tmp/

echo "---------------"

pwd

ls -la

echo "Running run.sh"
./domon.sh &

PROCESSES=""
for (( n=1; n<=$NINSTANCES; n++ )); do
    mkdir -v ./$n
    pushd ./$n
    for I in $FILETOGET; do
        cp ../$I .
    done
    singularity exec --bind /cvmfs,/scratch_local,/marconi_scratch /cvmfs/alice-nightlies.cern.ch/singularity/alisw/slc7-builder \
    /cvmfs/alice-nightlies.cern.ch/bin/alienv setenv VO_ALICE@AliEn-ROOT-Legacy::0.1.1-3 -c \
    /cvmfs/alice-nightlies.cern.ch/bin/alienv setenv O2/nightly-20190710-1 -c \
    ./run.sh 1>simlog.out 2>simlog.err &
    PROCESSES="$PROCESSES $!"
    echo "Sumbitted instance $n/${NINSTANCES} with PID $!"
    popd
done

# Waiting for all processes to finish
echo "ALL JOBS PIDs: $PROCESSES"
for i in $PROCESSES; do
    echo "Waiting job $i"
    wait $i
    echo "job done!"
done

echo "All jobs are done!"

ps aux|grep domon|awk '{print "kill -9",$2}'|bash
ls -altr

echo "Printing monitoring log"
cat mon.log

echo "Printing monitoring pslog"
cat psmon.txt

singularity exec --bind /cvmfs \
/cvmfs/alice-nightlies.cern.ch/singularity/alisw/slc7-builder -c \
/cvmfs/alice-nightlies.cern.ch/bin/alienv setenv VO_ALICE@AliEn-ROOT-Legacy::0.1.1-3 -c \
./shiptoalien.sh
