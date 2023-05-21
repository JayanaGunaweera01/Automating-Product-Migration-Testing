#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Source env file
ENV_FILE_PATH="/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh"
if [[ "$OSTYPE" == "darwin"* ]]; then
    ENV_FILE_PATH="./env.sh"
fi

# Function to replace deployment file
replace_deployment_file() {
    local version=$1
    local file_path=$2
    local deployment_file=$3

    for file in $(find "$file_path" -type f -name 'deployment.toml'); do
        cat "$deployment_file" >"$file"
    done

    echo "Deployment file for $version replaced successfully."
}

# Source env file
chmod +x "$ENV_FILE_PATH"
source "$ENV_FILE_PATH"
echo -e "${GREEN}==> Env file sourced successfully${RESET}"

# Associative array to store deployment file paths
declare -A deployment_files

# MySQL deployment files
deployment_files["mysql_mac_5.9.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_9
deployment_files["mysql_mac_5.10.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_10
deployment_files["mysql_mac_5.11.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_11
deployment_files["mysql_mac_6.0.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_0
deployment_files["mysql_mac_6.1.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_1
deployment_files["mysql_mac_6.2.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_2

# MSSQL deployment files
deployment_files["mssql_mac_5.9.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_9
deployment_files["mssql_mac_5.10.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_10
deployment_files["mssql_mac_5.11.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_11
deployment_files["mssql_mac_6.0.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_0
deployment_files["mssql_mac_6.1.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_1
deployment_files["mssql_mac_6.2.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_2

# Postgres deployment files
deployment_files["postgres_mac_5.9.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_9
deployment_files["postgres_mac_5.10.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_10
deployment_files["postgres_mac_5.11.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_11
deployment_files["postgres_mac_6.0.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_0
deployment_files["postgres_mac_6.1.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_1
deployment_files["postgres_mac_6.2.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_2

# MySQL deployment files
deployment_files["mysql_mac_5.9.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_9
deployment_files["mysql_mac_5.10.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_10
deployment_files["mysql_mac_5.11.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_11
deployment_files["mysql_mac_6.0.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_0
deployment_files["mysql_mac_6.1.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_1
deployment_files["mysql_mac_6.2.0"]=$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_2

# MSSQL deployment files
deployment_files["mssql_mac_5.9.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_9
deployment_files["mssql_mac_5.10.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_10
deployment_files["mssql_mac_5.11.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_11
deployment_files["mssql_mac_6.0.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_0
deployment_files["mssql_mac_6.1.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_1
deployment_files["mssql_mac_6.2.0"]=$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_2

# Postgres deployment files
deployment_files["postgres_mac_5.9.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_9
deployment_files["postgres_mac_5.10.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_10
deployment_files["postgres_mac_5.11.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_11
deployment_files["postgres_mac_6.0.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_0
deployment_files["postgres_mac_6.1.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_1
deployment_files["postgres_mac_6.2.0"]=$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_2

# Function to handle deployment based on database, OS, and version
handle_deployment() {
    local database=$1
    local os=$2
    local version=$3

    local deployment_file=${deployment_files["$database"_"$os"_"$version"]}

    if [ -n "$deployment_file" ]; then
        echo "Replacing deployment file for $database $os $version..."
        replace_deployment_file "$version" "$DEPLOYMENT_PATH" "$deployment_file"
    else
        echo "Deployment file not found for $database $os $version."
    fi
}

# Handle deployment for MySQL on Ubuntu
if [ "$database" = "mysql" ] && [ "$os" = "ubuntu-latest" ]; then
    echo "Handling deployment for MySQL on Ubuntu..."
    handle_deployment "$database" "$os" "$currentVersion"
fi

# Handle deployment for MSSQL on Ubuntu
if [ "$database" = "mssql" ] && [ "$os" = "ubuntu-latest" ]; then
    echo "Handling deployment for MSSQL on Ubuntu..."
    handle_deployment "$database" "$os" "$currentVersion"
fi

# Handle deployment for Postgres on Ubuntu
if [ "$database" = "postgres" ] && [ "$os" = "ubuntu-latest" ]; then
    echo "Handling deployment for Postgres on Ubuntu..."
    handle_deployment "$database" "$os" "$currentVersion"
fi

# Handle deployment for MySQL on macOS
if [ "$database" = "mysql" ] && [ "$os" = "macos-latest" ]; then
    echo "Handling deployment for MySQL on macOS..."
    handle_deployment "$database" "$os" "$currentVersion"
fi

# Handle deployment for MSSQL on macOS
if [ "$database" = "mssql" ] && [ "$os" = "macos-latest" ]; then
    echo "Handling deployment for MSSQL on macOS..."
    handle_deployment "$database" "$os" "$currentVersion"
fi

# Handle deployment for Postgres on macOS
if [ "$database" = "postgres" ] && [ "$os" = "macos-latest" ]; then
    echo "Handling deployment for Postgres on macOS..."
    handle_deployment "$database" "$os" "$currentVersion"
fi

echo "Deployment completed."
