#!/bin/bash

cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
chmod +x env.sh
. ./env.sh

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Set the userstore name
USERSTORE_NAME="$USERSTORE_NAME"

# Create the user in the userstore
response=$(curl -k --location --request POST "https://localhost:9443/t/carbon.super/api/server/v1/userstores/$USERSTORE_NAME/users" \
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

# Print the response
echo -e "Response:\n$response"

# Check if the response contains any error message
if echo "$response" | grep -q '"schemas":'; then
    # If there is no error, print the success message
    echo -e "${GREEN}${BOLD}A user has been created in the userstore '$USERSTORE_NAME'. User name=${USERSTORE_USER_NAME}, Group name=${USERSTORE_GROUP_NAME}${NC}"
    # Print the additional details
    echo "Additional Details:"
    echo -e "User Name: ${PURPLE}$USERSTORE_USER_NAME${NC}"
    echo -e "Group Name: ${PURPLE}$USERSTORE_GROUP_NAME${NC}"
    echo -e "Employee Number: ${PURPLE}000111${NC}"
    echo -e "Cost Center: ${PURPLE}111111${NC}"
    echo -e "Organization: ${PURPLE}WSO2Org${NC}"
    echo -e "Division: ${PURPLE}$USERSTORE_GROUP_NAME${NC}"
    echo -e "Department: ${PURPLE}Integration${NC}"
    echo -e "Manager ID: ${PURPLE}111000${NC}"
    echo -e "Manager Display Name: ${PURPLE}$USERSTORE_USER_NAME${NC}"
else
    # If there is an error, print the failure message with the error description
    error_description=$(echo "$response" | jq -r '.error[0].description')
    echo -e "${RED}${BOLD}Failure: $error_description${NC}"
fi
echo
