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
  echo "${GREEN}==> Env file for Ubuntu sourced successfully"
fi
if [ "$os" = "macos-latest" ]; then

  chmod +x env.sh
  source "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh"
  echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"

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
  echo "${RED}${BOLD}Failure: $error_description${NC}"

else
  # If there is no error, print the success message
  echo "${GREEN}${BOLD}Success: Tenant has been created successfully.${NC}"
  # Print the details of the successful response
  echo "${PURPLE}Response Details:${NC}"
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
  echo "${RED}${BOLD}Failure in registering a service provider inside the tenant: $error_description${NC}"
else
  # If there is no error, print the success message
  echo "${GREEN}${BOLD}Success: Service provider registered successfully.${NC}"

  # Print the details of the successful response
  echo "${PURPLE}Response Details:${NC}"
  echo "$response" | jq '.'
fi


# Extract client_id and client_secret
client_id=$(echo "$response" | jq -r '.client_id')
client_secret=$(echo "$response" | jq -r '.client_secret')

# Encode client_id:client_secret as base64
base64_encoded=$(echo -n "$client_id:$client_secret" | base64)

# Generate access token
response=$(curl -k --location --request POST 'https://localhost:9443/t/iit.com/oauth2/token' \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --header "Authorization: Basic YWRtaW46YWRtaW4=" \
  --data-urlencode 'grant_type=client_credentials' \
  --data-urlencode 'scope=samplescope')

# Check if the response contains any error message
if echo "$response" | grep -q '"error":'; then
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq -r '.error_description')
  echo "${RED}No access token generated from tenant.${NC}"
  echo "${RED}${BOLD}Failure: $error_description${NC}"
else
  # If there is no error, print the success message
  echo "${GREEN}${BOLD}Success: Access token generated from the service provider registered in the tenant successfully.${NC}"

  # Print the details of the successful response
  echo "${PURPLE}Response Details:${NC}"
  echo "$response" | jq '.'
fi

# Extract access token from response
access_token=$(echo "$response" | jq -r '.access_token')
if [ -n "$access_token" ]; then
  # Store access token in a file
  echo "access_token=$access_token" >> tenant_credentials

  # Print tenant access token in file
  echo "${PURPLE}Tenant Access Token:${NC}"
  cat tenant_credentials

  # Print success message
  echo "${GREEN}Generated an access token from the service provider registered in the tenant successfully!.${NC}"
else
  # Print error message
  echo "${RED}No access token generated from tenant.${NC}"
fi
echo