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

if [[ "$os" == "ubuntu-latest" ]]; then
    deployment_file="$DEPLOYMENT_PATH/deployment.toml"

    # Source env file Ubuntu
    cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
    chmod +x env.sh
    . ./env.sh
    echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"

elif [[ "$os" == "macos-latest" ]]; then
    deployment_file="$DEPLOYMENT_PATH_MAC/deployment.toml"

    # Source env file Mac
    cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
    source ./env.sh
    echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
fi

replace_deployment_file() {
    local automation_file="$1"

    if [[ -f "$automation_file" ]]; then
        cp "$automation_file" "$deployment_file"
        echo "${GREEN}==> Deployment toml file for WSO2 IS $currentVersion and $database database replaced successfully.${RESET}"
    else
        echo "${GREEN}==> Deployment toml file not found for WSO2 IS $currentVersion and $database database.${RESET}"
    fi
}

if [[ "$os" == "ubuntu-latest" || "$os" == "macos-latest" ]]; then
    if [[ "$database" == "mysql" || "$database" == "mssql" || "$database" == "postgres" ]]; then
        case "$currentVersion" in
            $version1|$version2|$version3|$version4|$version5|$version6)
                version_with_underscores="${currentVersion//./_}"
                version_major_minor="${version_with_underscores%_*}"
                automation_file="$DEPLOYMENT_AUTOMATION_${database^^}_${os^^}_IS_$version_major_minor"
                replace_deployment_file "$automation_file"
                ;;
        esac
    fi
fi
