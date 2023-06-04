#!/bin/bash

# Define colors
GREEN='\033[1;38;5;206m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Create a user in the service provider
response=$(curl -k --location --request POST "$SP_USER_REGISTER_EP" \
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

# Check if the user creation was successful
if echo "$response" | grep -q '"userName":'; then
    # Print success message
    echo -e "${GREEN}${BOLD}A user has been created in the service provider.${NC}"
    # Print user details
    echo "Name of user created in SP: $SP_USER_NAME"
else
    # Print failure message
    echo "${RED}${BOLD}Failed to create the user in the service provider.${NC}"
    # Print error details
    echo "Error Details:"
    echo "$response"
fi
echo

