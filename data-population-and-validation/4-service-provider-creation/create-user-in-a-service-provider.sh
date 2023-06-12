#!/bin/bash

# Define colors
GREEN='\033[1;38;5;206m'
RED='\033[0;31m'
BOLD='\033[1m'
PURPLE='\033[1;35m'
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

# Create a user in the service provider
response=$(curl -k --location --request POST "$SCIM_USER_EP_USERSTORE" \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "schemas": [],
        "name": {
            "givenName": "'"$SP_USER_NAME"'",
            "familyName": "'"$SP_USER_FAMILY_NAME"'"
        },
        "userName": "lanka",
        "password": "'"$SP_USER_PASSWORD"'",
        "emails": [
            {
                "type": "home",
                "value": "'"$SP_USER_HOME_EMAIL"'",
                "primary": true
            },
            {
                "type": "work",
                "value": "'"$SP_USER_WORK_EMAIL"'"
            }
        ],
        "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
            "employeeNumber": "1234A",
            "manager": {
                "value": "Taylor"
            }
        }
    }')

 echo "$response"
 
# Check if the user creation was successful
if echo "$response" | grep -q '"userName":'; then
    # Print success message
    echo -e "${PURPLE}${BOLD}A user has been created in the service provider.${NC}"
    # Print additional details individually in purple
    echo -e "Additional Details:"
    echo -e "${PURPLE}User Name:${NC} $SP_USER_NAME"
    echo -e "${PURPLE}Family Name:${NC} $SP_USER_FAMILY_NAME"
    echo -e "${PURPLE}User Name:${NC} lanka"
    echo -e "${PURPLE}Home Email:${NC} $SP_USER_HOME_EMAIL"
    echo -e "${PURPLE}Work Email:${NC} $SP_USER_WORK_EMAIL"
    echo -e "${PURPLE}Employee Number:${NC} 1234A"
    echo -e "${PURPLE}Manager:${NC} Taylor"

else
    # Print failure message
    echo -e "${RED}${BOLD}Failed to create the user in the service provider.${NC}"
    # Print error details
    echo -e "${RED}${BOLD}Error Details:${NC}"
    echo "$response"
fi
echo

