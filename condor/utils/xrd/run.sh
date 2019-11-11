#!/bin/bash

echo "check proxy -> " $X509_USER_PROXY
ls -l $X509_USER_PROXY

export jobid=$(echo $X509_USER_PROXY|awk -F"/" '{print $6}')

rm /tmp/x509up_u$UID
ln -s $X509_USER_PROXY /tmp/x509up_u$UID
ls -l /tmp/x509up_u$UID

alien-token-init $ALIEN_USR
alien-token-info

echo "N workers =" $WORKERS
echo "N events  =" $NEVENTS
echo "Generator =" $GENERATOR 
echo "Extra Opt =" $EXTRAOPT

#echo "Simulation starts" >> mon.log
o2-sim -j $WORKERS -n $NEVENTS -g $GENERATOR $EXTRAOPT |tee sim.log

#echo "Digitization starts" >> mon.log
#o2-sim-digitizer-workflow --tpc-lanes $WORKERS |tee digitization.log

zip output.zip *log* *.out *.err 
ls -l output.zip
alien_mkdir /alice/cern.ch/user/${ALIEN_USR:0:1}/${ALIEN_USR}/hpctest/$jobid
echo "alien_cp output.zip alien:/alice/cern.ch/user/n/${ALIEN_USR}/hpctest/"$jobid"/output.zip"
alien_cp output.zip alien:/alice/cern.ch/user/${ALIEN_USR:0:1}/${ALIEN_USR}/hpctest/$jobid/output.zip

ps aux|grep domon|awk '{print "kill -9",$2}'|bash


