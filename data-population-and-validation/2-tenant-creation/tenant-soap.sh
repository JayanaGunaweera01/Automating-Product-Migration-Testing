#!/bin/bash

os=$1

# Set deployment file and path based on OS
if [ "$os" = "ubuntu-latest" ]; then
  chmod +x env.sh
  . "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh"
  echo "${GREEN}==> Env file for Ubuntu sourced successfully"
fi

if [ "$os" = "macos-latest" ]; then
  chmod +x env.sh
  source "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh"
  echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
fi

# Set variables
url="https://localhost:9443/services/TenantMgtAdminService.TenantMgtAdminServiceHttpsSoap11Endpoint"
username="admin"
password="admin"

# Set the SOAP request body
soap_request=$(cat <<EOF
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://services.mgt.tenant.carbon.wso2.org" xmlns:xsd="http://beans.common.stratos.carbon.wso2.org/xsd">
   <soapenv:Header>
      <ser:AuthHeader>
         <ser:username>$username</ser:username>
         <ser:password>$password</ser:password>
      </ser:AuthHeader>
      <wsa:Action xmlns:wsa="http://www.w3.org/2005/08/addressing">http://services.mgt.tenant.carbon.wso2.org/addTenant</wsa:Action>
   </soapenv:Header>
   <soapenv:Body>
      <ser:addTenant>
         <ser:tenantInfoBean>
            <xsd:active>true</xsd:active>
            <xsd:admin>jayanagd</xsd:admin>
            <xsd:adminPassword>jayanagdpw</xsd:adminPassword>
            <xsd:email>jayanagd@examplestestd.com</xsd:email>
            <xsd:firstname>First</xsd:firstname>
            <xsd:lastname>Last</xsd:lastname>
            <xsd:tenantDomain>examplestestd.com</xsd:tenantDomain>
         </ser:tenantInfoBean>
      </ser:addTenant>
   </soapenv:Body>
</soapenv:Envelope>
EOF
)

# Send the SOAP request using curl
response=$(curl -s -k -X POST -H "Content-Type: text/xml" -H "SOAPAction:" -d "$soap_request" "$url")

# Process the response
echo "$response"
