#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Get the directory of the script
script_dir="$(dirname "$(realpath "$0")")"

# Load client_id and client_secret from file
if [ -f "$script_dir/client_credentials" ]; then
  . "$script_dir/client_credentials"
  echo "${GREEN}Sourced client_credentials file.${NC}"
else
  echo "${RED}Error: client_credentials file not found.${NC}"
  exit 1
fi

# Encode client_id:client_secret as base64
base64_encoded=$(echo -n "$client_id:$client_secret" | base64)

# Get access token
echo "${YELLOW}Getting access token...${NC}"
token_response=$(curl -ks -X POST https://localhost:9443/oauth2/token \
  -H "Authorization: Basic $base64_encoded" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -d 'grant_type=password&username=admin&password=admin&scope=somescope_password')

# Extract access token and refresh token from response
access_token=$(echo "$token_response" | jq -r '.access_token')
refresh_token=$(echo "$token_response" | jq -r '.refresh_token')

# Check if access_token and refresh_token are present
if [ -n "$access_token" ] && [ -n "$refresh_token" ]; then
  # Print access token and refresh token if found
  if [ "$access_token" != "null" ]; then
    echo -e "Access token: \033[31m$access_token\033[0m"
    access_token_found=true
  else
    echo "No access token found."
    access_token_found=false
  fi
  if [ "$refresh_token" != "null" ]; then
    echo -e "Refresh token: \033[31m$refresh_token\033[0m"
    refresh_token_found=true
  else
    echo "No refresh token found."
    refresh_token_found=false
  fi

  # Store access token and refresh token in a file
  if grep -q "access_token" client_credentials; then
    sed -i "s/access_token=.*/access_token=$access_token/" client_credentials
  else
    echo "access_token=$access_token" >> client_credentials
  fi

  if grep -q "refresh_token" client_credentials; then
    sed -i "s/refresh_token=.*/refresh_token=$refresh_token/" client_credentials
  else
    echo "refresh_token=$refresh_token" >> client_credentials
  fi

  # Check if both access_token and refresh_token are found, and print success message
  if [ "$access_token_found" = true ] && [ "$refresh_token_found" = true ]; then
    echo "${GREEN}An access token and a refresh token generated successfully.${NC}"
  fi
else
  echo "${GREEN}Database validation failed.${NC}"
fi
