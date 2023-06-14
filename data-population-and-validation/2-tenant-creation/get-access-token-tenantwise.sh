#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m\033[1m'
YELLOW='\033[0;33m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

os=$1

# Set deployment file and path based on OS
if [ "$os" = "ubuntu-latest" ]; then

  chmod +x env.sh
  . "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh"
  echo -e "${GREEN}==> Env file for Ubuntu sourced successfully${NC}"
fi
if [ "$os" = "macos-latest" ]; then

  chmod +x env.sh
  source "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh"
  echo -e "${GREEN}==> Env file for Mac sourced successfully${NC}"

fi

# Create tenant
response=$(curl -k --location --request POST 'https://localhost:9443/api/server/v1/tenants' \
  --header 'accept: */*' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --data-raw '{"domain":"iit.com","owners":[{"username":"admin","password":"admin","email":"jayana@iit.com","firstname":"Jayana","lastname":"Gunaweera","provisioningMethod":"inline-password","additionalClaims":[{"claim":"http://wso2.org/claims/telephone","value":"+94 562 8723"}]}]}')

# Check if the response contains any error message
if echo "$response" | grep -q '"error":'; then
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq -r '.error_description')
  echo -e "${RED}${BOLD}Failure: $error_description${NC}"

else
  # If there is no error, print the success message
  echo -e "${PURPLE}${BOLD}Success: Tenant has been created successfully.${NC}"
  # Print the details of the successful response
  echo -e "${PURPLE}Response Details:${NC}"
  echo "$response" | jq '.'
fi

# Extract client_id and client_secret from response
client_id=$(echo "$response" | jq -r '.client_id')
client_secret=$(echo "$response" | jq -r '.client_secret')

# Encode client_id:client_secret in base64
base64_encoded=$(echo -n "$client_id:$client_secret" | base64)

# Register service provider
response=$(curl -k --location --request POST 'https://localhost:9443/t/iit.com/api/server/v1/service/register' \
  --header "Authorization: Basic YWRtaW46YWRtaW4=" \
  --header 'Content-Type: application/json' \
  --data-raw '{  "client_name": "migration app", "grant_types": ["authorization_code","implicit","password","client_credentials","refresh_token"], "redirect_uris":["http://localhost:8080/playground2"] }')

# Check if the response contains any error message
if echo "$response" | grep -q '"error":'; then
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq -r '.error_description')
  echo -e "${RED}${BOLD}Failure in registering a service provider inside the tenant: $error_description${NC}"
else
  # If there is no error, print the success message
  echo -e "${PURPLE}${BOLD}Success: Service provider registered successfully.${NC}"

  # Print the details of the successful response
  echo -e "${PURPLE}Response Details:${NC}"
  echo "$response"
fi

# Extract client_id and client_secret from response
client_id=$(echo "$response" | jq -r '.client_id')
client_secret=$(echo "$response" | jq -r '.client_secret')

# Check if client_id and client_secret are empty
if [ -z "$client_id" ] || [ -z "$client_secret" ]; then
  # Print error message
  error_description=$(echo "$response" | jq -r '.error_description')
  echo -e "${RED}${BOLD}Failure: $error_description${NC}"
fi

# Encode client_id:client_secret in base64
base64_encoded=$(echo -n "$client_id:$client_secret" | base64)

# Generate access token
response=$(curl -k --location --request POST 'https://localhost:9443/t/iit.com/oauth2/token' \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --header "Authorization: Basic $base64_encoded" \
  --data-urlencode 'grant_type=password' \
  --data-urlencode 'username=admin@iit.com' \
  --data-urlencode 'password=admin' \
  --data-urlencode 'scope=samplescope')

 echo "Access Token Response: $response"