#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
YELLOW='\033[0;33m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

os=$1

# Set deployment file and path based on OS
if [ "$os" = "ubuntu-latest" ]; then

  chmod +x env.sh
  . "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh"
  echo -e "${GREEN}==> Env file for Ubuntu sourced successfully"
fi
if [ "$os" = "macos-latest" ]; then

  chmod +x env.sh
  source "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh"
  echo -e "${GREEN}==> Env file for Mac sourced successfully${RESET}"

fi

# Set the server URL
server_url="https://localhost:9443"

# Set the tenant domain
tenant_domain="iit@iit.com"

# Set the application name
application_name="MigrationApp"

# Get the tenant Id
tenant_id=$(curl -k -X GET -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" "${server_url}/api/identity/user/v0.9/tenants?tenantDomain=${tenant_domain}" | jq -r '.tenantId')

# Create the service provider
response=$(curl -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d "{
    \"applicationName\":\"${application_name}\",
    \"description\":\"Application for ${application_name}\",
    \"saasApp\":true,
    \"inboundProvisioningConfig\": {
    \"provisioningEnabled\": true,
    \"deprovisioningEnabled\": true,
    \"userstore\": \"PRIMARY\"
    },
    \"owner\": \"admin\",
    \"appOwner\":\"admin\",
    \"tenantId\":\"${tenant_id}\",
    \"permissionAndRoleConfig\":{
    \"roleMappings\":[]
    }
}" "${server_url}/api/identity/application/v1.0/service-providers")

# Check if the response contains any error message
if echo "$response" | grep -q '"code":'; then
    # If there is an error, print the failure message with the error description
    error_code=$(echo "$response" | jq -r '.code')
    error_message=$(echo "$response" | jq -r '.message')
    echo -e "${RED}${BOLD}Failure: Error $error_code - $error_message${NC}"
else
    # If there is no error, print the success message
    echo -e "${PURPLE}${BOLD}Success: A service provider has been generated in tenant=$tenant_domain${NC}.${PURPLE}${BOLD}Application name=$application_name${NC}"
    # Print the details of the successful response
    echo -e "${PURPLE}Response Details${NC}:"
    echo "$response" | jq '.'

fi
echo
