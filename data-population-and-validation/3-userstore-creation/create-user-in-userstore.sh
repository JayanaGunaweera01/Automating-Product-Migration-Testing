#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[1;38;5;206m'
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

# Create the user store
user_store_response=$(curl -k --location --request POST "https://localhost:9443/api/server/v1/userstores" \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --data-raw '{
    "typeId": "SkRCQ1VzZXJTdG9yZU1hbmFnZXI",
    
    "description": "Sample JDBC user store to add.",
    "name": "Testuserstore",
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
        "value": "jdbc:mysql://localhost:3306/testdb?useSSL=false&amp;allowPublicKeyRetrieval=true"
      },
      {
        "name": "disabled",
        "value": "false"
      }
    ]
  }')

echo "Userstore Creation Response: "$user_store_response""

if [ -n "$user_store_response" ]; then
    echo -e "${PURPLE}${BOLD}User store 'Testuserstore' has been created successfully.${NC}"
    echo -e "${PURPLE}${BOLD}User Store Response:${NC}"
    echo "$user_store_response"
fi

# Create a user in the userstore
user_creation_response=$(curl -k -i --location --request POST "$SCIM_USER_EP_USERSTORE" \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --data-raw '{"schemas":[],"userName":"'$USERSTORE_USER_NAME'","password":"'$USERSTORE_USER_PASSWORD'","wso2Extension":{"employeeNumber":"000111","costCenter":"111111","organization":"WSO2Org","division":"'$USERSTORE_GROUP_NAME'","department":"Intigration","manager":{"managerId":"111000","displayName":"'$USERSTORE_USER_NAME'"}}}')
echo -e "${PURPLE}${BOLD}A user has been created in the userstore successfully.${NC}"
echo -e "${PURPLE}${BOLD}User Creation Response${NC}: ""$user_creation_response"


user_store_response=$(curl -k -X 'POST' \
  'https://localhost:9443/t/carbon.super/api/server/v1/userstores' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "typeId": "VW5pcXVlSURKREJDVXNlclN0b3JlTWFuYWdlcg",
  "description": "Some description about the user store.",
  "name": "UniqueIDJDBCUserStoreManager",
  "properties": [
    {
      "name": "some property name",
      "value": "some property value"
    }
  ]
}')

echo "$user_store_response"

user_store_response=$(curl -k --location --request POST "https://localhost:9443/t/carbon.super/api/server/v1/userstores/UniqueIDJDBCUserStoreManager/users" \
    --header 'Content-Type: application/json' \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --data-raw '{
        "schemas": [],
        "userName": "Jayana",
        "password": "jayanapass",
        ""urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"": {
            "employeeNumber": "000111",
            "costCenter": "111111",
            "organization": "WSO2Org",
            "division": “Engineering",
            "department": "Integration",
            "manager": {
                "managerId": "111000",
                "displayName": “Jayana"
            }
        }
    }')

echo "$user_store_response"
echo "user added"

#cd /home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/IS_HOME_OLD/wso2is-5.11.0/repository/deployment/server/userstores

# Find the file containing the specified property
#file=Testuserstore.xml

#if [ -n "$file" ]; then
#  echo "File found: $file"

# Check if the property already exists in the file
# if ! grep -q '<Property name="SCIMEnabled">true</Property>' "$file"; then
# Add the property to the file right below the specified line with proper indentation
#   sed -i '/<Property name="Description">Sample JDBC user store to add.<\/Property>/a \ \ <Property name="SCIMEnabled">true<\/Property>' "$file"
#   echo "Property added successfully."
# else
#   echo "Property already exists in the file."
# fi

# Display the contents of the file
# cat "$file"
#else
# echo "File not found."
#fi

#chmod +x Testuserstore.xml

#   response=$(curl -v -k --user admin:admin --data '{"schemas":[],"name":{"familyName":"jackson","givenName":"kim"},"userName":"Testuserstore/kim","password":"kimwso2","emails":[{"primary":true,"value":"kim.jackson@gmail.com","type":"home"},{"value":"kim_j@wso2.com","type":"work"}]}' --header "Content-Type:application/json" https://localhost:9443/scim2/Users)
#   echo "$response"

#   response=$(curl -k --user admin:admin --data '{"displayName": "Testuserstore/AMRSNGHE"}' --header "Content-Type: application/json" https://localhost:9443/wso2/scim/Groups)
#   echo "$response"
# Create a group in the user store domain
#   group_response=$(curl -k --user admin:admin --data '{"displayName": "Testuserstore/AMRSNGHE"}' --header "Content-Type: application/json" https://localhost:9443/wso2/scim/Groups)
#   echo "Group Creation Response: "$group_response""
#   group_id=$(echo "$group_response" | jq -r '.id')

#   if [ -n "$group_id" ]; then
#       echo -e "${PURPLE}${BOLD}Group has been created successfully in the user store domain.${NC}"
#       echo -e "${PURPLE}${BOLD}Group Response:${NC}"
#       echo "$group_response"

# Create a user in the given user store domain
#       user_response=$(curl -k --user admin:admin --data '{"schemas":[],"name":{"familyName":"John","givenName":"Doe"},"userName":"Testuserstore/AMRSNGHE","password":"testPwd123"}' --header "Content-Type: application/json" https://localhost:9443/wso2/scim/Users)
#      echo "User Creation Response: "$user_response""
#      user_id=$(echo "$user_response" | jq -r '.id')

#       if [ -n "$user_id" ]; then
#          echo -e "${PURPLE}${BOLD}User has been created successfully in the given user store domain.${NC}"
#          echo -e "${PURPLE}${BOLD}User Response:${NC}"
#         echo "$user_response"

# Add the user to the created group
#          add_user_to_group_response=$(curl -k --user admin:admin --request PATCH --data '{"members":[{"value":"'$user_id'"}]}' --header "Content-Type: application/json" "https://localhost:9443/wso2/scim/Groups/$group_id")
#          echo "User Adding To The Group Response: "$add_user_to_group_response""
#          if [ -n "$add_user_to_group_response" ]; then
#              echo -e "${PURPLE}${BOLD}User has been added to the group successfully.${NC}"
#              echo -e "${PURPLE}${BOLD}Add User to Group Response:${NC}"
#             echo "$add_user_to_group_response"
#         else
#             echo -e "${RED}${BOLD}Failed to add the user to the group.${NC}"
#             echo -e "${RED}${BOLD}Error Message:${NC} $add_user_to_group_response"
#         fi
#      else
#          echo -e "${RED}${BOLD}Failed to create the user in the given user store domain.${NC}"
#          echo -e "${RED}${BOLD}Error Message:${NC} $user_response"
#      fi
#  else
#       echo -e "${RED}${BOLD}Failed to create the group in the user store domain.${NC}"
#       echo -e "${RED}${BOLD}Error Message:${NC} $group_response"
#  fi

#else
#   echo -e "${RED}${BOLD}Failed to create the user store.${NC}"
#   echo -e "${RED}${BOLD}Error Message:${NC} $user_store_response"
#fi
