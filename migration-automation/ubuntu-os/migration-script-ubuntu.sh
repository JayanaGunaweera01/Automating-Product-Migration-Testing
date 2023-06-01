#!/bin/bash

# THIS IS THE SHELL SCRIPT FOR LINUX (UBUNTU) - MYSQL/MSSQL/POSTGRE MIGRATIONS INSIDE GITHUB ACTIONS - [POC]

# Define color variables
CYAN='\033[0;36m\033[1m'   # cyan color
GREEN='\033[0;32m\033[1m'  # green color
BLUE='\033[0;34m\033[1m'   # blue color
YELLOW='\033[0;33m\033[1m' # yellow color
ORANGE='\033[0;91m\033[1m' # orange color
RED='\033[0;31m\033[1m'    # red color
RESET='\033[0m'            # reset color

# Update the system before downloading packages
sudo apt-get -qq update

cd "$AUTOMATION_HOME"
cd migration-automation

# Get the value of the "currentVersion" and "migratingVersion" inputs
currentVersion=$3
migratingVersion=$4

# Remove spaces from the beginning and end of the currentVersion variable
currentVersion=$(echo $currentVersion | xargs)

# Combine "wso2is-" and the value of the "currentVersion" input, without spaces
combinedCurrentVersion="wso2is-${currentVersion}"

# Replace all instances of "CurrentVersion" with the combined version value
sed -i "s/CurrentVersion/${combinedCurrentVersion}/g" /home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh

# Remove spaces from the beginning and end of the migratingVersion variable
migratingVersion=$(echo $migratingVersion | xargs)

# Combine "wso2is-" and the value of the "currentVersion" input, without spaces
combinedMigratingVersion="wso2is-${migratingVersion}"

# Replace all instances of "MigratingVersion" with the value of the "migratingVersion" input, without spaces
sed -i "s/MigratingVersion/${combinedMigratingVersion}/g" /home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/env.sh

# Define the message in a variable for easier modification
echo
echo "${ORANGE}WELCOME TO AUTOMATING PRODUCT MIGRATION TESTING! THIS TIME WE WILL PERFORM A MIGRATION TESTING FROM IS VERSION ${RESET}${YELLOW}$3${RESET}${ORANGE} TO IS VERSION ${RESET}${YELLOW}$4${RESET}${ORANGE} IN THE ${RESET}${YELLOW}$5${RESET}${ORANGE} DATABASE, RUNNING ON THE ${RESET}${YELLOW}$6${RESET}${ORANGE} OPERATING SYSTEM.${RESET}"

# Print instructions with different colors and formatting using echo command
echo "${ORANGE}${RESET} ${CYAN}1. PRIOR TO PROCEEDING, ENSURE THAT YOU HAVE MADE THE NECESSARY MODIFICATIONS IN THE env.sh FILE TO ALIGN WITH YOUR REQUIREMENTS.${RESET} ${ORANGE}${RESET}"
echo "${ORANGE}${RESET} ${CYAN}2. IF YOU REQUIRE THE INCLUSION OF ADDITIONAL FEATURES, SUCH AS DATA POPULATION OR VERIFICATION, PLEASE INCORPORATE THEM WITHIN THE APPROPRIATE DIRECTORY NAMED data-population-and-validation.${RESET} ${ORANGE}${RESET}"
echo "${ORANGE}${RESET} ${CYAN}3. DOUBLE-CHECK THE CONTENTS OF THE deployment.toml FILES IN THE deployment-tomls FOLDER TO ENSURE THAT IT CORRESPONDS TO YOUR SPECIFIC DATABASE CONFIGURATIONS.${RESET} ${ORANGE}${RESET}"
echo

# Print welcome message in terminal
echo "${ORANGE}"PROCESS STARTED!"${RESET}"

# Source env file
cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
chmod +x env.sh
. ./env.sh
echo "${GREEN}==> Env file sourced successfully${RESET}"

# Setup Java
sudo apt-get install -y openjdk-11-jdk &
wait $!
echo "${GREEN}==> Installed Java successfully!${RESET}"

# Set the JAVA_HOME environment variable
export JAVA_HOME=$(readlink -f $(which java)) &
wait $!

cd "$AUTOMATION_HOME"

# Create directory for placing wso2IS
mkdir IS_HOME_OLD
echo "${GREEN}==> Created a directory to place wso2IS${RESET}"

