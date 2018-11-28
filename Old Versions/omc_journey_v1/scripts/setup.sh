######################################################################################
## SCRIPT TO MOVE CLOUD AGENT TO DATABASE HOST, CONDUCT AGENT SETUP AND INSTALLATION, 
## CONFIGURE ENTITIES, AND MAKE OMC READY TO PULL INFORMATION.
######################################################################################
# PATH_TO_BASE="C:\Users\zdhamilt\GUIDED_JOURNEY"
# BASE_DIR=${PATH_TO_BASE}"/omc_journey"
# PROP_FILE=${BASE_DIR}"/config/setup.properties"
# KEY_PATH=${BASE_DIR}"/.ssh"
#
## DATABASE PROPERTIES
#
PUBLIC_IP=`grep "^PUBLIC_IP" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$PUBLIC_IP" ]; then
   echo "ERROR: Missing value for PUBLIC_IP in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
#
PDB_NAME=`grep "^PDB_NAME" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$PDB_NAME" ]; then
   echo "ERROR: Missing value for PDB_NAME in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
#
SID=`grep "^SID" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$SID" ]; then
   echo "ERROR: Missing value for SID in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
#
## CLOUD ACCOUNT PROPERTIES
#
IDENTITY_DOMAIN=`grep "^IDENTITY_DOMAIN" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$IDENTITY_DOMAIN" ]; then
   echo "ERROR: Missing value for IDENTITY_DOMAIN in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
#
USERNAME=`grep "^USERNAME" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$USERNAME" ]; then
   echo "ERROR: Missing value for USERNAME in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
#
PASSWORD=`grep "^PASSWORD" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$PASSWORD" ]; then
   echo "ERROR: Missing value for PASSWORD in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
#
## OMC SETUP PROPERTIES
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
# if [[ "$OMC_URL" == https://* ]]; then
   # EDGE_END_POINT=${OMC_URL}
# else
   # # Prefix URL with "https://" as it is not included in the value of OMC_URL
   # EDGE_END_POINT=https://${OMC_URL}
# fi
#
REG_KEY=`grep "^REG_KEY" ${PROP_FILE}| awk -F= '{print $2}'`
if [ -z "$REG_KEY" ]; then
   echo "ERROR: Missing value for REG_KEY in file $PROP_FILE" 
   MANDATORY_PROPS_SET=NO
fi
#
if [ "$MANDATORY_PROPS_SET" = "NO" ]; then
   echo "ERROR: Mandatory Properties not set, exiting..."
   exit
fi
## ------------------------------------------------------------
## ------------------------------------------------------------
cd ${BASE_DIR}"\config"
echo "Sending setup properties file..."
scp -i ${KEY_PATH}"\cloudkey" setup.properties oracle@${PUBLIC_IP}:/home/oracle

echo "Sending cloud agent software to database host..."
#scp -i ${KEY_PATH}"\cloudkey" secret_message.txt oracle@${PUBLIC_IP}:/home/oracle

cd ${BASE_DIR}"\scripts"
echo "Attempting to connect to database host..."
ssh -i ${KEY_PATH}"\cloudkey" oracle@${PUBLIC_IP} 'bash -s' < db_setup.sh

## ssh-keygen -f /c/Users/zdhamilt/GUIDED_JOURNEYS/omc_journey/.ssh/cloudkey
## clip < cloudkey.pub

# ssh -i ${KEY_PATH}"\cloudkey" oracle@${PUBLIC_IP} << EOF
	# echo "Connected to the database host...";
	# echo "Getting started at $(pwd)...";

# EOF

## END