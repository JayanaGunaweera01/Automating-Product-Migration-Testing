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

    if [ "$database" = "mysql" ] && [ "$os" = "ubuntu-latest" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat "$DEPLOYMENT_AUTOMATION_MYSQL_IS_${cat_file}" > "$DEPLOYMENT_PATH"
        echo "Content in 'DEPLOYMENT_AUTOMATION_MYSQL_IS_${cat_file}' catenated to 'DEPLOYMENT_AUTOMATION'."
    elif [ "$database" = "mssql" ] && [ "$os" = "ubuntu-latest" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat "$DEPLOYMENT_AUTOMATION_MSSQL_IS_${cat_file}" > "$DEPLOYMENT_PATH"
        echo "Content in 'DEPLOYMENT_AUTOMATION_MSSQL_IS_${cat_file}' catenated to 'DEPLOYMENT_AUTOMATION'."
    elif [ "$database" = "postgres" ] && [ "$os" = "ubuntu-latest" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat "$DEPLOYMENT_AUTOMATION_POSTGRE_IS_${cat_file}" > "$DEPLOYMENT_PATH"
        echo "Content in 'DEPLOYMENT_AUTOMATION_POSTGRE_IS_${cat_file}' catenated to 'DEPLOYMENT_AUTOMATION'."
    fi
}

# Perform cat operation based on conditions
perform_cat "5.9.0"
perform_cat "5.10.0"
perform_cat "5.11.0"
perform_cat "6.0.0"
perform_cat "6.1.0"
perform_cat "6.2.0"