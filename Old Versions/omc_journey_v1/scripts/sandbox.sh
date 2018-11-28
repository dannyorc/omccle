echo "Getting started..."

#
#grep "^TENANT_NAME" agent.rsp| awk -F= '{ $3 }1'
#sed -i 's/^.*TENANT_NAME.*$/TENANT_NAME=/' agent.rsp
sed -i '/TENANT_NAME=/c\TENANT_NAME='"$TENANT_NAME" agent.rsp