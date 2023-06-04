#!/bin/bash

cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
  chmod +x env.sh
  . ./env.sh

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Register the service provider
response=$(curl -k --location --request POST 'https://localhost:9443/api/identity/oauth2/dcr/v1.1/register' \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --header 'Content-Type: application/json' \
    --data-raw '{  "client_name": "test migration app", "grant_types": ["authorization_code","implicit","password","client_credentials","refresh_token"], "redirect_uris":["http://localhost:8080/playground2"] }')

# Check if the registration was successful
if echo "$response" | grep -q '"client_name":'; then
    # Print success message
    echo "Registered a service provider successfully!"
    # Print service provider details
    echo -e "${GREEN}${BOLD}A new service provider has been registered. Service provider name=test migration app${NC}"
else
    # Print failure message
    echo "${RED}${BOLD}Failed to register the service provider.${NC}"
    # Print error details
    echo "Error Details:"
    echo "$response"
fi
echo

