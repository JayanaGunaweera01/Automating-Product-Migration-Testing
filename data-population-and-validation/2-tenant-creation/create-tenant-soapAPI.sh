#!/bin/bash

# Define color variables
PURPLE='\033[1;35m'
NC='\033[0m' # No Color

# Create a tenant using SOAP API
response=$(curl -k --location --request POST 'https://localhost:9443/services/TenantMgtAdminService?wsdl' \
--header 'Authorization: Basic YWRtaW46YWRtaW4=' \
--header 'Content-Type: text/plain' \
--data-raw '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://services.mgt.tenant.carbon.wso2.org" xmlns:xsd="http://beans.common.stratos.carbon.wso2.org/xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <ser:addTenant>
         <!--Optional:-->
         <ser:tenantInfoBean>
            <!--Optional:-->
            <xsd:active>true</xsd:active>
            <!--Optional:-->
            <xsd:admin>jayanag11</xsd:admin>
            <!--Optional:-->
            <xsd:adminPassword>jayana11gpw</xsd:adminPassword>
            <!--Optional:-->
            <xsd:email>jayanag@examplestest11.com</xsd:email>
            <!--Optional:-->
            <xsd:firstname>First11</xsd:firstname>
            <!--Optional:-->
            <xsd:lastname>Last11</xsd:lastname>
            <!--Optional:-->
            <xsd:tenantDomain>examplestest11.com</xsd:tenantDomain>
         </ser:tenantInfoBean>
      </ser:addTenant>
   </soapenv:Body>
</soapenv:Envelope>')

echo -e "${PURPLE}==> Created a tenant using a SOAP API request${NC}"
echo "$response"
