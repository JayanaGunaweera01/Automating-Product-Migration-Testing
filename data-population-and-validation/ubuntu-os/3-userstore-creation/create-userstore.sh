#!/bin/bash

cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
  chmod +x env.sh
  . ./env.sh

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
YELLOW='\033[0;33m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Create the userstore in Identity Server
response=$(curl -k --location --request POST "$USERSTORE_EP" \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --data-raw '{
    "typeId": "SkRCQ1VzZXJTdG9yZU1hbmFnZXI",
    "description": "Sample JDBC user store to add.",
    "name": "'"$USERSTORE_NAME"'",
    "properties": [
      {
        "name": "userName",
        "value": "testdb"
      },
      {
        "name": "password",
        "value": "testdb"
      },
      {
        "name": "driverName",
        "value": "com.mysql.jdbc.Driver"
      },
      {
        "name": "url",
        "value": "jdbc:mysql://localhost:3306/testdb?useSSL=false"
      },
      {
        "name": "disabled",
        "value": "false"
      }
    ]
  }')

# Check if the response contains any error message
if echo "$response" | grep -q '"typeId":'; then
  # If there is no error, print the success message
  echo "${GREEN}${BOLD}A userstore has been created in Identity Server. Userstore name=${USERSTORE_NAME}${NC}"
  # Print the additional details
  echo "Additional Details:"
  echo "Userstore Name: ${PURPLE}$USERSTORE_NAME${NC}"
  echo "Userstore Description: ${PURPLE}Sample JDBC user store to add.${NC}"
  echo "Userstore Properties:"
  echo "  - Property: userName, Value: ${PURPLE}testdb${NC}"
  echo "  - Property: password, Value: ${PURPLE}testdb${NC}"
  echo "  - Property: driverName, Value: ${PURPLE}com.mysql.jdbc.Driver${NC}"
  echo "  - Property: url, Value: ${PURPLE}jdbc:mysql://localhost:3306/testdb?useSSL=false${NC}"
  echo "  - Property: disabled, Value: ${PURPLE}false${NC}"

else
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq -r '.error[0].description')
  echo "${RED}${BOLD}Failure: $error_description${NC}"
fi
echo
