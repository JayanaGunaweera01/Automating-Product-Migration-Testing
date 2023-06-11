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

# Create the user and retrieve the user ID
user_response=$(curl -v -k --user admin:admin --data '{"schemas":[],"name":{"familyName":"gunasinghe","givenName":"hasinitg"},"userName":"hasinitg","password":"hasinitg","emails":[{"primary":true,"value":"hasini_home.com","type":"home"},{"value":"hasini_work.com","type":"work"}]}' --header "Content-Type:application/json" https://localhost:9443/wso2/scim/Users)
user_id=$(echo "$user_response" | jq -r '.id')

if [ -n "$user_id" ]; then
  echo "User has been created successfully."
  echo "User ID: $user_id"

  # Create the 'Interns' group and add the user to it
  response=$(curl -k --location --request POST "$SCIM2_GROUP_EP" \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --header 'Content-Type: application/json' \
    --data-raw '{
      "displayName": "Interns",
      "members": [
        {
          "value": "'"$user_id"'"
        }
      ],
      "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:Group"
      ]
    }')

  group_id=$(echo "$response" | jq -r '.id')

  if [ -n "$group_id" ]; then
    echo "Success Message: $response"
    echo -e "${PURPLE}${BOLD}Group 'Interns' has been created and the user has been added successfully.${NC}"
  else
    echo -e "${RED}${BOLD}Failed to create the 'Interns' group.${NC}"
    echo "Error Message: $response"
  fi
else
  echo -e "${RED}${BOLD}Failed to create the user.${NC}"
  echo "Error Message: $user_response"
fi

# Create bulk users
bulk_response=$(curl -k --location --request POST "$SCIM_BULK_EP" \
    --header 'Content-Type: application/scim+json' \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --data-raw '{
  "failOnErrors": 1,
  "schemas": ["urn:ietf:params:scim:api:messages:2.0:BulkRequest"],
  "Operations": [
    {
      "method": "POST",
      "path": "/Users",
      "bulkId": "ytrewq",
      "data": {
        "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User", "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"],
        "userName": "Chamath",
        "password": "chamathpass",
        "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
          "employeeNumber": "11250",
          "mentor": {
            "value": "bulkId:qwerty"
          }
        }
      }
    },
    {
      "method": "POST",
      "path": "/Users",
      "bulkId": "ytrewq",
      "data": {
        "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User", "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"],
        "userName": "Ashen",
        "password": "ashenpass",
        "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
          "employeeNumber": "11251",
          "mentor": {
            "value": "bulkId:qwerty"
          }
        }
      }
    }
  ]
}')

# Check if bulk users were created successfully
bulk_user_ids=$(echo "$bulk_response" | jq -r '.Resources[].id')

if [ -n "$bulk_user_ids" ]; then
  echo "Bulk users have been created successfully."
  echo "User IDs: $bulk_user_ids"

  # Add bulk users to the 'Mentors' group
  group_response=$(curl -k --location --request POST "$SCIM2_GROUP_EP" \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --header 'Content-Type: application/json' \
    --data-raw '{
      "displayName": "Mentors",
      "members": [
        '"$(echo "$bulk_user_ids" | jq -cR 'split("\n")[:-1] | map({"value": .})')"'
      ],
      "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:Group"
      ]
    }')

  group_id=$(echo "$group_response" | jq -r '.id')

  if [ -n "$group_id" ]; then
    echo -e "${PURPLE}${BOLD}Group 'Mentors' has been created and bulk users have been added successfully.${NC}"
  else
    echo -e "${RED}${BOLD}Failed to create the 'Mentors' group.${NC}"
    echo "Error Message: $group_response"
  fi
else
  echo -e "${RED}${BOLD}Failed to create bulk users.${NC}"
  echo "Error Message: $bulk_response"
fi