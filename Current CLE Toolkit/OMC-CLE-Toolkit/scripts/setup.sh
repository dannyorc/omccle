#!/bin/bash

## Disclaimer:
## "All scripts and data files provided in this workshop were written by the presenter 
## for the purposes of the workshop and are not to be used outside of the workshop.  
## Oracle will not take any responsibility for its use outside of the workshop."

## Discription:
## "This script is meant to pull some mandatory properties from the file, 
## 'setup.properties' in order to send some resources to the remote machine.
## When those reasource have been successfully transferred to the remote
## machine, a script will be run against it in order to finish the final
## components of the setup and configuration process."

## Author:
## Zachary Hamilton
## zach.hamilton@oracle.com

## BEGIN SCRIPT BODY
##
SCRIPT_HOME=$(cd $(dirname $0); pwd)
cd $SCRIPT_HOME

## Grab the public IP from the properties file.
echo "Running setup.sh from $(pwd)..."
cd ../config
PUBLIC_IP=`grep "^PUBLIC_IP" setup.properties | awk -F= '{print $2}'`
if [ -z "$PUBLIC_IP" ]; then
   echo "ERROR: Missing value for PUBLIC_IP in properties file..." 
   MANDATORY_PROPS_SET=NO
fi
#
if [ "$MANDATORY_PROPS_SET" = "NO" ]; then
   echo "ERROR: Mandatory Properties not set, exiting..."
   exit
fi

## Elevate the oracle user on the remote machine to access the 
## machine's log file directory.
cd ../
echo "Connecting as opc and granting +rx to oracle for /var/log/*..."
ssh -i .ssh/cloudkey opc@${PUBLIC_IP} 'sudo setfacl -m 'u:oracle:rx' /var/log/*'

## Send the configuration folder to the remote machine so the
## machine can use the properties and run the remaining scripts. 
echo "Sending configuration folder..."
scp -i .ssh/cloudkey -r config oracle@${PUBLIC_IP}:/home/oracle &
wait $!

## Send the .zip file containing the cloudagent software to be
## setup and installed on the other machine. 
cd download_agent_here
chmod 700 cloudagent_*.zip
echo "Sending cloud agent software to database host..."
scp -i ../.ssh/cloudkey cloudagent_*.zip oracle@${PUBLIC_IP}:/home/oracle &
wait $!

## Connect to the remote host, and run the db_setup.sh script over
## there to finish up the setup. 
cd ../scripts
echo "Attempting to connect to database host..."
echo "Running db_setup.sh script on database host..."
ssh -i ../.ssh/cloudkey oracle@${PUBLIC_IP} 'bash' < db_setup.sh &
echo "Returned to local...."
echo "Done with setup here..."
##
## END SCRIPT BODY