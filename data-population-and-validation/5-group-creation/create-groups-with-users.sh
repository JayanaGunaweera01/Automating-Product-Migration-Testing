#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
PURPLE='\033[1;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Identity Server URL and credentials
IS_URL="https://localhost:9443"
USERNAME="admin"
PASSWORD="admin"

# User details
USERS=("Jayana" "Randul" "Chithara" "Rukshan")

# Create users in the PRIMARY user store
for user in "${USERS[@]}"; do
    response=$(curl -k --location --request POST "$IS_URL/api/identity/user/v1.0/me/user-stores/PRIMARY/users" \
        --header 'Content-Type: application/json' \
        --header "Authorization: Basic $(echo -n "$USERNAME:$PASSWORD" | base64)" \
        --data-raw '{
            "schemas": ["urn:ietf:params:scim:schemas:core:2.0:User"],
            "userName": "'"$user"'",
            "password": "Userstorepassword@123"
        }')

    # Check if the user creation is successful
    if [ $(echo "$response" | jq -r '.userName') = "$user" ]; then
        echo -e "User '${GREEN}${BOLD}$user${NC}' created successfully"
    else
        echo -e "${RED}${BOLD}Failed to add user '$user' to the 'PRIMARY' user store.${NC}"
        echo "Response Code: $(echo "$response" | jq -r '.status')"
    fi
done

# Create the 'interns' group
group_response=$(curl -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic $(echo -n "$USERNAME:$PASSWORD" | base64)" \
    -d '{
        "displayName": "interns",
        "members": [
            {"display": "Jayana", "value": "Jayana", "ref": "User", "operation": "add"},
            {"display": "Randul", "value": "Randul", "ref": "User", "operation": "add"},
            {"display": "Chithara", "value": "Chithara", "ref": "User", "operation": "add"},
            {"display": "Rukshan", "value": "Rukshan", "ref": "User", "operation": "add"}
        ]
    }' "$IS_URL/api/identity/group/v1.0/groups")

# Check if the group creation is successful
if [ $(echo "$group_response" | jq -r '.displayName') = "interns" ]; then
    echo -e "Group '${GREEN}${BOLD}interns${NC}' created successfully"
else
    echo -e "${RED}${BOLD}Failed to create the 'interns' group.${NC}"
    echo "Response Code: $(echo "$group_response" | jq -r '.status')"
fi


# Create interns group
#curl -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{"displayName":"interns","members":[{"display":"Jayana","value":"Jayana","ref":"User","operation":"add"},{"display":"Randul","value":"Randul","ref":"User","operation":"add"},{"display":"Chithara","value":"Chithara","ref":"User","operation":"add"},{"display":"Rukshan","value":"Rukshan","ref":"User","operation":"add"}]}' https://localhost:9443/api/identity/group/v1.0/groups

# Create mentors group
#curl -k -X POST -H "Content-Type: application/json" -H "Authorization: Basic YWRtaW46YWRtaW4=" -d '{"displayName":"mentors","members":[{"display":"Ashen","value":"Ashen","ref":"User","operation":"add"},{"display":"Chamath","value":"Chamath","ref":"User","operation":"add"}]}' https://localhost:9443/api/identity/group/v1.0/groups




