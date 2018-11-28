#!/bin/bash
echo "Connected to database host..."
echo "Starting at $(pwd)..."
echo "Getting started with cloud agent setup..."
#
BASE_DIR="C:\Users\zdhamilt\GUIDED_JOURNEYS\omc_journey"
PROP_FILE=${BASE_DIR}"\config\setup.properties"
#
TENANT_NAME=`grep "^TENANT_NAME" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$TENANT_NAME" ]; then
   echo "ERROR: Missing value for TENANT_NAME in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
#
OMC_URL=`grep "^OMC_URL" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$OMC_URL" ]; then
   echo "ERROR: Missing value for OMC_URL in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
OMC_URL=`echo "$OMC_URL" | sed -e "s,/*$,,"`
#
REG_KEY=`grep "^REG_KEY" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$REG_KEY" ]; then
   echo "ERROR: Missing value for REG_KEY in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
#sed -i '/TENANT_NAME=/c\TENANT_NAME='"$TENANT_NAME" agent.rsp
#sed -i '/AGENT_REGISTRATION_KEY=/c\AGENT_REGISTRATION_KEY='"$AGENT_REGISTRATION_KEY" agent.rsp
#sed -i '/AGENT_BASE_DIRECTORY=/c\AGENT_BASE_DIRECTORY='"$AGENT_BASE_DIRECTORY" agent.rsp
#sed -i '/OMC_URL=/c\OMC_URL='"$OMC_URL" agent.rsp