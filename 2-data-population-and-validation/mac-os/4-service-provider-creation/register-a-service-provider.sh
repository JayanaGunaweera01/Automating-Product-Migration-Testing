#!/bin/bash

curl --location --request POST 'https://localhost:9443/api/identity/oauth2/dcr/v1.1/register' \
--header 'Authorization: Basic YWRtaW46YWRtaW4=' \
--header 'Content-Type: application/json' \
--data-raw '{  "client_name": "test migration app", "grant_types": ["authorization_code","implicit","password","client_credentials","refresh_token"], "redirect_uris":["http://localhost:8080/playground2"] }'
echo "Registered a service provider successfully!"
