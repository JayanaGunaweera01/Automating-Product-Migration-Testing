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
url="https://localhost:9443/services/TenantMgtAdminService.TenantMgtAdminServiceHttpsSoap11Endpoint/"
username="admin"
password="admin"

# Set the SOAP request body
soap_request=$(
   cat <<EOF
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://services.mgt.tenant.carbon.wso2.org" xmlns:xsd="http://beans.common.stratos.carbon.wso2.org/xsd">
    <soapenv:Header/>
    <soapenv:Body>
        <ser:addSkeletonTenant>
            <!­­Optional:­­>
            <ser:tenantInfoBean>
                <!­­Optional:­­>
                <xsd:active>true</xsd:active>
                <!­­Optional:­­>
                <xsd:admin>testuser</xsd:admin>
                <!­­Optional:­­>
                <xsd:adminPassword>testpw</xsd:adminPassword>
                <!­­Optional:­­>
                <xsd:createdDate></xsd:createdDate>
                <!­­Optional:­­>
                <xsd:email>testuser@example.com</xsd:email>
                <!­­Optional:­­>
                <xsd:firstname>First</xsd:firstname>
                <!­­Optional:­­>
                <xsd:lastname>Last</xsd:lastname>
                <!­­Optional:­­>
                <xsd:originatedService></xsd:originatedService>
                <!­­Optional:­­>
                <xsd:successKey></xsd:successKey>
                <!­­Optional:­­>
                <xsd:tenantDomain>example.com</xsd:tenantDomain>
                <!­­Optional:­­>
                <xsd:tenantId></xsd:tenantId>
                <!­­Optional:­­>
                <xsd:usagePlan></xsd:usagePlan>
            </ser:tenantInfoBean>
        </ser:addSkeletonTenant>
    </soapenv:Body>
</soapenv:Envelope>
EOF
)

# Send the SOAP request using curl
response=$(curl -s -k -X POST -H "Content-Type: text/xml" -H "SOAPAction:" -d "$soap_request" "$url")

# Process the response
echo "$response"
