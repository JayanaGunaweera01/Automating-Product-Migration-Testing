#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Define variables
TENANT_EP="https://localhost:9443/t/carbon.super/api/server/v1/tenants"
USERNAME="dummyuser"
PASSWORD="dummypassword"
EMAIL="dummyuser@wso2.com"
FIRSTNAME="Dummy"
LASTNAME="User"
TELEPHONE="+94 123 4567"

# Create tenant
response=$(curl -k --location --request POST "$TENANT_EP" \
  --header 'accept: */*' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --data-raw "{\"domain\":\"wso2.com\",\"owners\":[{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\",\"email\":\"$EMAIL\",\"firstname\":\"$FIRSTNAME\",\"lastname\":\"$LASTNAME\",\"provisioningMethod\":\"inline-password\",\"additionalClaims\":[{\"claim\":\"http://wso2.org/claims/telephone\",\"value\":\"$TELEPHONE\"}]}]}")

# Check if the response contains any error message
if echo "$response" | grep -q '"error":'; then
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq -r '.error[0].description')
  echo "${RED}${BOLD}Failure: $error_description${NC}"
else
  # If there is no error, print the success message
  echo "${GREEN}${BOLD}Success: Tenant has been created successfully.${NC}"

  # Print the details of the successful response
  echo "${PURPLE}Response Details:${NC}"
  echo "$response" | jq '.'

  # Print the additional information with all the details
  echo "${PURPLE}${BOLD}A tenant has been created with a user.${NC}"
  echo "Tenant name: ${PURPLE}wso2.com${NC}"
  echo "User name: ${PURPLE}$USERNAME${NC}"
  echo
  echo "Additional Details:"
  echo "Domain: ${PURPLE}wso2.com${NC}"
  echo "Owner:"
  echo "  Username: ${PURPLE}$USERNAME${NC}"
  echo "  Password: ${PURPLE}$PASSWORD${NC}"
  echo "  Email: ${PURPLE}$EMAIL${NC}"
  echo "  First Name: ${PURPLE}$FIRSTNAME${NC}"
  echo "  Last Name: ${PURPLE}$LASTNAME${NC}"
  echo "  Provisioning Method: ${PURPLE}inline-password${NC}"
  echo "  Additional Claims:"
  echo "    Claim: ${PURPLE}http://wso2.org/claims/telephone${NC}"
  echo "    Value: ${PURPLE}$TELEPHONE${NC}"
fi