# Navigate to folder
cd IS_HOME_OLD
echo "${GREEN}==> Navigated to home folder successfully${RESET}"

# Download needed wso2IS zip
wget -qq --waitretry=5 --retry-connrefused $1
ls -a
echo "${GREEN}==> Downloaded needed wso2IS zip${RESET}"

# Unzip IS archive
unzip -qq *.zip &
wait
echo "${GREEN}==> Unzipped downloaded Identity Server zip${RESET}"

cd "$AUTOMATION_HOME"

# Given read write access to deployment.toml
chmod +x "$DEPLOYMENT"
echo "${GREEN}==> Given read write access to deployment.toml${RESET}"

cd "$AUTOMATION_HOME"

# Needed changes in deployment.toml
chmod +x change-deployment-toml.sh
sh change-deployment-toml.sh "$3" "$4" "$5" "$6" 3
echo "${GREEN}==> Deployment.toml changed successfully${RESET}"

# Check if database is set to mysql
if [ "$5" = "mysql" ]; then
    # Setup mysql
    cd "$UBUNTU_HOME"
    chmod +x setup-mysql-ubuntu.sh
    sh setup-mysql-ubuntu.sh "$3"

else
    echo "${GREEN}==> Skipping the MySQL setup process since the selected database is $5 ${RESET}"
fi

cd "$AUTOMATION_HOME"

# Copy Jars
chmod +x copy-jar-file.sh
sh copy-jar-file.sh "$5" "$6"

cd "$AUTOMATION_HOME"

# Start wso2IS
echo "${GREEN}==> Identity server $3 started running!${RESET}"

# Starting downloaded identity server
chmod +x start-server.sh
sh start-server.sh "$6" "3" $3 $4

cd "$AUTOMATION_HOME"

# Run the .sh script to enter login credentials(admin) and divert to management console home page
sh enter-login-credentials.sh &
wait $!
echo "${GREEN}==> Entered to Management console home page successfully${RESET}"

cd "$DATA_POPULATION"
echo "${GREEN}==> Entered the data population directory successfully.${RESET}"

# Run data-population-script.sh which is capable of populating data to create users,tenants,userstores,generate tokens etc.
chmod +x automated-data-population-and-validation-script.sh
sh automated-data-population-and-validation-script.sh
wait $!
echo "${GREEN}==> Created users, user stores, service providers, tenants, generated oAuth tokens and executed the script successfully${RESET}"

cd "$AUTOMATION_HOME"
echo "${GREEN}==> Directed to home successfully${RESET}"

# Stop wso2IS
chmod +x stop-server.sh
sh stop-server.sh "$6" "3"
echo

cd "$AUTOMATION_HOME"
echo "${GREEN}==> Directed to home successfully${RESET}"

# Create directory for placing latest wso2IS (IS to migrate)
mkdir IS_HOME_NEW
echo "${GREEN}==> Created a directory for placing latest wso2IS${RESET}"

# Navigate to folder
cd "$IS_HOME_NEW"

# Download needed (latest) wso2IS zip
wget -qq --waitretry=5 --retry-connrefused ${2}
wait $!
ls -a
echo "${GREEN}==> Downloaded $4 zip${RESET}"

# Unzip IS archive
unzip -qq *.zip &
wait $!
echo "${GREEN}==> Unzipped $4 zip${RESET}"

# Divert to utils folder
cd "$UTILS"
echo "${GREEN}==> Diverted to utils folder${RESET}"

# Download migration client
# wget -qq "$LINK_TO_MIGRATION_CLIENT" &
# wait $!
# ls -a
# echo "${GREEN}==> Downloaded migration client successfully!${RESET}"

# Unzip migration client archive
migration_archive=$(find . -type f -name 'wso2is-migration-*.zip' -print -quit)
if [ -n "$migration_archive" ]; then
    unzip -qq "$migration_archive" &
    wait $!
    ls -a
    echo "${GREEN}==> Unzipped migration client archive${RESET}"
else
    echo "${RED}==> Migration client archive not found!${RESET}"
fi

# Navigate to dropins folder
cd "$DROPINS_PATH_HOME"

# Copy droipns folder to wso2IS (latest) dropins folder
cp -r "$DROPINS_PATH" "$COMPONENTS_PATH" &
cp_pid=$!

