#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
BOLD='\033[1m'
NC='\033[0m' # No Color


# Function to add a user to the PRIMARY user store
#add_user() {
#  local username=$1
#  local password=$2

#  response=$(curl -k -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{
#    "schemas": [],
#    "userName": "'"${username}"'",
#    "password": "'"${password}"'",
#    "name": {
#      "familyName": "",
#      "givenName": "'"${username}"'"
#    }
#  }' https://localhost:9443/api/server/v1/userstores/PRIMARY/users)

#  if [ "$response" -eq 201 ]; then
 #   echo -e "${GREEN}${BOLD}User '${username}' has been added to the 'PRIMARY' user store successfully.${NC}"
 # else
 #   echo -e "${RED}${BOLD}Failed to add user '${username}' to the 'PRIMARY' user store.${NC}"
  #  echo "Response Code: $response"
 # fi
#}

# Create PRIMARY user store
#response=$(curl -k -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{
 # "typeId": "SkRCQ1VzZXJTdG9yZQ==",
  #"description": "Primary user store",
  #"name": "PRIMARY"
#}' https://localhost:9443/api/server/v1/userstores)

#if [ "$response" -eq 201 ]; then
#  echo -e "${GREEN}${BOLD}PRIMARY user store has been created successfully.${NC}"
#else
#  echo -e "${RED}${BOLD}Failed to create PRIMARY user store.${NC}"
#  echo "Response Code: $response"
#fi

# Add users to the PRIMARY user store
#add_user "Jayana" "jayanapass"
#add_user "Randul" "randulpass"
#add_user "Chithara" "chitharapass"
#add_user "Rukshan" "rukshanpass"

# Create the interns group
#response=$(curl -k -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{
#  "displayName": "interns",
#  "members": [
#    {"display": "Jayana", "value": "Jayana", "ref": "User", "operation": "add"},
#    {"display": "Randul", "value": "Randul", "ref": "User", "operation": "add"},
#    {"display": "Chithara", "value": "Chithara", "ref": "User", "operation": "add"},
#    {"display": "Rukshan", "value": "Rukshan", "ref": "User", "operation": "add"}
#  ]
#}' https://localhost:9443/api/identity/group/v1.0/groups)

#if [ "$response" -eq 201 ]; then
#  echo -e "${GREEN}${BOLD}Group 'interns' has been created successfully.${NC}"
#else
#  echo -e "${RED}${BOLD}Failed to create the 'interns' group.${NC}"
#  echo "Response Code: $response"
#fi
 
response=$(curl -k --location --request POST "$SCIM2_GROUP_EP" \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "displayName": "'$GROUP_DISPLAY_NAME'",
    "members": [
        {
            "value": "'$GROUP_USER_ID'"
        }
    ],
    "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:Group"
    ]
}')

if [ "$response" -eq 201 ]; then
  echo -e "${GREEN}${BOLD}Group 'salesgroup' has been created and added a user to it successfully.${NC}"
else
  echo -e "${RED}${BOLD}Failed to create the 'sales' group.${NC}"
  echo "Response Code: $response"
fi