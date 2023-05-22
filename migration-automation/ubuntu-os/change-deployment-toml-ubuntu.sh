#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
currentVersion=$1
database=$2
os=$3

version1="5.9.0"
version2="5.10.0"
version3="5.11.0"
version4="6.0.0"
version5="6.1.0"
version6="6.2.0"

if [ "$os" = "ubuntu-latest" ]; then
    deployment_file="$DEPLOYMENT_PATH/deployment.toml"

    # Source env file Ubuntu
    cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
    chmod +x env.sh
    . ./env.sh
    echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"

elif [ "$os" = "macos-latest" ]; then
    deployment_file="$DEPLOYMENT_PATH_MAC/deployment.toml"

    # Source env file Mac
    cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
    source ./env.sh
    echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
fi


if [[ "$database" == "mysql" && "$os" == "ubuntu-latest" ]]; then
    case "$currentVersion" in
        "5.9.0" | "5.10.0" | "5.11.0" | "6.0.0" | "6.1.0" | "6.2.0")
            deployment_file="$DEPLOYMENT_PATH/deployment.toml"
            automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_$currentVersion"
            
            if [[ -f "$automation_file" ]]; then
                find "$deployment_file" -type f -name 'deployment.toml' -exec sh -c "cat '$automation_file' > {}" \;
                echo "Deployment file for $currentVersion replaced successfully."
            else
                echo "Deployment automation file not found for version $currentVersion."
            fi
            ;;
        *)
            echo "Deployment file for version $currentVersion not supported."
            ;;
    esac
fi

if [[ "$database" == "mssql" && "$os" == "ubuntu-latest" ]]; then
    case "$currentVersion" in
        "5.9.0" | "5.10.0" | "5.11.0" | "6.0.0" | "6.1.0" | "6.2.0")
            deployment_file="$DEPLOYMENT_PATH/deployment.toml"
            automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_$currentVersion"
            
            if [[ -f "$automation_file" ]]; then
                find "$deployment_file" -type f -name 'deployment.toml' -exec sh -c "cat '$automation_file' > {}" \;
                echo "Deployment file for $currentVersion replaced successfully."
            else
                echo "Deployment automation file not found for version $currentVersion."
            fi
            ;;
        *)
            echo "Deployment file for version $currentVersion not supported."
            ;;
    esac
fi