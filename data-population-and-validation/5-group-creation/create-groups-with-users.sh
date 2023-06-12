#!/bin/bash

CYAN='\033[0;36m\033[1m'   # cyan color
GREEN='\033[0;32m\033[1m'  # green color
BLUE='\033[0;34m\033[1m'   # blue color
YELLOW='\033[0;33m\033[1m' # yellow color
ORANGE='\033[0;91m\033[1m' # orange color
RED='\033[0;31m\033[1m'    # red color
PURPLE='\033[1;35m'        # purple color
RESET='\033[0m'   

# Create the user and retrieve the user ID
user_response=$(curl -v -k --user admin:admin --data '{"schemas":[],"name":{"familyName":"gunasinghe","givenName":"hasinitg"},"userName":"hasinitg","password":"hasinitg","emails":[{"primary":true,"value":"hasini_home.com","type":"home"},{"value":"hasini_work.com","type":"work"}]}' --header "Content-Type:application/json" https://localhost:9443/wso2/scim/Users)
user_id=$(echo "$user_response" | jq -r '.id')

if [ -n "$user_id" ]; then
  echo -e "${PURPLE}${BOLD}User has been created successfully.${NC}"
  echo -e "${PURPLE}${BOLD}User ID:${NC} $user_id"

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
    echo -e "${PURPLE}${BOLD}Success Message${NC}: $response"
    echo -e "${PURPLE}${BOLD}Group 'Interns' has been created and the user has been added successfully.${NC}"
  else
    echo -e "${RED}${BOLD}Failed to create the 'Interns' group.${NC}"
    echo -e "${RED}${BOLD}Error Message:${NC} $response"
  fi
else
  echo -e "${RED}${BOLD}Failed to create the user.${NC}"
  echo -e "Error Message: $user_response"
  exit 1  # Exit with an error code to indicate failure
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
          "manager": {
            "value": "Taylor"
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
          "manager": {
            "value": "Taylor"
          }
        }
      }
    }
  ]
}')

echo "$bulk_response"

# Check if bulk users were created successfully
bulk_user_ids=$(echo "$bulk_response" | jq -r '.Operations[].response.data.id')

if [ -n "$bulk_user_ids" ]; then
  echo -e "${PURPLE}${BOLD}Bulk users have been created successfully.${NC}"
  echo -e "${PURPLE}${BOLD}User IDs:${NC} $bulk_user_ids"

  # Add only one user to the 'Mentors' group
  group_members=$(echo "$bulk_user_ids" | jq -r '.[0]')
  group_response=$(curl -k --location --request POST "$SCIM2_GROUP_EP" \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --header 'Content-Type: application/json' \
    --data-raw '{
      "displayName": "Mentors",
      "members": [{"value": "'"$group_members"'"}],
      "schemas": [
        "urn:ietf:params:scim:schemas:core:2.0:Group"
      ]
    }')

  group_id=$(echo "$group_response" | jq -r '.id')

  if [ -n "$group_id" ]; then
    echo -e "${PURPLE}${BOLD}Success Message${NC}: $group_response"
    echo -e "${PURPLE}${BOLD}Group 'Mentors' has been created and the user has been added successfully.${NC}"
  else
    echo -e "${RED}${BOLD}Failed to create the 'Mentors' group.${NC}"
    echo -e "${RED}${BOLD}Error Message:${NC} $group_response"
  fi
else
  echo -e "${RED}${BOLD}Failed to create bulk users.${NC}"
  echo -e "${RED}${BOLD}Error Message:${NC} $bulk_response"
  exit 1  # Exit with an error code to indicate failure
fi
