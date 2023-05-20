#!/bin/bash

# THIS IS THE SHELL SCRIPT FOR LINUX - MYSQL/MSSQL/POSTGRE MIGRATIONS INSIDE GITHUB ACTIONS - [POC]

# Define color variables
CYAN='\033[0;36m\033[1m'   # cyan color
GREEN='\033[0;32m\033[1m'  # green color
BLUE='\033[0;34m\033[1m'   # blue color
YELLOW='\033[0;33m\033[1m' # yellow color
ORANGE='\033[0;91m\033[1m' # orange color
RED='\033[0;31m\033[1m'    # red color
RESET='\033[0m'            # reset color

# Define emojis
SAD_FACE="\U0001F614"
PARTY_POPPER="\U0001F389"

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
echo "==> ${GREEN}Env file sourced successfully${RESET}"

# Grant permission to execute sub sh files
chmod +x create-new-database.sh
chmod +x copy-jar-file.sh
chmod +x server-start.sh
chmod +x enter-login-credentials.sh
chmod +x copy-data-to-new-IS.sh
chmod +x change-migration-configyaml.sh
chmod +x copy-data-to-new-IS.sh
chmod +x change-deployment-toml.sh
chmod +x backup-database.sh
chmod +x create-new-database.sh
chmod +x check-cpu-health.sh
chmod +x start-server-is-new.sh
chmod +x start-server-is-old.sh
chmod +x server-stop.sh

# Setup Java
sudo apt-get install -y openjdk-11-jdk &
wait $!
echo "${GREEN}==>Installed Java successfully!${RESET}"

# Set the JAVA_HOME environment variable
export JAVA_HOME=$(readlink -f $(which java)) &
wait $!

cd "$AUTOMATION_HOME"

# Create directory for placing wso2IS
mkdir IS_HOME_OLD
echo "${GREEN}==>Created a directory to place wso2IS${RESET}"

# Navigate to folder
cd IS_HOME_OLD
echo "${GREEN}==> Navigated to bin folder successfully${RESET}"

# Download needed wso2IS zip
wget -qq --waitretry=5 --retry-connrefused $1
ls -a
echo "${GREEN}==>Downloaded needed wso2IS zip${RESET}"

# Unzip IS archive
unzip -qq *.zip &
wait
ls -a
echo "${GREEN}==>Unzipped downloaded Identity Server zip${RESET}"

cd "$AUTOMATION_HOME"

# Given read write access to deployment.toml
chmod +x "$DEPLOYMENT"
echo "${GREEN}==> Given read write access to deployment.toml${RESET}"

cd "$AUTOMATION_HOME"

# Needed changes in deployment.toml
cd "$UBUNTU_PATH"
chmod +x change-deployment-toml-ubuntu.sh
sh change-deployment-toml-ubuntu.sh
echo "${GREEN}==> Deployment.toml changed successfully${RESET}"

# Setup mysql
cd "$UBUNTU_HOME"
chmod +x setup-mysql-ubuntu.sh
sh setup-mysql-ubuntu.sh 

# Copy Jars 
chmod +x copy-jar-file-ubuntu.sh
sh copy-jar-file-ubuntu.sh

cd "$AUTOMATION_HOME"

# Start wso2IS
echo "${GREEN}==> Identity server $3 started running!${RESET}"

# Starting downloaded identity server
sh start-server-is-old.sh

cd "$AUTOMATION_HOME"

# Run the .sh script to enter login credentials(admin) and divert to management console home page
sh enter-login-credentials.sh &
wait $!
echo "${GREEN}==> Entered to Management console home page successfully${RESET}"

cd "$DATA_POPULATION"
echo "${GREEN}==> Entered the data population directory successfully.${RESET}"

# Run data-population-script.sh which is capable of populating data to create users,tenants,userstores,generate tokens etc.
sh data-population-script.sh &
wait $!
echo "${GREEN}==> Created users, user stores, service providers, tenants, generated oAuth tokens and executed the script successfully${RESET}"

cd "$IS_OLD_BIN"
echo "${GREEN}==> Entered bin successfully${RESET}"

# Stop wso2IS
sh wso2server.sh stop

# Wait until server fully stops
while pgrep -f 'wso2server' >/dev/null; do
    sleep 1
done
echo "${GREEN}==> Halted the wso2IS server successfully${RESET}"
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
ls -a
echo "${GREEN}==> Downloaded $4 zip${RESET}"

# Unzip IS archive
unzip -qq *.zip &
wait
ls -a
echo "${GREEN}==> Unzipped $4 zip${RESET}"

# Download migration client
#wget -qq "$LINK_TO_MIGRATION_CLIENT" &
#sleep 30
#echo "${GREEN}==> Downloaded migration client successfully!${RESET}"

cd "$utils"

#Unzip migration client archive
unzip -qq wso2is-migration-1.0.225.zip & # add credentials to download migration client here
sleep 5
echo "${GREEN}==> Unzipped migration client archive${RESET}"

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
cd "$UBUNTU_HOME"
chmod +x change-migration-config-yaml-ubuntu.sh
sh change-migration-config-yaml-ubuntu.sh
echo "${GREEN}==> Did needed changes in migration-config.yaml file successfully${RESET}"

