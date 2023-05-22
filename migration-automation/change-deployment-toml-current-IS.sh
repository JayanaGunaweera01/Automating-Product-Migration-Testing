#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
currentVersion=$1
database=$2
os=$3

# Set deployment file and path based on OS
if [ "$os" = "ubuntu-latest" ]; then
    deployment_file="$DEPLOYMENT_PATH/deployment.toml"
    deployment_path="$DEPLOYMENT_PATH"
    cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
   chmod +x env.sh
   . ./env.sh
    echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"
elif [ "$os" = "macos-latest" ]; then
    deployment_file="$DEPLOYMENT_PATH_MAC/deployment.toml"
    deployment_path="$DEPLOYMENT_PATH_MAC"
    cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
    chmod +x env.sh
    source ./env.sh
    echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
fi

# Set deployment automation file based on database and OS
if [ "$database" = "mysql" ]; then
    if [ "$os" = "ubuntu-latest" ]; then
        case "$currentVersion" in
            "5.9.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_5_9"
                ;;
            "5.10.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_5_10"
                ;;
            "5.11.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_5_11"
                ;;
            "6.0.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_6_0"
                ;;
            "6.1.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_6_1"
                ;;
            "6.2.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_6_2"
                ;;
        esac
    elif [ "$os" = "macos-latest" ]; then
        case "$currentVersion" in
            "5.9.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_9"
                ;;
            "5.10.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_10"
                ;;
            "5.11.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_11"
                ;;
            "6.0.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_0"
                ;;
            "6.1.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_1"
                ;;
            "6.2.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_2"
                ;;
        esac
    fi
elif [ "$database" = "postgres" ]; then
    if [ "$os" = "ubuntu-latest" ]; then
        case "$currentVersion" in
            "5.9.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_UBUNTU_IS_5_9"
                ;;
            "5.10.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_UBUNTU_IS_5_10"
                ;;
            "5.11.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_UBUNTU_IS_5_11"
                ;;
            "6.0.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_UBUNTU_IS_6_0"
                ;;
            "6.1.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_UBUNTU_IS_6_1"
                ;;
            "6.2.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_UBUNTU_IS_6_2"
                ;;
        esac
    elif [ "$os" = "macos-latest" ]; then
        case "$currentVersion" in
            "5.9.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_MAC_IS_5_9"
                ;;
            "5.10.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_MAC_IS_5_10"
                ;;
            "5.11.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_MAC_IS_5_11"
                ;;
            "6.0.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_MAC_IS_6_0"
                ;;
            "6.1.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_MAC_IS_6_1"
                ;;
            "6.2.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_MAC_IS_6_2"
                ;;
        esac
    fi
elif [ "$database" = "mssql" ]; then
    if [ "$os" = "ubuntu-latest" ]; then
        case "$currentVersion" in
            "5.9.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_5_9"
                ;;
            "5.10.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_5_10"
                ;;
            "5.11.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_5_11"
                ;;
            "6.0.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_6_0"
                ;;
            "6.1.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_6_1"
                ;;
            "6.2.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_6_2"
                ;;
        esac
    elif [ "$os" = "macos-latest" ]; then
        case "$currentVersion" in
            "5.9.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_9"
                ;;
            "5.10.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_10"
                ;;
            "5.11.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_11"
                ;;
            "6.0.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_0"
                ;;
            "6.1.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_1"
                ;;
            "6.2.0")
                deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_2"
                ;;
        esac
    fi
fi

# Replace deployment file if deployment automation file exists
if [ -n "$deployment_automation_file" ]; then
    find "$deployment_path" -type f -name 'deployment.toml' -exec sh -c "cat '$deployment_automation_file' > '{}'" \;
    echo "${GREEN}==> Did needed changes of deployment toml file of IS version "$1" relevant to "$2" database successfully.${RESET}"
fi
