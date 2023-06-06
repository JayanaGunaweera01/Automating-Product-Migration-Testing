#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Get the directory of the script
script_dir="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/mac-os/4-service-provider-creation"

# Load client_id and client_secret from file
if [ -f "$script_dir/client_credentials" ]; then
  echo "${YELLOW}Client Credentials File:${NC}"
  cat "$script_dir/client_credentials"
  . "$script_dir/client_credentials"
  echo "${GREEN}Client_credentials sourced.${NC}"
else
  echo "${RED}Error: client_credentials file not found.${NC}"
  exit 1
fi

# Encode client_id:client_secret as base64
# base64_encoded=$(echo -n "$client_id:$client_secret" | base64)

# Encode client_id:client_secret as base64 without the -n issue
#base64_encoded=$(echo -n "$client_id:$client_secret" | base64 | tr -d '\n')

# Encode client_id:client_secret as base64 without the leading -n
#base64_encoded=$(echo -n "$client_id:$client_secret" | base64 | sed 's/-n //')

# Encode client_id:client_secret as base64 without the leading -n
#base64_encoded=$(echo -n "${client_id#-n}:$client_secret" | base64)

# Remove leading -n from client_id
#client_id=$(echo "$client_id" | awk '{sub(/^-n/, "")} 1')

# Encode client_id:client_secret as base64
#base64_encoded=$(echo -n "$client_id:$client_secret" | base64)

# Remove leading -n from client_id, if present
client_id=$(echo "$client_id" | sed 's/^-n//')

# Encode client_id:client_secret as base64
base64_encoded=$(echo -n "$client_id:$client_secret" | base64)



# Get access token
echo "${YELLOW}Getting access token...${NC}"
token_response=$(curl -ks -X POST https://localhost:9443/oauth2/token \
  -H "Authorization: Basic $base64_encoded" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'grant_type=password&username=admin&password=admin&scope=somescope_password')

echo "Token_response: $token_response"
# Extract access token and refresh token from response
access_token=$(echo "$token_response" | jq -r '.access_token')
refresh_token=$(echo "$token_response" | jq -r '.refresh_token')

# Print access token and refresh token
if [ "$access_token" != "null" ]; then
  echo "Access token: $access_token"
fi
if [ "$refresh_token" != "null" ]; then
  echo "Refresh token: $refresh_token"
fi

# Store access token and refresh token in a file
if grep -q "access_token" "$script_dir/client_credentials"; then
  sed -i '' "s/access_token=.*/access_token=$access_token/" "$script_dir/client_credentials"
else
  echo "access_token=$access_token" >> "$script_dir/client_credentials"
fi

if grep -q "refresh_token" "$script_dir/client_credentials"; then
  sed -i '' "s/refresh_token=.*/refresh_token=$refresh_token/" "$script_dir/client_credentials"
else
  echo "refresh_token=$refresh_token" >> "$script_dir/client_credentials"
fi

# Validate the database
validation=$(curl -k -H "Authorization: Bearer $access_token" -H 'Content-Type: application/json' -X GET https://localhost:9443/api/identity/oauth2/dcr/v1.1/register/$client_id)
echo "Database validation: $validation"