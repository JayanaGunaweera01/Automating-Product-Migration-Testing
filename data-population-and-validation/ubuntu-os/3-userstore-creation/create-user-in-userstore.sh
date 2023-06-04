#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
YELLOW='\033[0;33m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Create the user in the userstore
response=$(curl -k --location --request POST "$SCIM_USER_EP_USERSTORE" \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --data-raw '{
        "schemas": [],
        "userName": "'"$USERSTORE_USER_NAME"'",
        "password": "'"$USERSTORE_USER_PASSWORD"'",
        "wso2Extension": {
            "employeeNumber": "000111",
            "costCenter": "111111",
            "organization": "WSO2Org",
            "division": "'"$USERSTORE_GROUP_NAME"'",
            "department": "Integration",
            "manager": {
                "managerId": "111000",
                "displayName": "'"$USERSTORE_USER_NAME"'"
            }
        }
    }')

# Check if the response contains any error message
if echo "$response" | grep -q '"schemas":'; then
    # If there is no error, print the success message
    echo "${GREEN}A user has been created in the userstore. User name=${USERSTORE_USER_NAME}, Group name=${USERSTORE_GROUP_NAME}${NC}"
    # Print the additional details
    echo "Additional Details:"
    echo "User Name: ${PURPLE}$USERSTORE_USER_NAME${NC}"
    echo "Group Name: ${PURPLE}$USERSTORE_GROUP_NAME${NC}"
    echo "Employee Number: ${PURPLE}000111${NC}"
    echo "Cost Center: ${PURPLE}111111${NC}"
    echo "Organization: ${PURPLE}WSO2Org${NC}"
    echo "Division: ${PURPLE}$USERSTORE_GROUP_NAME${NC}"
    echo "Department: ${PURPLE}Integration${NC}"
    echo "Manager ID: ${PURPLE}111000${NC}"
    echo "Manager Display Name: ${PURPLE}$USERSTORE_USER_NAME${NC}"

else
    # If there is an error, print the failure message with the error description
    error_description=$(echo "$response" | jq -r '.error[0].description')
    echo "${RED}${BOLD}Failure: $error_description${NC}"
fi
echo
