#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
YELLOW='\033[0;33m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

curl -k --location --request POST "$TENANT_EP" \
    --header 'accept: */*' \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --data-raw '{"domain":"iit.com","owners":[{"username":"iit","password":"iit123","email":"iit@iit.com","firstname":"iit","lastname":"iit","provisioningMethod":"inline-password","additionalClaims":[{"claim":"http://wso2.org/claims/telephone","value":"+94 76 318 6705"}]}]}'

# Check if the response contains any error message
if echo "$response" | grep -q '"Errors":'; then
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq '.Errors[0].description')
  echo "${RED}${BOLD}Failure: $error_description${NC}"
else
    # If there is no error, print the success message with the output
    echo "${GREEN}${BOLD}Success: $response${NC}"
    # Print the additional information with all the details
    echo "${PURPLE}${BOLD}A tenant has been created with a user.${NC}"
    # Print the additional information with all the details
        echo "Tenant name: ${PURPLE}$TENANT_USER_NAME${NC}"
        echo "User name: ${PURPLE}$TENANT_USER_NAME${NC}"
        echo
        echo "Additional Details:"
        echo "Domain: ${PURPLE}iit.com${NC}"
        echo "Owner:"
        echo "  Username: ${PURPLE}iit${NC}"
        echo "  Password: ${PURPLE}iit123${NC}"
        echo "  Email: ${PURPLE}iit@iit.com${NC}"
        echo "  First Name: ${PURPLE}iit${NC}"
        echo "  Last Name: ${PURPLE}iit${NC}"
        echo "  Provisioning Method: ${PURPLE}inline-password${NC}"
        echo "  Additional Claims:"
        echo "    Claim: ${PURPLE}http://wso2.org/claims/telephone${NC}"
        echo "    Value: ${PURPLE}+94 76 318 6705${NC}"

