#!/bin/bash
echo "check proxy -> " $X509_USER_PROXY
ls -l $X509_USER_PROXY

export jobid=$(echo $X509_USER_PROXY|awk -F"/" '{print $6}')

rm /tmp/x509up_u$UID
ln -s $X509_USER_PROXY /tmp/x509up_u$UID
ls -l /tmp/x509up_u$UID

alien-token-init $ALIEN_USR
alien-token-info

echo "Preparing output to be shipped to alien"
zip output.zip *log* *.out *.err */simlog.*
ls -l output.zip
ALIEN_OUTPUTDIR=/alice/cern.ch/user/${ALIEN_USR:0:1}/${ALIEN_USR}/hpctest/$jobid
alien_mkdir $ALIEN_OUTPUTDIR
echo "alien_cp output.zip alien:$ALIEN_OUTPUTDIR/output.zip"
alien_cp output.zip alien:$ALIEN_OUTPUTDIR/output.zip
ls -altr
