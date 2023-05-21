#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

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
    cat_variable=$2
    deployment_file=$3

    if [ "$database" = "mysql" ] && [ "$os" = "ubuntu-latest" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat_variable_value=$(eval echo "\$DEPLOYMENT_AUTOMATION_MYSQL_IS_${cat_variable}")
        echo "$cat_variable_value" > "$deployment_file"
        echo "Deployment file '$deployment_file' replaced."
    elif [ "$database" = "mssql" ] && [ "$os" = "ubuntu-latest" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat_variable_value=$(eval echo "\$DEPLOYMENT_AUTOMATION_MSSQL_IS_${cat_variable}")
        echo "$cat_variable_value" > "$deployment_file"
        echo "Deployment file '$deployment_file' replaced."
    elif [ "$database" = "postgres" ] && [ "$os" = "ubuntu-latest" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat_variable_value=$(eval echo "\$DEPLOYMENT_AUTOMATION_POSTGRE_IS_${cat_variable}")
        echo "$cat_variable_value" > "$deployment_file"
        echo "Deployment file '$deployment_file' replaced."
    fi
}

# Iterate over deployment files
find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml' | while IFS= read -r file; do
    perform_cat "5.9.0" "5_9" "$file"
    perform_cat "5.10.0" "5_10" "$file"
    perform_cat "5.11.0" "5_11" "$file"
    perform_cat "6.0.0" "6_0" "$file"
    perform_cat "6.1.0" "6_1" "$file"
    perform_cat "6.2.0" "6_2" "$file"
done