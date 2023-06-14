#!/bin/bash

# Define colours
RED='\033[0;31m'
GREEN='\033[0;32m\033[1m'
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

# Define variables
#TENANT_EP="https://localhost:9443/t/carbon.super/api/server/v1/tenants"
TENANT_EP="https://localhost:9443/api/server/v1/tenants"
USERNAME="dummyuser"
PASSWORD="dummypassword"
EMAIL="dummyuser@wso2.com"
FIRSTNAME="Dummy"
LASTNAME="User"
TELEPHONE="+94 123 4567"

# Create tenant
response=$(curl -k --location --request POST "$TENANT_EP" \
  --header 'accept: */*' \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --data-raw '{"domain":"wso2.com","owners":[{"username":"dummyuser","password":"dummypassword","email":"dummyuser@wso2.com","firstname":"Dummy","lastname":"User","provisioningMethod":"inline-password","additionalClaims":[{"claim":"http://wso2.org/claims/telephone","value":"+94 76 318 6705"}]}]}')

echo "Curl response: $response"

# Check if the response contains any error message
if echo "$response" | grep -q '"error":'; then
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq -r '.error[0].description')
  echo -e "${RED}${BOLD}Failure: $error_description${NC}"
else
  # If there is no error, print the success message
  echo -e "${PURPLE}${BOLD}Success: Tenant has been created successfully using a tenanted url.${NC}"

  # Print the details of the successful response
  echo -e "${PURPLE}${BOLD}Response Details:${NC}"
  echo "$response" | jq '.'

  # Print the additional information with all the details
  echo -e "${PURPLE}${BOLD}A tenant has been created with a user.${NC}"
  echo -e "Tenant name: ${PURPLE}dummyuser@wso2.com${NC}"
  echo -e "User name: ${PURPLE}$USERNAME${NC}"
  echo
  echo -e "${PURPLE}${BOLD}Additional Details:${NC}"
  echo -e "Domain: ${PURPLE}wso2.com${NC}"
  echo -e "Owner:"
  echo -e "  Username: ${PURPLE}$USERNAME${NC}"
  echo -e "  Password: ${PURPLE}$PASSWORD${NC}"
  echo -e "  Email: ${PURPLE}$EMAIL${NC}"
  echo -e "  First Name: ${PURPLE}$FIRSTNAME${NC}"
  echo -e "  Last Name: ${PURPLE}$LASTNAME${NC}"
  echo -e "  Provisioning Method: ${PURPLE}inline-password${NC}"
  echo -e "  Additional Claims:"
  echo -e "    Claim: ${PURPLE}http://wso2.org/claims/telephone${NC}"
  echo -e "    Value: ${PURPLE}$TELEPHONE${NC}"
fi

# Extract tenant ID from the response
tenant_id=$(echo "$response" | jq -r '.tenant_id')

# Encode client_id:client_secret in base64
base64_encoded_sp=$(echo -n "dummyuser:dummypassword")

