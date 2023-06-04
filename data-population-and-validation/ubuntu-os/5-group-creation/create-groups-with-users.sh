#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Create interns group
interns_response=$(curl -s -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{"displayName":"interns","members":[{"display":"Jayana","value":"Jayana","ref":"User","operation":"add"},{"display":"Randul","value":"Randul","ref":"User","operation":"add"},{"display":"Chithara","value":"Chithara","ref":"User","operation":"add"},{"display":"Rukshan","value":"Rukshan","ref":"User","operation":"add"}]}' https://localhost:9443/api/identity/group/v1.0/groups)

# Check if the interns group creation was successful
if echo "$interns_response" | grep -q '"displayName":"interns"'; then
  # Print success message
  echo "${GREEN}${BOLD}The interns group has been created successfully.${NC}"
else
  # Print failure message
  echo "${RED}${BOLD}Failed to create the interns group.${NC}"
  echo "${RED}${BOLD}Error Response: ${interns_response}${NC}"
fi

# Create mentors group
mentors_response=$(curl -s -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{"displayName":"mentors","members":[{"display":"Ashen","value":"Ashen","ref":"User","operation":"add"},{"display":"Chamath","value":"Chamath","ref":"User","operation":"add"}]}' https://localhost:9443/api/identity/group/v1.0/groups)

# Check if the mentors group creation was successful
if echo "$mentors_response" | grep -q '"displayName":"mentors"'; then
  # Print success message
  echo "${GREEN}${BOLD}The mentors group has been created successfully.${NC}"
else
  # Print failure message
  echo "${RED}${BOLD}Failed to create the mentors group.${NC}"
  echo "${RED}${BOLD}Error Response: ${mentors_response}${NC}"
fi
echo



