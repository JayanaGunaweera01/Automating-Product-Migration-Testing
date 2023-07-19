#!/bin/bash

set -euo pipefail

base64url() {
    echo -n "$1" | base64 | tr -d '\n' | tr '+/' '-_' | tr -d '='
}

key_json_file="/home/runner/work/getAccessToken/getAccessToken/migration-automation/pure-object-391312-cca370803582.json"
scope="https://www.googleapis.com/auth/drive.readonly"
valid_for_sec="${3:-3600}"
valid_for_sec_numeric=$(echo "$valid_for_sec" | tr -d -c '[:digit:]')
private_key=$(jq -r .private_key "$key_json_file")
sa_email=$(jq -r .client_email "$key_json_file") || { echo "Error extracting client_email from the JSON file."; exit 1; }
echo "Private Key: $private_key"
echo "Service Account Email: $sa_email"

header='{"alg":"RS256","typ":"JWT"}'
claim=$(cat <<EOF | jq -c
  {
    "iss": "$sa_email",
    "scope": "$scope",
    "aud": "https://www.googleapis.com/oauth2/v4/token",
    "exp": $(($(date +%s) + $valid_for_sec_numeric)),
    "iat": $(date +%s)
  }
EOF
)

request_body=$(base64url "$header").$(base64url "$claim")
signature=$(echo -n "$request_body" | openssl dgst -sha256 -sign <(echo "$private_key") -binary | base64url)
jwt_token=$(printf "%s.%s\n" "$request_body" "$signature")

echo "JWT Token: $jwt_token"

# Make the token request to get the access token
token_response=$(curl -s -X POST https://www.googleapis.com/oauth2/v4/token \
    --data-urlencode "grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer" \
    --data-urlencode "assertion=$jwt_token")

# Check for HTTP 400 errors in the response
if [[ $token_response == *"HTTP/2 400"* ]]; then
    echo "HTTP 400 Error: Invalid request or bad syntax."
    echo "$token_response"
    exit 1
fi

# Extract the access token from the response
access_token=$(echo "$token_response" | jq -r .access_token)

# Check if the access token is null or empty
if [ -z "$access_token" ]; then
    echo "Error: Access token is null or empty."
    echo "$token_response"
    exit 1
fi

echo "Access Token: $access_token"
