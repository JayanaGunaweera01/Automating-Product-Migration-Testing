#!/bin/bash

# Define color variables
PURPLE='\033[1;35m'
NC='\033[0m' # No Color

# Create a tenant using SOAP API
response=$(curl -k --location --request POST 'https://localhost:9443/services/TenantMgtAdminService.TenantMgtAdminServiceHttpsSoap11Endpoint/' \
--header 'Content-Type: text/xml' \
--header 'SOAPAction: urn:addTenant' \
--data-raw '
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://services.mgt.tenant.carbon.wso2.org" xmlns:xsd="http://beans.common.stratos.carbon.wso2.org/xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <ser:addTenant>
         <ser:tenantInfoBean>
            <xsd:active>true</xsd:active>
            <xsd:admin>jayanag11</xsd:admin>
            <xsd:adminPassword>jayana11gpw</xsd:adminPassword>
            <xsd:email>jayanag@examplestest11.com</xsd:email>
            <xsd:firstname>First11</xsd:firstname>
            <xsd:lastname>Last11</xsd:lastname>
            <xsd:tenantDomain>examplestest11.com</xsd:tenantDomain>
         </ser:tenantInfoBean>
      </ser:addTenant>
   </soapenv:Body>
</soapenv:Envelope>
')

echo -e "${PURPLE}==> Created a tenant using a SOAP API request${NC}"
echo "$response"

# Extract the tenant ID from the response
tenant_id=$(echo "$response" | grep -oP '(?<=<return>).*(?=</return>)')

# Register a service provider inside the tenant
service_provider_response=$(curl -k --location --request POST "https://localhost:9443/t/${tenant_id}/api/server/v1/service-providers" \
--header 'Authorization: Basic YWRtaW46YWRtaW4=' \
--header 'Content-Type: application/json' \
--data-raw '{
   "name": "SampleServiceProvider",
   "description": "This is a sample service provider"
}')

echo -e "${PURPLE}==> Registered a service provider inside the tenant${NC}"
echo "$service_provider_response"

# Extract the client ID and client secret from the service provider response
client_id=$(echo "$service_provider_response" | grep -oP '(?<=client_id": ")[^"]+')
client_secret=$(echo "$service_provider_response" | grep -oP '(?<=client_secret": ")[^"]+')

# Obtain an access token for the registered service provider
access_token_response=$(curl -k --location --request POST 'https://localhost:9443/oauth2/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=client_credentials' \
--data-urlencode "client_id=${client_id}" \
--data-urlencode "client_secret=${client_secret}" \
--data-urlencode 'scope=openid')

echo -e "${PURPLE}==> Obtained an access token for the registered service provider${NC}"
echo "$access_token_response"