# Copy userstores, tenants,jar files,.jks files from oldIS to newIS
cp -r "$LIB" "$LIB_NEW"
echo "${BLUE}==> Jar files fromfrom IS $3 to IS $4 copied successfully!${RESET}"

cp -r "$TENANT_OLD_PATH" "$TENANT_NEW_PATH"
echo "${BLUE}==> Tenants from from IS $3 to IS $4 copied successfully!${RESET}"

cp -r "$RESOURCES_OLD_PATH" "$RESOURCES_NEW_PATH"
echo "${BLUE}==> .jks files from from IS $3 to IS $4 copied successfully!${RESET}"

cp -r "$USERSTORE_OLD_PATH" "$USERSTORE_NEW_PATH"
echo "${BLUE}==> Userstores from IS $3 to IS $4 copied successfully!${RESET}"

# Deployment toml changes in new is version
cd "$UBUNTU_PATH"
chmod +x change-deployment-toml-ubuntu-new.sh
sh change-deployment-toml-ubuntu-new.sh
echo "${BLUE}==> Copied deployment toml of $3 to $4 successfully!${RESET}"

# Check if all files are copied successfully
if [ $? -eq 0 ]; then
    echo "${BLUE}==> All files are copied successfully!${RESET}"
else
    echo "${BLUE}==> Error: Some files could not be copied.${RESET}"
fi
echo "${BLUE}==> Copied userstores, tenants,jar files,.jks files from oldIS to newIS successfully${RESET}"

#Divert to bin folder
cd "$BIN_ISNEW"
echo "${GREEN}==> Diverted to bin folder successfully${RESET}"

# Get the existing time and date
time_and_date=$(date +"%Y-%m-%d %H:%M:%S")

# Display message with migration details, currentVersion and migrateVersion values, and time and date
echo "${YELLOW}Migration details:${RESET}"
echo "${YELLOW}Migrating from IS $3 to IS $4${RESET}"
echo "${YELLOW}Time and date: $time_and_date${RESET}"

# Run the migration client
echo "${GREEN}==> Started running migration client${RESET}"

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
        echo "Waiting until server starts..." &&
            sleep 10
        wait_time=$((wait_time + 10))
        if [ "$wait_time" -ge "$timeout" ]; then
            echo "Timeout: server did not start within $timeout seconds"
            exit 1
        fi
    done
}

wait_until_server_is_up

# Check logs for errors
if grep -qiE "error" logs.txt; then
    echo "${RED}==>Migration process completed with some errors. Please check logs.${SAD_FACE}${RESET}"
else
    echo "${GREEN}==> Yay!Migration executed successfully!${PARTY_POPPER}${RESET}"
fi

# Stop wso2IS migration server
cd "$BIN_ISNEW"

# Execute the server stop command
./wso2server.sh stop

# Wait for the server to fully stop
is_stopped=false
while [ "$is_stopped" != true ]; do
    # Check if the server is still running
    status=$(ps -ef | grep "wso2server" | grep -v "grep")
    if [ -z "$status" ]; then
        is_stopped=true
    else
        # Sleep for a few seconds and check again
        sleep 5
    fi
done

# Verify that the server is fully stopped
is_running=false
while [ "$is_running" != true ]; do
    # Check if the server is running
    status=$(ps -ef | grep "wso2server" | grep -v "grep")
    if [ -z "$status" ]; then
        is_running=true
    else
        # Sleep for a few seconds and check again
        sleep 5
    fi
done

echo "${GREEN}==> Stopped migration terminal successfully!${RESET}"

cd "$AUTOMATION_HOME"
echo "${GREEN}==> Migrated WSO2 Identity Server - IS $4 is starting....${RESET}"

# Starting migrated identity server
sh start-server-is-new.sh

cd "$AUTOMATION_HOME"

# Run the .sh script to enter login credentials(admin) and divert to management console home page
sh enter-login-credentials.sh &
wait $!
echo "${GREEN}==> Entered to Management console home page successfully${RESET}"

cd "$SERVICE_PROVIDER_PATH"
echo "${GREEN}==> Entered to data population directory-service provider creation${RESET}"

# Run data-population-script.sh which is capable of populating data to create users,tenants,userstores,generate tokens etc.
sh generate-oauth-token-linux.sh
sh get-oauth-token.sh
wait $!
echo "${GREEN}==> Validated database successfully${RESET}"

# Stop wso2IS migration server
cd "$BIN_ISNEW"
echo "${GREEN}==> Shutting down updated identity server${RESET}"

# Execute the server stop command
./wso2server.sh stop

# Wait for the server to fully stop
is_stopped=false
while [ "$is_stopped" != true ]; do
    # Check if the server is still running
    status=$(ps -ef | grep "wso2server" | grep -v "grep")
    if [ -z "$status" ]; then
        is_stopped=true
    else
        # Sleep for a few seconds and check again
        sleep 5
    fi
done

# Verify that the server is fully stopped
is_running=false
while [ "$is_running" != true ]; do
    # Check if the server is running
    status=$(ps -ef | grep "wso2server" | grep -v "grep")
    if [ -z "$status" ]; then
        is_running=true
    else
        # Sleep for a few seconds and check again
        sleep 5
    fi
done

echo "${CYAN}END OF AUTOMATING PRODUCT MIGRATION TESTING${CYAN}"
