#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Source env file
cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
chmod +x env.sh
. ./env.sh
echo "${GREEN}==> Env file sourced successfully${RESET}"

# Source env file
cd /Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation
source ./env.sh
echo "\033[0;32m\033[1mEnv file sourced successfully\033[0;m"

if $5  = "mysql" && $6 = "ubuntu-latest"; then
    if [ $3 = "5.9.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_5_9" >"$file"
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.10.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_5_10" >"$file"
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif $3 = "5.11.0"; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_5_11" >"$file"
            echo "Deployment file for $3 replaced successfully."
        done
    elif [ "$currentVersion" = "6.0.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_6_0" >"$file"
        done
    elif [ "$currentVersion" = "6.1.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_6_1" >"$file"
        done
    elif [ "$currentVersion" = "6.2.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_6_2" >"$file"
        done
    fi
fi

if [ "$database" = "mssql" ] && [ "$os" = "ubuntu-latest" ]; then
    if [ "$currentVersion" = "5.9.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_5_9" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.10.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_5_10" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.11.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_5_11" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    elif [ "$currentVersion" = "6.0.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_6_0" >"$file"
        done
    elif [ "$currentVersion" = "6.1.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_6_1" >"$file"
        done
    elif [ "$currentVersion" = "6.2.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_6_2" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    fi
fi

if [ "$database" = "postgres" ] && [ "$os" = "ubuntu-latest" ]; then
    if [ "$currentVersion" = "5.9.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_5_9" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.10.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_5_10" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.11.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_5_11" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    elif [ "$currentVersion" = "6.0.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_6_0" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    elif [ "$currentVersion" = "6.1.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_6_1" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    elif [ "$currentVersion" = "6.2.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_6_2" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    fi
fi

if [ "$database" = "mysql" ] && [ "$os" = "macos-latest" ]; then
    if [ "$currentVersion" = "5.9.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_9" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.10.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_10" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.11.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_11" >"$file"
        done
    elif [ "$currentVersion" = "6.0.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_0" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    elif [ "$currentVersion" = "6.1.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_1" >"$file"
        done
    elif [ "$currentVersion" = "6.2.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_2" >"$file"
        done
    fi
fi

if [ "$database" = "mssql" ] && [ "$os" = "macos-latest" ]; then
    if [ "$currentVersion" = "5.9.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_9" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.10.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_10" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.11.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_11" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    elif [ "$currentVersion" = "6.0.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_0" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    elif [ "$currentVersion" = "6.1.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_1" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    elif [ "$currentVersion" = "6.2.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_2" >"$file"
            echo "Deployment file for $currentVersion replaced successfully."
        done
    fi
fi
if [ "$database" = "postgres" ] && [ "$os" = "macos-latest" ]; then
    if [ "$currentVersion" = "5.9.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_9" >"$file"
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.10.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_10" >"$file"
        done
        echo "Deployment file for $currentVersion replaced successfully."
    elif [ "$currentVersion" = "5.11.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_11" >"$file"
        done
    elif [ "$currentVersion" = "6.0.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_0" >"$file"
        done
    elif [ "$currentVersion" = "6.1.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_1" >"$file"
        done
    elif [ "$currentVersion" = "6.2.0" ]; then
        for file in $(find "$DEPLOYMENT_PATH" -type f -name 'deployment.toml'); do
            cat "$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_2" >"$file"
        done
    fi
fi