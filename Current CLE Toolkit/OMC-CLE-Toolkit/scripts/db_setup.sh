#!/bin/bash

## Disclaimer:
## "All scripts and data files provided in this workshop were written by the presenter 
## for the purposes of the workshop and are not to be used outside of the workshop.  
## Oracle will not take any responsibility for its use outside of the workshop."

## Discription:
## "This script is meant to run on the database host machine in the cloud. The 
## scipt is used to unzip the software we previously sent over, extract properties
## from the config folder we sent over, and use those properties to setup the 
## agent.rsp file for the cloud agent. Once this is done, we install and register
## the agent with Oracle Management Cloud using the omcli.

## Author:
## Zachary Hamilton
## zach.hamilton@oracle.com

## BEGIN SCRIPT BODY
##
echo "Connected to database host..."
echo "Getting started with cloud agent setup..."
mkdir temp
cd temp
echo "Unzipping cloud agent package to temp folder..."
unzip ../cloudagent_*.zip
cd ../config
##---------------------------------------------------------------
## EXTRACT VALUES FROM SETUP.PROPERTIES FILE 
##---------------------------------------------------------------
echo "Extracting property values from config..."
TENANT_NAME=`grep "^TENANT_NAME" setup.properties | awk -F= '{print $2}'`
if [ -z "$TENANT_NAME" ]; then
   echo "ERROR: Missing value for TENANT_NAME in properties file." 
   MANDATORY_PROPS_SET=NO
fi
REG_KEY=`grep "^REG_KEY" setup.properties | awk -F= '{print $2}'`
if [ -z "$REG_KEY" ]; then
   echo "ERROR: Missing value for REG_KEY in properties file." 
   MANDATORY_PROPS_SET=NO
fi
AGENT_BASE_DIRECTORY="/home/oracle/cloudagent"
OMC_URL=`grep "^OMC_URL" setup.properties | awk -F= '{print $2}'`
if [ -z "$OMC_URL" ]; then
   echo "ERROR: Missing value for OMC_URL in properties file." 
   MANDATORY_PROPS_SET=NO
fi
OMC_URL=`echo "$OMC_URL" | sed -e "s,/*$,,"`
##---------------------------------------------------------------
## WRITE VARIABLES TO AGENT.RSP FILE TO PREPARE FOR INSTALLATION
##---------------------------------------------------------------
cd ../temp
echo "Writing property values to agent.rsp file..."
sed -i '/TENANT_NAME=/c\TENANT_NAME='"$TENANT_NAME" agent.rsp
sed -i '/AGENT_REGISTRATION_KEY=/c\AGENT_REGISTRATION_KEY='"$REG_KEY" agent.rsp
sed -i '/AGENT_BASE_DIRECTORY=/c\AGENT_BASE_DIRECTORY='"$AGENT_BASE_DIRECTORY" agent.rsp
sed -i '/OMC_URL=/c\OMC_URL='"$OMC_URL" agent.rsp
##---------------------------------------------------------------
## EXECUTE AGENTINSTALL.SH TO COMPLETE AGENT INSTALLATION 
##---------------------------------------------------------------
echo "Executing install script..."
./AgentInstall.sh
##---------------------------------------------------------------
## UNLOCK THE DATABASE DBSNMP USER
##---------------------------------------------------------------
echo "Unlocking the DBSNMP user..."
sqlplus / as sysdba << EOF
	ALTER USER DBSNMP ACCOUNT UNLOCK;
	ALTER USER DBSNMP IDENTIFIED BY monitoring;
EOF
##---------------------------------------------------------------
## FIND AND ASSIGN VALUES FOR DATABASE, HOST, AND SERVICE NAME
##---------------------------------------------------------------
cd ../config
echo "Grabbing database, host, and service names..."
INSTANCE_NAME=`grep "^INSTANCE_NAME" setup.properties | awk -F= '{print $2}'` 
HOST_NAME=`lsnrctl status | grep "(PROTOCOL=tcp)" | awk -F "(" '{print $5}' | awk -F ")" '{print $1}' | awk -F "=" '{print $2}'`
SERVICE_NAME=`lsnrctl status | grep -m 2 "Service" | grep -o '".*"'| sed 's/"//g'`
##---------------------------------------------------------------
## ADD ENTITY PROPERTIES TO JSON DEFINITION FILE
##---------------------------------------------------------------
echo "Completing JSON definition file for use..."
sed -i -e 's/>dbHostName>/'"$HOST_NAME"'/' database.json
sed -i -e 's/>dbServiceName>/'"$SERVICE_NAME"'/' database.json
sed -i -e 's/>dbEntityName>/database/' database.json ## NEED TO FIX WITH INSTANCE NAME
sed -i -e 's/>dbEntityDisplayName>/database/' database.json ## NEED TO FIX WITH INSTANCE NAME 
##---------------------------------------------------------------
## ADD THE ENTITY TO OMC AND VIEW ITS STATUS
##---------------------------------------------------------------
cd ../cloudagent/agent_inst/bin
echo "Adding entity to OMC..."
./omcli add_entity agent ../../../config/database.json -credential_file ../../../config/database_creds.json
./omcli status_entity agent
./omcli status_entity agent ../../../config/database.json
##
## END SCRIPT BODY