wait $cp_pid
echo "${GREEN}==> Jar files from migration client have been copied to IS_HOME_NEW/repository/components/dropins folder successfully!${RESET}"

# Copy migration resources folder to wso2IS (latest) root folder
cp -r "$MIGRATION_RESOURCES" "$IS_NEW_ROOT" &
cp_pid=$!

wait $cp_pid
echo "${GREEN}==> Migration-resources from migration client have been copied to IS_HOME_NEW root folder successfully!${RESET}"

cd "$AUTOMATION_HOME"
echo "${GREEN}==> Diverted to home successfully${RESET}"

# Needed changes in migration-config.yaml
chmod +x change-migration-config-yaml.sh
sh change-migration-config-yaml.sh "$3" "$4" "$6"
wait $!
echo "${GREEN}==> Did needed changes in migration-config.yaml file successfully${RESET}"

# Copy userstores, tenants,jar files,.jks files from oldIS to newIS
cp -r "$LIB" "$LIB_NEW"
echo "${BLUE}==> Jar files from IS $3 to IS $4 copied successfully!${RESET}"

cp -r "$TENANT_OLD_PATH" "$TENANT_NEW_PATH"
echo "${BLUE}==> Tenants from from IS $3 to IS $4 copied successfully!${RESET}"

cp -r "$RESOURCES_OLD_PATH" "$RESOURCES_NEW_PATH"
echo "${BLUE}==> .jks files from from IS $3 to IS $4 copied successfully!${RESET}"

cp -r "$USERSTORE_OLD_PATH" "$USERSTORE_NEW_PATH"
echo "${BLUE}==> Userstores from IS $3 to IS $4 copied successfully!${RESET}"

# Check if all files are copied successfully
if [ $? -eq 0 ]; then
    echo "${BLUE}==> All files are copied successfully!${RESET}"
else
    echo "${BLUE}==> Error: Some files could not be copied.${RESET}"
fi
echo "${BLUE}==> Copied userstores, tenants,jar files,.jks files from oldIS to newIS successfully${RESET}"

# Deployment toml changes in new is version
chmod +x change-deployment-toml.sh
sh change-deployment-toml.sh "$3" "$4" "$5" "$6" "4"
echo "${GREEN}==> Deployment.toml changed successfully${RESET}"
echo "${BLUE}==> Copied deployment toml of $3 to $4 successfully!${RESET}"
wait $!

# Execute consent management db scripts for IS 5.11.0 - MySQL
if [ "$4" = "5.11.0" && "$5" = "mysql" ]; then
    docker exec -i amazing_feynman sh -c 'exec mysql -uroot -proot -D testdb' </home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/other-db-scripts/config-management-is-5-11.sql
    echo "${GREEN}==> Executing consent management db scripts for IS 5.11.0 - MySQL${RESET}"
else
    echo "${GREEN}==> Skipping executing consent management db scripts since the migrating version is not IS 5.11.0$5 ${RESET}"

fi
wait $!

# Execute consent management db scripts for IS 5.11.0 - MSSQL
if [ "$4" = "5.11.0" && "$5" = "mssql" ]; then
    # Add the command for executing MSSQL script here
    echo "${GREEN}==> Executing consent management db scripts for IS 5.11.0 - MSSQL${RESET}"
else
    echo "${GREEN}==> Skipping executing consent management db scripts since the migrating version is not IS 5.11.0$5 ${RESET}"
fi
wait $!

# Execute consent management db scripts for IS 5.11.0 - PostgreSQL
if [ "$4" = "5.11.0" && "$5" = "postgres" ]; then
    # Add the command for executing PostgreSQL script on Ubuntu here
    echo "${GREEN}==> Executing consent management db scripts for IS 5.11.0 - PostgreSQL (Ubuntu)${RESET}"
else
    echo "${GREEN}==> Skipping executing consent management db scripts since the migrating version is not IS 5.11.0$5 ${RESET}"
fi
wait $!

# Get the existing time and date
time_and_date=$(date +"%Y-%m-%d %H:%M:%S")

# Display message with migration details, currentVersion and migrateVersion values, and time and date
STAR='*'
SPACE=' '

# Define box width
box_width=50

# Function to print a line with stars
print_star_line() {
    printf "%s\n" "$(printf "%${box_width}s" | tr ' ' "$STAR")"
}

