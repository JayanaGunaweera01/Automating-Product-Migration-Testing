#!/bin/bash

cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
chmod +x env.sh
source ./env.sh

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
YELLOW='\033[0;33m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Create the group
group_response=$(curl -k --location --request POST "$SCIM2_GROUP_EP" \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "displayName": "'"$GROUP_NAME"'",
    "schemas": [
      "urn:ietf:params:scim:schemas:core:2.0:Group"
    ]
  }')

# Check if the group creation was successful
if echo "$group_response" | grep -q '"displayName":'; then
  # Print success message
  echo -e "${GREEN}${BOLD}A group has been created successfully.${NC}"
  # Print group name
  echo -e "Group Name: ${PURPLE}$GROUP_NAME${NC}"
else
  # Print failure message
  echo -e "${RED}${BOLD}Failed to create the group.${NC}"
  # Print error details
  echo -e "${RED}${BOLD}Error Response:${NC}"
  echo "$group_response"
fi
echo





