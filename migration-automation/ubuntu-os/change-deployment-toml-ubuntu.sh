#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
currentVersion=$1
database=$2
os=$3

#!/bin/bash

# Set deployment file and path based on OS
if [ "$os" = "ubuntu-latest" ]; then
    deployment_file="$DEPLOYMENT_PATH/deployment.toml"
    deployment_path="$DEPLOYMENT_PATH"
    cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
    chmod +x env.sh
    source ./env.sh
    echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"
elif [ "$os" = "macos-latest" ]; then
    deployment_file="$DEPLOYMENT_PATH_MAC/deployment.toml"
    deployment_path="$DEPLOYMENT_PATH_MAC"
    cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
    source ./env.sh
    echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
fi

# Set deployment automation file based on database and OS
case "$currentVersion" in
    "5.9.0")
        if [ "$database" = "mysql" ] && [ "$os" = "ubuntu-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_UBUNTU_IS_5_9"
        elif [ "$database" = "mysql" ] && [ "$os" = "macos-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_MAC_IS_5_9"
        fi
        ;;
    "5.10.0")
        if [ "$database" = "mysql" ] && [ "$os" = "ubuntu-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_UBUNTU_IS_5_10"
        elif [ "$database" = "mysql" ] && [ "$os" = "macos-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_MAC_IS_5_10"
        fi
        ;;
    "5.11.0")
        if [ "$database" = "mysql" ] && [ "$os" = "ubuntu-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_UBUNTU_IS_5_11"
        elif [ "$database" = "mysql" ] && [ "$os" = "macos-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_MAC_IS_5_11"
        fi
        ;;
    "6.0.0")
        if [ "$database" = "mysql" ] && [ "$os" = "ubuntu-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_UBUNTU_IS_6_0"
        elif [ "$database" = "mysql" ] && [ "$os" = "macos-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_MAC_IS_6_0"
        fi
        ;;
    "6.1.0")
        if [ "$database" = "mysql" ] && [ "$os" = "ubuntu-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_UBUNTU_IS_6_1"
        elif [ "$database" = "mysql" ] && [ "$os" = "macos-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_MAC_IS_6_1"
        fi
        ;;
    "6.2.0")
        if [ "$database" = "mysql" ] && [ "$os" = "ubuntu-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_UBUNTU_IS_6_2"
        elif [ "$database" = "mysql" ] && [ "$os" = "macos-latest" ]; then
            deployment_automation_file="${DEPLOYMENT_AUTOMATION_PATH}/MYSQL_MAC_IS_6_2"
        fi
        ;;
esac

# Replace deployment file if automation file is available
if [ -n "$deployment_automation_file" ]; then
    find "$deployment_path" -type f -name 'deployment.toml' -exec sh -c "cat '$deployment_automation_file' > '{}'" \;
    echo "Deployment file for $currentVersion replaced successfully."
fi
