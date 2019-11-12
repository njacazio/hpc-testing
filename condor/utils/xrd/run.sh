#!/bin/bash

echo "N workers =" $WORKERS
echo "N events  =" $NEVENTS
echo "Generator =" $GENERATOR
echo "Extra Opt =" $EXTRAOPT
echo "N Inst    =" $NINSTANCES
pwd

#echo "Simulation starts" >> mon.log
o2-sim -j $WORKERS -n $NEVENTS -g $GENERATOR $EXTRAOPT |tee sim.log

#echo "Digitization starts" >> mon.log
#o2-sim-digitizer-workflow --tpc-lanes $WORKERS |tee digitization.log

date

echo "-- run terminated" >> ../mon.log
echo "-- ${PWD}" >> ../mon.log

