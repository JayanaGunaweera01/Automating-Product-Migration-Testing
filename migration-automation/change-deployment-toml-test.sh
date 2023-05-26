#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
currentVersion=$1
migratingVersion=$2
database=$3
os=$4
version=$5

# Set deployment file and path based on OS
if [ "$os" = "ubuntu-latest" ]; then
    if [ "$version" = "3" ]; then
        deployment_file="$DEPLOYMENT_PATH/deployment.toml"
        deployment_path="$DEPLOYMENT_PATH"
        cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
        chmod +x env.sh
        . ./env.sh
        echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"
    elif [ "$version" = "4" ]; then
        deployment_file="$DEPLOYMENT_PATH_NEW/deployment.toml"
        deployment_path="$DEPLOYMENT_PATH_NEW"
        cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
        chmod +x env.sh
        . ./env.sh
        echo "${GREEN}==> Env file for Migrating Identity server in Ubuntu os sourced successfully${RESET}"
    fi
elif [ "$os" = "macos-latest" ]; then
    if [ "$version" = "3" ]; then
        deployment_file="$DEPLOYMENT_PATH_MAC/deployment.toml"
        deployment_path="$DEPLOYMENT_PATH_MAC"
        cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
        chmod +x env.sh
        source ./env.sh
        echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
    elif [ "$version" = "4" ]; then
        deployment_file="$DEPLOYMENT_PATH_NEW_MAC/deployment.toml"
        deployment_path="$DEPLOYMENT_PATH_NEW_MAC"
        cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
        chmod +x env.sh
        source ./env.sh
        echo "${GREEN}==> Env file for migrating Identity server in Macos sourced successfully${RESET}"
    fi
fi

# Set deployment automation file based on database and OS - Current Version
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
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_5_9"
            ;;
        "5.10.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_5_10"
            ;;
        "5.11.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_5_11"
            ;;
        "6.0.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_6_0"
            ;;
        "6.1.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_6_1"
            ;;
        "6.2.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_6_2"
            ;;
        esac
    elif [ "$os" = "macos-latest" ]; then
        case "$currentVersion" in
        "5.9.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_9"
            ;;
        "5.10.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_10"
            ;;
        "5.11.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_MAC_IS_5_11"
            ;;
        "6.0.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_0"
            ;;
        "6.1.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_1"
            ;;
        "6.2.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_2"
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

# Set deployment automation file based on database and OS - Migrating Version
if [ "$database" = "mysql" ]; then
    if [ "$os" = "ubuntu-latest" ]; then
        case "$migratingVersion" in
        "5.9.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_5_9_MIGRATION"
            ;;
        "5.10.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_5_10_MIGRATION"
            ;;
        "5.11.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_5_11_MIGRATION"
            ;;
        "6.0.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_6_0_MIGRATION"
            ;;
        "6.1.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_6_1_MIGRATION"
            ;;
        "6.2.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_UBUNTU_IS_6_2_MIGRATION"
            ;;
        esac
    elif [ "$os" = "macos-latest" ]; then
        case "$migratingVersion" in
        "5.9.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_9_MIGRATION"
            ;;
        "5.10.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_10_MIGRATION"
            ;;
        "5.11.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_5_11_MIGRATION"
            ;;
        "6.0.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_0_MIGRATION"
            ;;
        "6.1.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_1_MIGRATION"
            ;;
        "6.2.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MYSQL_MAC_IS_6_2_MIGRATION"
            ;;
        esac
    fi
elif [ "$database" = "postgres" ]; then
    if [ "$os" = "ubuntu-latest" ]; then
        case "$migratingVersion" in
        "5.9.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_5_9_MIGRATION"
            ;;
        "5.10.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_5_10_MIGRATION"
            ;;
        "5.11.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_5_11_MIGRATION"
            ;;
        "6.0.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_6_0_MIGRATION"
            ;;
        "6.1.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_6_1_MIGRATION"
            ;;
        "6.2.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_UBUNTU_IS_6_2_MIGRATION"
            ;;
        esac
    elif [ "$os" = "macos-latest" ]; then
        case "$migratingVersion" in
        "5.9.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_9_MIGRATION"
            ;;
        "5.10.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_5_10_MIGRATION"
            ;;
        "5.11.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRES_MAC_IS_5_11_MIGRATION"
            ;;
        "6.0.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_0_MIGRATION"
            ;;
        "6.1.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_1_MIGRATION"
            ;;
        "6.2.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_POSTGRE_MAC_IS_6_2_MIGRATION"
            ;;
        esac
    fi
elif [ "$database" = "mssql" ]; then
    if [ "$os" = "ubuntu-latest" ]; then
        case "$migratingVersion" in
        "5.9.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_5_9_MIGRATION"
            ;;
        "5.10.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_5_10_MIGRATION"
            ;;
        "5.11.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_5_11_MIGRATION"
            ;;
        "6.0.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_6_0_MIGRATION"
            ;;
        "6.1.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_6_1_MIGRATION"
            ;;
        "6.2.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_UBUNTU_IS_6_2_MIGRATION"
            ;;
        esac
    elif [ "$os" = "macos-latest" ]; then
        case "$migratingVersion" in
        "5.9.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_9_MIGRATION"
            ;;
        "5.10.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_10_MIGRATION"
            ;;
        "5.11.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_5_11_MIGRATION"
            ;;
        "6.0.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_0_MIGRATION"
            ;;
        "6.1.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_1_MIGRATION"
            ;;
        "6.2.0")
            deployment_automation_file="$DEPLOYMENT_AUTOMATION_MSSQL_MAC_IS_6_2_MIGRATION"
            ;;
        esac
    fi
fi

# Replace deployment file if deployment automation file exists
if [ -n "$deployment_automation_file" ]; then
    chmod +x "$deployment_automation_file"
    # Check if migratingVersion is in the specified list
    if [ "$migratingVersion" = "5.11.0" || "$migratingVersion" = "6.0.0" || "$migratingVersion" == "6.1.0" || "$migratingVersion" = "6.2.0" ]; then
        # Generate the secret key
        secret_key=$(openssl rand -hex 32)
        echo "${GREEN}==> Secret key is $secret_key${RESET}"

        # Replace the placeholder with the generated secret key
        sed -i "s/<provide-your-key-here>/$secret_key/g" "$deployment_path"
        echo "${GREEN}==> Secret key generated and replaced in deployment.toml${RESET}"
    fi
    # Display the content of the deployment automation file in the terminal
    echo "Content of deployment automation file:"
    cat "$deployment_automation_file"

    find "$deployment_path" -type f -name 'deployment.toml' -exec sh -c "cat '$deployment_automation_file' > '{}'" \;
    echo "${GREEN}==> Did needed changes of deployment toml file to configure \"$database\" database successfully.${RESET}"
fi
