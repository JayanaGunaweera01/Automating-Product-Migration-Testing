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

# Create the user in the userstore
response=$(curl -k --location --request POST "https://localhost:9443/api/server/v1/userstores/$USERSTORE_NAME/users" \
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
# Get the HTTP status code
http_status=$(curl -s -o /dev/null -w "%{http_code}" "https://localhost:9443/api/server/v1/userstores/$USERSTORE_NAME/users")

if [ $http_status -eq 201 ]; then
    echo -e "${GREEN}${BOLD}A user has been created in the userstore '$USERSTORE_NAME'. User name=${USERSTORE_USER_NAME}, Group name=${USERSTORE_GROUP_NAME}${NC}"
    echo "{PURPLE}Additional Details:${NC}"
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
    echo -e "${RED}${BOLD}Failure: User creation request returned HTTP status code $http_status${NC}"
fi