# Register service provider inside the tenant
response=$(curl -k -i --location --request POST "https://localhost:9443/t/wso2.com/api/server/v1/applications" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Basic ZHVtbXl1c2VyOmR1bW15cGFzc3dvcmQ=" \
  --data-raw '{  "client_name": "tenant app", "grant_types": ["authorization_code","implicit","password","client_credentials","refresh_token"], "redirect_uris":["http://localhost:8080/playground2"] }')
                            
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

# Encode client_id:client_secret in base64
base64_encoded_token=$(echo -n "dummyuser@wso2.com:dummypassword")

  # Generate access token
  access_token_response=$(curl -k -i --location --request POST "https://localhost:9443/t/wso2.com/api/server/oauth2/token" \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --header "Authorization: Basic ZHVtbXl1c2VyOmR1bW15cGFzc3dvcmQ=" \
    --data-urlencode 'grant_type=password' \
    --data-urlencode 'username=dummyuser' \
    --data-urlencode 'password=dummypassword' \
    --data-urlencode 'scope=samplescope')

  # Check if the response contains any error message
  if echo "$access_token_response" | grep -q '"error":'; then
    # If there is an error, print the failure message with the error description
    error_description=$(echo "$access_token_response" | jq -r '.error_description')
    echo -e "${RED}No access token generated from the tenant.${NC}"
    echo -e "${RED}${BOLD}Failure: $error_description${NC}"
  else
    # If there is no error, print the success message
    echo -e "${PURPLE}${BOLD}Success: Access token generated from the service provider registered in the tenant successfully.${NC}"

    # Print the details of the successful response
    echo -e "${PURPLE}Response Details:${NC}"
    echo "$access_token_response"

    # Extract access token from response
    #access_token=$(echo "$access_token_response" | jq -r '.access_token')
    access_token=$(echo "$access_token_response" | grep -o '"access_token":"[^"]*' | cut -d':' -f2 | tr -d '"')

    if [ -n "$access_token" ]; then
      # Store access token in a file
      echo "access_token=$access_token" >>tenant_credentials

      # Print tenant access token in file
      echo -e "${PURPLE}Tenant Access Token:${NC}"
      cat tenant_credentials

      # Print success message
      echo -e "${PURPLE}Generated an access token from the service provider registered in the tenant successfully!${NC}"
    else
      # Print error message
      echo -e "${RED}No access token generated from the service provider registered in tenant.${NC}"
    fi
  fi
fi

# Generate access token from carbon.super
##############################################################################################


# Register service provider inside the super tenant
response=$(curl -k --location --request POST "https://localhost:9443/carbon.super/api/server/v1/applications" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Basic YWRtaW46YWRtaW4=" \
  --data-raw '{  "client_name": "tenant app", "grant_types": ["authorization_code","implicit","password","client_credentials","refresh_token"], "redirect_uris":["http://localhost:8080/playground2"] }')
                            
# Check if the response contains any error message
if echo "$response" | grep -q '"error":'; then
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq -r '.error_description')
  echo -e "${RED}${BOLD}Failure in registering a service provider inside the super tenant: $error_description${NC}"
else
  # If there is no error, print the success message
  echo -e "${PURPLE}${BOLD}Success: Service provider registered inside super tenant successfully.${NC}"

  # Print the details of the successful response
  echo -e "${PURPLE}Response Details:${NC}"
  echo "$response"

 # Generate access token - from super tenant
  access_token_response=$(curl -k --location --request POST "https://localhost:9443/t/carbon.super/api/server/oauth2/token" \
    --header 'Content-Type: application/x-www-form-urlencoded' \
    --header "Authorization: Basic YWRtaW46YWRtaW4=" \
    --data-urlencode 'grant_type=password' \
    --data-urlencode 'username=admin' \
    --data-urlencode 'password=admin' \
    --data-urlencode 'scope=samplescope')

  # Check if the response contains any error message
  if echo "$access_token_response" | grep -q '"error":'; then
    # If there is an error, print the failure message with the error description
    error_description=$(echo "$access_token_response" | jq -r '.error_description')
    echo -e "${RED}No access token generated from the super tenant.${NC}"
    echo -e "${RED}${BOLD}Failure: $error_description${NC}"
  else
    # If there is no error, print the success message
    echo -e "${PURPLE}${BOLD}Success: Access token generated from the service provider registered in the super tenant successfully.${NC}"

    # Print the details of the successful response
    echo -e "${PURPLE}Response Details:${NC}"
    echo "$access_token_response"

    # Extract access token from response
    #access_token=$(echo "$access_token_response" | jq -r '.access_token')
    access_token=$(echo "$access_token_response" | grep -o '"access_token":"[^"]*' | cut -d':' -f2 | tr -d '"')

    if [ -n "$access_token" ]; then
      # Store access token in a file
      echo "access_token=$access_token" >>tenant_credentials

      # Print tenant access token in file
      echo -e "${PURPLE}Tenant Access Token:${NC}"
      cat tenant_credentials

      # Print success message
      echo -e "${PURPLE}Generated an access token from the service provider registered in the tenant successfully!${NC}"
    else
      # Print error message
      echo -e "${RED}No access token generated from the tenant.${NC}"
    fi
  fi
fi