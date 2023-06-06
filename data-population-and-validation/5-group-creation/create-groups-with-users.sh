#!/bin/bash

cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
chmod +x env.sh
. ./env.sh

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Create interns group
interns_response=$(curl -s -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{"displayName":"interns","members":[{"display":"Randul","value":"Randul","ref":"User","operation":"add"},{"display":"Chithara","value":"Chithara","ref":"User","operation":"add"},{"display":"Rukshan","value":"Rukshan","ref":"User","operation":"add"}]}' https://localhost:9443/scim2/Groups)

# Check if the interns group creation was successful
if echo "$interns_response" | grep -q '"displayName":"interns"'; then
  # Print success message
  echo -e "${PURPLE}${BOLD}The interns group has been created successfully.${NC}"
  echo -e "${PURPLE}Additional Details:${NC}"
  echo -e "${PURPLE}- Display Name:${NC} interns"
  echo -e "${PURPLE}- Members:${NC}"
  echo -e "${PURPLE}  - Randul${NC}"
  echo -e "${PURPLE}  - Chithara${NC}"
  echo -e "${PURPLE}  - Rukshan${NC}"
else
  # Print failure message
  echo -e "${RED}${BOLD}Failed to create the interns group.${NC}"
  echo -e "${RED}${BOLD}Error Response: ${interns_response}${NC}"
fi
echo

# Create interns group
#curl -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{"displayName":"interns","members":[{"display":"Jayana","value":"Jayana","ref":"User","operation":"add"},{"display":"Randul","value":"Randul","ref":"User","operation":"add"},{"display":"Chithara","value":"Chithara","ref":"User","operation":"add"},{"display":"Rukshan","value":"Rukshan","ref":"User","operation":"add"}]}' https://localhost:9443/api/identity/group/v1.0/groups

# Create mentors group
#curl -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{"displayName":"mentors","members":[{"display":"Ashen","value":"Ashen","ref":"User","operation":"add"},{"display":"Chamath","value":"Chamath","ref":"User","operation":"add"}]}' https://localhost:9443/api/identity/group/v1.0/groups




