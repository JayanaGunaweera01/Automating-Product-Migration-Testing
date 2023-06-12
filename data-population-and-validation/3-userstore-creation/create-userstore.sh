#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
YELLOW='\033[0;33m'
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
response=$(curl -k --location --request POST "https://localhost:9443/api/server/v1/userstores" \
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
        "value": "jdbc:mysql://localhost:3306/testdb?useSSL=false"
      },
      {
        "name": "disabled",
        "value": "false"
      }
    ]
  }')

# Print the response
echo -e "Response:\n$response"

# Check if the response contains any error message
if echo "$response" | grep -q '"typeId":'; then
  # If there is no error, print the success message
  echo -e "${PURPLE}${BOLD}A userstore has been created.Userstore name is ${USERSTORE_NAME}${NC}"
  # Print the additional details
  echo -e "Userstore Name: ${PURPLE}$USERSTORE_NAME${NC}"
  echo -e "Userstore Description: ${PURPLE}Sample JDBC user store to add.${NC}"
  echo -e "Userstore Properties:"
  echo -e "  - Property: userName, Value: ${PURPLE}testdb${NC}"
  echo -e "  - Property: password, Value: ${PURPLE}testdb${NC}"
  echo -e "  - Property: driverName, Value: ${PURPLE}com.mysql.jdbc.Driver${NC}"
  echo -e "  - Property: url, Value: ${PURPLE}jdbc:mysql://localhost:3306/testdb?useSSL=false${NC}"
  echo -e "  - Property: disabled, Value: ${PURPLE}false${NC}"
else
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq -r '.error[0].description')
  echo -e "${RED}${BOLD}Failure: $error_description${NC}"
fi

# Enable SCIM for the user store
#scim_enable_response=$(curl -k --user admin:admin --header "Content-Type: application/json" --request PUT \
#--data '{
#  "Properties": {
#    "ReadOnly": "false",
 #   "SCIMEnabled": "true"
 # }
#}' \
#https://localhost:9443/wso2/carbon/userstore/v1.0.0/user-stores/AMRSNGHE)

#if [[ "$scim_enable_response" == *"true"* ]]; then
 # echo -e "${PURPLE}${BOLD}SCIM has been enabled for the user store 'AMRSNGHE'${NC}"
#else
 # echo -e "${RED}${BOLD}Failed to enable SCIM for the user store 'AMRSNGHE'${NC}"
 # echo -e "${RED}${BOLD}Error Message:${NC} $scim_enable_response"
#fi

# Create a group in the user store domain
#group_response=$(curl -k --user admin:admin --data '{"displayName": "AMRSNGHE/'$USERSTORE_NAME'"}' --header "Content-Type: application/json" https://localhost:9443/wso2/scim/Groups)

#group_id=$(echo "$group_response" | jq -r '.id')

#if [ -n "$group_id" ]; then
#  echo -e "${PURPLE}${BOLD}Group has been created successfully in the user store domain.${NC}"
 # echo "${PURPLE}${BOLD}Group Response:${NC}"
 # echo "$group_response"
#else
 # echo -e "${RED}${BOLD}Failed to create the group in the user store domain.${NC}"
 # echo -e "${RED}${BOLD}Error Message:${NC} $group_response"
#fi

# Create a user in the given user store domain
#user_response=$(curl -k --user admin:admin --data '{"schemas":[],"name":{"familyName":"John","givenName":"Doe"},"userName":"AMRSNGHE/groupUSR001","password":"testPwd123"}' --header "Content-Type: application/json" https://localhost:9443/wso2/scim/Users)

#user_id=$(echo "$user_response" | jq -r '.id')

#if [ -n "$user_id" ]; then
#  echo -e "${PURPLE}${BOLD}User has been created successfully in the given user store domain.${NC}"
#  echo "${PURPLE}${BOLD}User Response:${NC}"
#  echo "$user_response"
#else
 # echo -e "${RED}${BOLD}Failed to create the user in the given user store domain.${NC}"
 # echo -e "${RED}${BOLD}Error Message:${NC} $user_response"
#fi

