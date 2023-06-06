#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m\033[1m'
YELLOW='\033[0;33m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get the directory of the script
script_dir="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/mac-os/4-service-provider-creation"

# Load client_id and client_secret from file
if [ -f "$script_dir/client_credentials" ]; then
  echo -e "${YELLOW}${BOLD}Client Credentials File:${NC}"
  cat "$script_dir/client_credentials"
  . "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/mac-os/4-service-provider-creation/client_credentials"
  echo -e "${GREEN}Client_credentials sourced.${NC}"
else
  echo -e "${RED}${BOLD}Error: client_credentials file not found.${NC}"
  exit 1
fi

base64_encoded=$(printf "%s:%s" "$client_id" "$client_secret" | base64)

# Get access token
echo -e "${PURPLE}Getting access token...${NC}"
curl_response=$(curl -ks -X POST https://localhost:9443/oauth2/token \
  -H "Authorization: Basic $base64_encoded" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'grant_type=password&username=admin&password=admin&scope=somescope_password')

echo "Curl_response: $curl_response"
# Extract access token and refresh token from response
access_token=$(echo "$curl_response" | jq -r '.access_token')
refresh_token=$(echo "$curl_response" | jq -r '.refresh_token')

# Print access token and refresh token
if [ "$access_token" != "null" ]; then
  echo -e "Access token: ${PURPLE}$access_token${NC}"
  echo -e "Expires in: $(echo "$curl_response" | jq -r '.expires_in') seconds"
fi
if [ "$refresh_token" != "null" ]; then
  echo -e "Refresh token: ${PURPLE}$refresh_token${NC}"
fi

# Store access token and refresh token in a file
if grep -q "access_token" "$script_dir/client_credentials"; then
  sed -i '' "s/access_token=.*/access_token=$access_token/" "$script_dir/client_credentials"
else
  echo "access_token=$access_token" >>"$script_dir/client_credentials"
fi

if grep -q "refresh_token" "$script_dir/client_credentials"; then
  sed -i '' "s/refresh_token=.*/refresh_token=$refresh_token/" "$script_dir/client_credentials"
else
  echo "refresh_token=$refresh_token" >>"$script_dir/client_credentials"
fi

