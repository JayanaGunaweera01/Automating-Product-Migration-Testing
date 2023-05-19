#!/bin/bash

curl -k --location --request POST "$SP_USER_REGISTER_EP" \
--header 'Authorization: Basic YWRtaW46YWRtaW4=' \
--header 'Content-Type: application/json' \
--data-raw '{
"schemas": [],
"name": {
"givenName": "'$SP_USER_NAME'",
"familyName": "'$SP_USER_FAMILY_NAME'"
},
"userName": "lanka",
"password": "'$SP_USER_PASSWORD'",
"emails": [
{
"type": "home",
"value": "'$SP_USER_HOME_EMAIL'",
"primary": true
},
{
"type": "work",
"value": "'$SP_USER_WORK_EMAIL'"
}
],
"urn:ietf:params:scim:schemas:extension:enterprise:2.0:User": {
"employeeNumber": "1234A",
"manager": {
"value": "Taylor"
}
}
}
'
