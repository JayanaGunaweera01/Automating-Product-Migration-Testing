#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m' # reset color

# Get the value of the inputs
currentVersion=$3
database=$5
os=$6

# Source env file
chmod +x env.sh
. ./env.sh
echo "==> ${GREEN}Env file sourced successfully${RESET}"

# Function to perform cat operation based on conditions
perform_cat() {
    cat_file=$1
    deployment_file=$2

    if [ "$database" = "mysql" ] && [ "$os" = "ubuntu" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat "$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_${cat_file}" > "$deployment_file"
    elif [ "$database" = "mssql" ] && [ "$os" = "ubuntu" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat "$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_${cat_file}" > "$deployment_file"
    elif [ "$database" = "postgres" ] && [ "$os" = "ubuntu" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat "$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_${cat_file}" > "$deployment_file"
    fi
}

# Iterate over deployment files
find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml' | while read -r file; do
    perform_cat "5.9" "$file"
    perform_cat "5.10" "$file"
    perform_cat "5.11" "$file"
    perform_cat "6.0" "$file"
    perform_cat "6.1" "$file"
    perform_cat "6.2" "$file"
done