# Print the box with migration details
print_star_line
echo "${YELLOW}${STAR}${SPACE}Migration details:${SPACE}${RESET}"
echo "${YELLOW}${STAR}${SPACE}Migrating from IS: $3 to IS: $4${SPACE}${RESET}"
echo "${YELLOW}${STAR}${SPACE}Database: $5${SPACE}${RESET}"
echo "${YELLOW}${STAR}${SPACE}Operating System: $6${SPACE}${RESET}"
echo "${YELLOW}${STAR}${SPACE}Time and date: $time_and_date${SPACE}${RESET}"
print_star_line

# Run the migration client
echo "${GREEN}==> Started running migration client${RESET}"

# Start the migration server
#chmod +x start-server.sh
#sh start-server.sh "$6" "3" "$3" "$4" "true"

# Start wso2IS migration server
cd "$BIN_ISNEW"
echo "${GREEN}==> Entered bin successfully${RESET}"
# Start the migration server
echo "./wso2server.sh -Dmigrate -Dcomponent=identity -Dcarbon.bootstrap.timeout=300" >start.sh
chmod +x start.sh && chmod 777 start.sh
nohup ./start.sh &

# Wait until server is up
is_server_up() {
    local status
    status=$(curl -k -L -s \
        -o /dev/null \
        -w "%{http_code}" \
        --request GET \
        "https://localhost:9443/")
    if [ "$status" -eq 200 ]; then
        return 0
    fi
    return 1
}

wait_until_server_is_up() {
    local timeout=600
    local wait_time=0
    while ! is_server_up; do
        echo "Migration is currently in progress. Please wait..." &&
            sleep 10
        wait_time=$((wait_time + 10))
        if [ "$wait_time" -ge "$timeout" ]; then
            echo "Timeout: migration did not complete within $timeout seconds"
            exit 1
        fi
    done
}

wait_until_server_is_up
echo "${GREEN}==> Yay! Migration process completed!🎉 Check artifacts after completing workflow run to check whether there are any errors${RESET}"

cd "$AUTOMATION_HOME"
echo "${GREEN}==> Directed to home successfully${RESET}"

# Stop wso2IS
chmod +x stop-server.sh
sh stop-server.sh "$6" "4"
echo

# Special config change when migrating from IS 5.9 changing userstore type to database unique id
if [ "$3" = "5.9.0" ]; then
    cd "$DEPLOYMENT_PATH_NEW"
    chmod +x deployment.toml
    for file in $(find "$DEPLOYMENT_PATH_NEW" -type f -name 'deployment.toml'); do
        sed -i 's/type = "database"/#type = "database"/' "$file"
        sed -i 's/#type = "database_unique_id"/type = "database_unique_id"/' "$file"
        echo "Content of $file:"
        cat "$file"
        wait $!
    done
    echo "${GREEN}==> Changes made to deployment toml file - special config change when migrating from IS 5.9 changing userstore type to database unique id${RESET}"

else
    echo "${GREEN}==> Skipping this step since the current version was not IS 5.9.0$5 ${RESET}"
fi

cd "$AUTOMATION_HOME"
echo "${GREEN}==> Migrated WSO2 Identity Server - IS $4 is starting....${RESET}"

# Starting migrated identity server
chmod +x start-server.sh
sh start-server.sh "$6" "4" $3 $4

cd "$AUTOMATION_HOME"

# Run the .sh script to enter login credentials(admin) and divert to management console home page
sh enter-login-credentials.sh &
wait $!
echo "${GREEN}==> Entered to Management console home page successfully${RESET}"

cd "$SERVICE_PROVIDER_PATH"
echo "${GREEN}==> Entered to data population directory-service provider creation${RESET}"

# Run data-population-script.sh which is capable of populating data to create users,tenants,userstores,generate tokens etc.
pwd
chmod +x generate-oauth-token-linux.sh
sh generate-oauth-token-linux.sh
#sh get-oauth-token.sh
wait $!
echo "${GREEN}==> Validated database successfully${RESET}"

cd "$AUTOMATION_HOME"
echo "${GREEN}==> Directed to home successfully${RESET}"

# Stop wso2IS
chmod +x stop-server.sh
sh stop-server.sh "$6" "5"
echo

echo "${CYAN}END OF AUTOMATING PRODUCT MIGRATION TESTING${CYAN}"
