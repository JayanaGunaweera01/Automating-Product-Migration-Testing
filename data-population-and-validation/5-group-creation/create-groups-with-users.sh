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

# Function to create multiple users and retrieve their user IDs
create_users() {
  local users='[
    {
      "schemas": [],
      "name": {
        "familyName": "Doe1",
        "givenName": "John1"
      },
      "userName": "johnd1",
      "password": "password123",
      "emails": [
        {
          "primary": true,
          "value": "john.doe1@example.com",
          "type": "home"
        },
        {
          "value": "john.doe1@example.com",
          "type": "work"
        }
      ]
    },
    {
      "schemas": [],
      "name": {
        "familyName": "Doe2",
        "givenName": "John2"
      },
      "userName": "johnd2",
      "password": "password123",
      "emails": [
        {
          "primary": true,
          "value": "john.doe2@example.com",
          "type": "home"
        },
        {
          "value": "john.doe2@example.com",
          "type": "work"
        }
      ]
    },
    {
      "schemas": [],
      "name": {
        "familyName": "Doe3",
        "givenName": "John3"
      },
      "userName": "johnd3",
      "password": "password123",
      "emails": [
        {
          "primary": true,
          "value": "john.doe3@example.com",
          "type": "home"
        },
        {
          "value": "john.doe3@example.com",
          "type": "work"
        }
      ]
    },
    {
      "schemas": [],
      "name": {
        "familyName": "Doe4",
        "givenName": "John4"
      },
      "userName": "johnd4",
      "password": "password123",
      "emails": [
        {
          "primary": true,
          "value": "john.doe4@example.com",
          "type": "home"
        },
        {
          "value": "john.doe4@example.com",
          "type": "work"
        }
      ]
    },
    {
      "schemas": [],
      "name": {
        "familyName": "Doe5",
        "givenName": "John5"
      },
      "userName": "johnd5",
      "password": "password123",
      "emails": [
        {
          "primary": true,
          "value": "john.doe5@example.com",
          "type": "home"
        },
        {
          "value": "john.doe5@example.com",
          "type": "work"
        }
      ]
    }
  ]'

  local user_response=$(curl -v -k --user admin:admin --data "$users" --header "Content-Type:application/json" https://localhost:9443/wso2/scim/Users)

  local user_ids=$(echo "$user_response" | jq -r '.Resources[].id')
  echo "$user_ids"
}

# Create an array to store the user IDs
user_ids=()

# Create multiple users and retrieve their user IDs
user_ids=$(create_users)

# Join user IDs into a comma-separated string
members=$(IFS=,; echo "${user_ids[*]}")

# Create the 'Interns' group and add the users to it
response=$(curl -k --location --request POST "$SCIM2_GROUP_EP" \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "displayName": "Interns",
    "members": [
      {
        "value": "'"$members"'"
      }
    ],
    "schemas": [
      "urn:ietf:params:scim:schemas:core:2.0:Group"
    ]
  }')

# Check the response code
if [ "$response" -eq 201 ]; then
  echo -e "${GREEN}${BOLD}Group 'Interns' has been created and users have been added successfully.${NC}"
else
  echo -e "${RED}${BOLD}Failed to create the 'Interns' group.${NC}"
  echo "Response Code: $response"
fi
