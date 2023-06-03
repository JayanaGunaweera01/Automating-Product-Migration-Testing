#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
YELLOW='\033[0;33m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# make the curl request and capture the response
response=$(curl -k --location --request POST "$SCIM_USER_EP" \
  --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
  --header 'Content-Type: application/json' \
  --data-raw '{
  "schemas": [],
  "name": {
    "givenName": '$GIVEN_NAME',
    "familyName": '$GIVEN_FAMILY_NAME'
  },
  "userName": '$GIVEN_USER_NAME',
  "password": '$GIVEN_PASSWORD',
  "emails": [
    {
      "type": "home",
      "value": '$GIVEN_USER_EMAIL_HOME',
      "primary": true
    },
    {
      "type": "work",
      "value": '$GIVEN_USER_EMAIL_WORK'
    }
  ],
  "urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
    "employeeNumber": "1234A",
    "manager": {
      "value": "Taylor"
    }
  }
}')

# Check if the response contains any error message
if echo "$response" | grep -q '"Errors":'; then
  # If there is an error, print the failure message with the error description
  error_description=$(echo "$response" | jq '.Errors[0].description')
  echo "${RED}${BOLD}Failure: $error_description${NC}"
else
    # If there is no error, print the success message with the output
    echo "${GREEN}${BOLD}Success: $response${NC}"
    # Print the additional information with all the details
    echo "${PURPLE}${BOLD}An Identity Server user has been created successfully.${NC}"
    # Print the additional information with all the details
    echo "User Name: ${PURPLE}${GIVEN_USER_NAME}${NC}"
    echo "Given Name: ${PURPLE}${GIVEN_NAME}${NC}"
    echo "Family Name: ${PURPLE}${GIVEN_FAMILY_NAME}${NC}"
    echo "Email (Home): ${PURPLE}${GIVEN_USER_EMAIL_HOME}${NC}"
    echo "Email (Work): ${PURPLE}${GIVEN_USER_EMAIL_WORK}${NC}"
    echo
fi
