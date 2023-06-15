#!/bin/bash

MIGRATION_PAT=$1

# Source the script to set the environment variables
source <(curl -sSL https://raw.githubusercontent.com/wso2-extensions/identity-migration-resources/1.0.225/release-info.sh)

github_tag_url=$(curl -s -S -H "Authorization: token $MIGRATION_PAT" -H "Accept: application/json, application/vnd.github.v3+json" \
  "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/releases?per_page=100&draft=false" |
  jq -r '.url')
echo "Discovered the github_tag_url: ${github_tag_url}"

github_tag_id=$(curl -s -S -H "Authorization: token $MIGRATION_PAT" -H "Accept: application/json, application/vnd.github.v3+json" \
  "$github_tag_url" |
  jq --raw-output "first(.[] | select(.tag_name==\"v$TAG\")).id")
echo "Discovered the tag_id: ${github_tag_id}"
echo "Creating the download link..."

# Get the download URL of the desired asset
download_url=$(curl -s -S -H "Authorization: token $MIGRATION_PAT" -H "Accept: application/json, application/vnd.github.v3+json" \
  -L -X GET \
  "https://api.github.com/repos/$GITHUB_REPO_OWNER/$GITHUB_REPO_NAME/releases/$github_tag_id" |
  jq --raw-output ".assets[] | select(.name==\"${ASSET_FILE_NAME_WITH_EXT}\").url")
echo "Found resource download URL: $download_url"
echo "Discovering the S3 bucket URL for the resource..."

redirect_url=$(curl -s -S -H "Accept: application/octet-stream" -H "Authorization: token $MIGRATION_PAT" -I "$download_url" |
  awk '/^Location: /{gsub(/^Location: /,""); print}')
echo "Download is starting now..."

# Finally, download the actual binary
curl -LJO -s -S -o "./utils/migration-client" -X GET "$redirect_url"
echo "Binary $ASSET_FILE_NAME_WITH_EXT download is completed."

curl -O -s -S "$ASSET_FILE_NAME_WITH_EXT"
wait $!
echo "Unzipped downloaded migration client"
ls -a


