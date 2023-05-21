#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
currentVersion=$3
database=$5
os=$6

# Source env file
cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
chmod +x env.sh
. ./env.sh
echo "${GREEN}==> Env file sourced successfully${RESET}"

# Function to perform cat operation based on conditions
perform_cat() {
    cat_file=$1
    deployment_file=$2

    if [ "$database" = "mysql" ] && [ "$os" = "ubuntu" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat "$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_${cat_file}" >"$deployment_file"
        echo "Deployment file '$deployment_file' replaced."
    elif [ "$database" = "mssql" ] && [ "$os" = "ubuntu" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat "$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_${cat_file}" >"$deployment_file"
        echo "Deployment file '$deployment_file' replaced."
    elif [ "$database" = "postgres" ] && [ "$os" = "ubuntu" ] && [ "$currentVersion" = "$cat_file" ]; then
        cat "$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_${cat_file}" >"$deployment_file"
        echo "Deployment file '$deployment_file' replaced."
    fi
}

# Iterate over deployment files
find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml' -exec bash -c '
    source "$1"
    shift

    for file do
        perform_cat "5_9" "$file"
        perform_cat "5_10" "$file"
        perform_cat "5_11" "$file"
        perform_cat "6_0" "$file"
        perform_cat "6_1" "$file"
        perform_cat "6_2" "$file"
    done
' bash "$sourceFile" {} +


