#!/bin/bash

curl -k --location --request POST "$TENANT_EP" \
--header 'accept: */*' \
--header 'Content-Type: application/json' \
--header 'Authorization: Basic YWRtaW46YWRtaW4=' \
--data-raw '{"domain":"iit.com","owners":[{"username":"iit","password":"iit123","email":"iit@iit.com","firstname":"iit","lastname":"iit","provisioningMethod":"inline-password","additionalClaims":[{"claim":"http://wso2.org/claims/telephone","value":"+94 76 318 6705"}]}]}'
