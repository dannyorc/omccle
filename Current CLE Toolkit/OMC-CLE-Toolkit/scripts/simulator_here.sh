#!/bin/bash

## Disclaimer:
## "All scripts and data files provided in this workshop were written by the presenter 
## for the purposes of the workshop and are not to be used outside of the workshop.  
## Oracle will not take any responsibility for its use outside of the workshop."

## Discription:
## This script is meant to send some files to the remote machine, then start
## the execution of another script on that machine as well. The script will
## abstract intereaction on the machine so we can see the data in OMC.

## Author:
## Zachary Hamilton
## zach.hamilton@oracle.com

## BEGIN SCRIPT BODY
##
echo "Preparing to simulate..."
SCRIPT_HOME=$(cd $(dirname $0); pwd)
cd $SCRIPT_HOME
cd ../config
PUBLIC_IP=`grep "^PUBLIC_IP" setup.properties | awk -F= '{print $2}'`
if [ -z "$PUBLIC_IP" ]; then
   echo "ERROR: Missing value for PUBLIC_IP in file properties file..." 
   MANDATORY_PROPS_SET=NO
fi
if [ "$MANDATORY_PROPS_SET" = "NO" ]; then
   echo "ERROR: Unable to extract public IP, exiting..."
   exit
fi
cd ../scripts
echo "Simulating..."
echo "Simulation: executing simulator_there.sh on remote machine..."
ssh -i ../.ssh/cloudkey oracle@${PUBLIC_IP} 'bash' < simulator_there.sh &
wait $!
echo "Simulation sent to run in the background!"
exit
##
## END SCRIPT BODY