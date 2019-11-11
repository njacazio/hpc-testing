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

# Copy the input files via xrd
FILETOGET="run.sh domon.sh getperf.py"
for I in $FILETOGET; do
singularity exec --bind /cvmfs \
/cvmfs/alice-nightlies.cern.ch/singularity/alisw/slc7-builder -c \
/cvmfs/alice-nightlies.cern.ch/bin/alienv setenv VO_ALICE@AliEn-ROOT-Legacy::0.1.1-3 -c \
xrdcp $SWSRC//$I .
done

chmod a+x run.sh

USER=$(whoami)
id $USER

echo "---------------"

ls /tmp/

echo "---------------"

pwd

ls -la

echo "Running run.sh"
chmod a+x domon.sh
chmod a+x getperf.py
./domon.sh &

singularity exec --bind /cvmfs,/scratch_local,/marconi_scratch /cvmfs/alice-nightlies.cern.ch/singularity/alisw/slc7-builder \
/cvmfs/alice-nightlies.cern.ch/bin/alienv setenv VO_ALICE@AliEn-ROOT-Legacy::0.1.1-3 -c \
/cvmfs/alice-nightlies.cern.ch/bin/alienv setenv O2/nightly-20190710-1 -c \
./run.sh

echo "Done!"

ls -altr

echo "Printing monitoring log"
cat mon.log
