#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

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

# Create the userstore in Identity Server
userstore_response=$(curl -k --location --request POST "https://localhost:9443/api/server/v1/userstores" \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --data-raw '{
        "typeId": "SkRCQ1VzZXJTdG9yZU1hbmFnZXI",
        "description": "Sample JDBC user store to add.",
        "name": "'"$USERSTORE_NAME"'",
        "properties": [
            {
                "name": "userName",
                "value": "testdb"
            },
            {
                "name": "password",
                "value": "testdb"
            },
            {
                "name": "driverName",
                "value": "com.mysql.jdbc.Driver"
            },
            {
                "name": "url",
                "value": "jdbc:mysql://localhost:3306/testdb?useSSL=false&amp;allowPublicKeyRetrieval=true"
            },
            {
                "name": "disabled",
                "value": "false"
            }
        ]
    }')

# Check if creating the userstore was successful
userstore_error_description=$(echo "$userstore_response" | jq -r '.description')
if [ "$userstore_error_description" != "null" ]; then
    echo -e "${RED}${BOLD}Failure: $userstore_error_description${NC}"
    exit 1
else
    echo -e "${GREEN}${BOLD}Userstore '$USERSTORE_NAME' created successfully.${NC}"
fi

# Add a user to the userstore
response=$(curl -k --location --request POST "https://localhost:9443/api/server/v1/userstores/$USERSTORE_NAME/users" \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic dGVzdGQ6dGVzdGQ=' \
    --data-raw '{
        "schemas": [],
        "userName": "admin",
        "password": "admin",
        "wso2Extension": {
            "employeeNumber": "000111",
            "costCenter": "111111",
            "organization": "WSO2Org",
            "division": "Engineering",
            "department": "Integration",
            "manager": {
                "managerId": "111000",
                "displayName": "admin"
            }
        }
    }')

# Print the response
echo -e "Response:\n$response"

# Check if adding the user was successful
error_description=$(echo "$response" | jq -r '.description')
if [ "$error_description" != "null" ]; then
    echo -e "${RED}${BOLD}Failure: $error_description${NC}"
else
    echo -e "${GREEN}${BOLD}A user has been created in the userstore '$USERSTORE_NAME'. User name=Jayana, Group name=${USERSTORE_GROUP_NAME}${NC}"
    echo -e "${PURPLE}Additional Details:${NC}"
    echo -e "User Name: ${PURPLE}Jayana${NC}"
    echo -e "Group Name: ${PURPLE}$USERSTORE_GROUP_NAME${NC}"
    echo -e "Employee Number: ${PURPLE}000111${NC}"
    echo -e "Cost Center: ${PURPLE}111111${NC}"
    echo -e "Organization: ${PURPLE}WSO2Org${NC}"
    echo -e "Division: ${PURPLE}$USERSTORE_GROUP_NAME${NC}"
    echo -e "Department: ${PURPLE}Integration${NC}"
    echo -e "Manager ID: ${PURPLE}111000${NC}"
    echo -e "Manager Display Name: ${PURPLE}Jayana${NC}"
fi
