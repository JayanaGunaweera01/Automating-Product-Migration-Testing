#!/bin/bash

# MAC OS - CODEBLOCK TO RUN WITH GITHUB ACTIONS - POC

# Update the system before downloading packages
sudo apt-get -qq update

# Install fonts for terminal usage
sudo apt-get -qq install toilet figlet
sudo apt-get -qq install toilet toilet-fonts
echo 

# Define color variables
CYAN='\033[0;36m\033[1m' # cyan color
GREEN='\033[0;32m\033[1m' # green color
BLUE='\033[0;34m\033[1m' # blue color
YELLOW='\033[0;33m\033[1m' # yellow color
RESET='\033[0m' # reset color

# Print welcome message using toilet command
toilet -f term -F border --gay "WELCOME TO AUTOMATING PRODUCT MIGRATION TESTING!"

# Print instructions with different colors and formatting using echo command
echo "${GREEN}
1.|* Before proceeding make sure you have installed ${RESET}\033[0;31mwget and jq${RESET}${GREEN} *|
2.|* Set up ${RESET}\033[0;31mjava open JDK 11${RESET}${GREEN} *|
3.|* Set up ${RESET}\033[0;31mdocker${RESET}${GREEN} and ${RESET}\033[0;31mmysql 8.3${RESET}${GREEN} *|
4 and stop mysql if its locally installed.|* Place relevant JDBC driver for the version you are using in the  ${RESET}\033[0;31m3-utils${RESET}${GREEN} folder  *|
5.|* Clean the database if there's any revoked, inactive, and expired tokens accumulate in the IDN_OAUTH2_ACCESS_TOKEN table${RESET}${GREEN}|
${RESET}"

toilet -f future --filter border:metal -w 98 'TIME TO Automating PRODUCT MIGRATION TESTING!'
sudo apt-get install jp2a
jp2a --colors  --flipx --term-height "./humanoid.jpg"

# Get the value of the "currentVersion" and "migratingVersion" inputs
currentVersion=$3
migratingVersion=$4

# Remove spaces from the beginning and end of the currentVersion variable
currentVersion=$(echo $currentVersion | xargs)

# Combine "wso2is-" and the value of the "currentVersion" input, without spaces
combinedCurrentVersion="wso2is-${currentVersion}"

# Replace all instances of "CurrentVersion" with the combined version value
sed -i "" "s/CurrentVersion/${combinedCurrentVersion}/g" /Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/1-migration-automation/env.sh

# Remove spaces from the beginning and end of the migratingVersion variable
migratingVersion=$(echo $migratingVersion | xargs)

# Combine "wso2is-" and the value of the "currentVersion" input, without spaces
combinedMigratingVersion="wso2is-${migratingVersion}"

# Replace all instances of "MigratingVersion" with the value of the "migratingVersion" input, without spaces
sed -i "" "s/MigratingVersion/${combinedMigratingVersion}/g" /Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/1-migration-automation/env.sh

# Source env file
cd /Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/1-migration-automation
source ./env.sh
echo "\033[0;32m\033[1mEnv file sourced successfully\033[0;m"

chmod +x create-new-database.sh
chmod +x copy-jar-file.sh
chmod +x server-start.sh
chmod +x enter-login-credentials.sh
chmod +x copy-data-to-new-IS.sh
chmod +x change-migration-configyaml.sh 
chmod +x copy-data-to-new-IS.sh
chmod +x change-deployment-toml.sh
chmod +x backup-database.sh
chmod +x create-new-database.sh                                                               #executes from bash
chmod +x check-cpu-health.sh
#chmod +x data-population-script.sh

# Process start
toilet -f future --filter border:metal -w 140 'PROCESS STARTED!' 

# Set up Java
brew install openjdk@11 &
wait $!

# Set the JAVA_HOME environment variable
export JAVA_HOME=$(/usr/libexec/java_home -v 11)

# Create directory for placing wso2IS 
mkdir IS_HOME_OLD
echo "\033[0;32m\033[1mCreated a directory to place wso2IS\033[0;m"

# Navigate to folder
cd "./IS_HOME_OLD"

# Download needed wso2IS zip
wget -qq --waitretry=5 --retry-connrefused $1
ls -a
echo "\033[0;32m\033[1mDownloaded needed wso2IS zip\033[0;m"

# Unzip IS archive
unzip -qq *.zip &
wait
ls -a
echo "\033[0;32m\033[1mUnzipped downloaded Identity Server zip\033[0;m"

cd $AUTOMATION_HOME_MAC

# Given read write access to deployment.toml
chmod +x $DEPLOYMENT_MAC
echo "\033[0;32m\033[1mGiven read write access to deployment.toml\033[0;m"

cd $AUTOMATION_HOME_MAC

# Needed changes in deployment.toml
sh change-deployment-toml-macos-mysql.sh
echo "\033[0;32m\033[1mDeployment.toml changed successfully\033[0;m"  
        
cd $AUTOMATION_HOME_MAC

# Stop mysql running inside github actions and wait for the MySQL container to start
brew services stop mysql &
sleep 20

brew install mysql
sleep 20

sudo chown -R _mysql:mysql /usr/local/var/mysql
sudo mysql.server start

# wait for MySQL to start
sleep 20

mysql -u root
mysqladmin -u root password root


# Check if MySQL is running
if ! pgrep mysql &> /dev/null; then
  echo "MySQL is not running"
  exit 1
fi

# create the database
mysql -u root -proot -e "CREATE DATABASE testdb CHARACTER SET latin1;"


cd $3-utils_MAC

# specify the path to the MySQL script
script_path1="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/3-utils/3.1-db-scripts/IS-5.11/mysql.sql"
script_path2="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/3-utils/3.1-db-scripts/IS-5.11/identity/mysql.sql"
script_path3="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/3-utils/3.1-db-scripts/IS-5.11/identity/uma/mysql.sql"
script_path4="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/3-utils/3.1-db-scripts/IS-5.11/consent/mysql.sql"
script_path5="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/3-utils/3.1-db-scripts/IS-5.11/metrics/mysql.sql"

# specify the database name
database="testdb"

cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/3-utils/3.1-db-scripts/IS-5.11"
# execute the script against the specified database
mysql -u root -proot -D testdb < $script_path1
mysql -u root -proot -D testdb < $script_path2
mysql -u root -proot -D testdb < $script_path3
mysql -u root -proot -D testdb < $script_path4
mysql -u root -proot -D testdb < $script_path5

echo "\033[0;32m\033[1mCreated database and run needed sql scripts against it - for current IS"   

# Copy the JDBC driver to the target directory

cd "$3-utils_MAC"
cp -r "$JAR_MYSQL_MAC" "$LIB_MAC"
echo "\033[0;32m\033[1mPlaced JDBC driver successfully\033[0;m"

# Wait for the JDBC driver to be copied to the lib folder
while [ ! -f "$JAR_MYSQL_MAC" ]
do
  echo "\033[0;32m\033[1mJDBC driver not fully copied to lib folder, waiting...\033[0;m"
  sleep 5
done

echo "\033[0;32m\033[1mJDBC driver fully copied to lib folder\033[0;m"

echo "\033[0;32m\033[1mJDBC driver found in lib folder, continuing...\033[0;m"


# Start wso2IS
toilet -f future --filter border:metal -w 140 'IS Old started running!' 

cd "$BIN_ISOLD_MAC"
echo "\033[0;32m\033[1mDiverted to bin\033[0;m"

echo "./wso2server.sh -Dcarbon.bootstrap.timeout=300" > start.sh
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
        wait_time=$((wait_time+10))
        if [ "$wait_time" -ge "$timeout" ]; then
            echo "Timeout: server did not start within $timeout seconds"
            exit 1
        fi
    done
}

wait_until_server_is_up
echo "\033[0;32m\033[1mWSO2 Identity Server has started successfully\033[0;m"

cd "$AUTOMATION_HOME_MAC"

# Run the shell script to enter login credentials(admin) and divert to management console home page
sh enter-login-credentials.sh &
wait $!
echo "\033[0;32m\033[1mEntered to Management console home page successfully\033[0;m"

#cd "$DATA_POPULATION_MAC"
cd /Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/02-POC/macos/2-data-population-and-validation
echo "\033[0;32m\033[1mEntered to data population directory\033[0;m"
pwd
ls -a
# Run data-population-script.sh which is capable of populating data to create users,tenants,userstores,generate tokens etc.
chmod +x data-population-script.sh
sh data-population-script.sh &
sleep 30
echo "\033[0;32m\033[1mCreated users, user stores, service providers, tenants,generated oAuth tokens and executed the script successfully\033[0;m"

cd "$BIN_ISOLD_MAC"
echo "\033[0;32m\033[1mEntered bin successfully\033[0;m"

# Stop wso2IS
./wso2server.sh stop
sleep 20
echo "\033[0;32m\033[1mWSO2 Identity Server has stopped successfully\033[0;m"

# Get the process ID of the process that is currently using port 10711
pid=$(sudo lsof -i :10711 -t)

# If the process ID is not empty, use it to kill the process
if [ ! -z "$pid" ]; then
    sudo kill $pid
    echo "Terminated process with PID $pid"
else
    echo "No running process found"
fi

sleep 10
echo "\033[0;32m\033[1mHalted the wso2IS server successfully\033[0;m"

cd "$AUTOMATION_HOME_MAC"
echo "\033[0;32m\033[1mDirected to home successfully\033[0;m" 

# Create directory for placing latest wso2IS (IS to migrate)
mkdir IS_HOME_NEW
echo "\033[0;32m\033[1mCreated a directory for placing latest wso2IS\033[0;m"

# Navigate to folder 
cd "$IS_HOME_NEW_MAC"

# Download needed (latest) wso2IS zip                                                            
wget -qq --waitretry=5 --retry-connrefused ${2}
ls -a
echo "\033[0;32m\033[1mDownloaded latest wso2IS zip\033[0;m"

# Unzip IS archive
unzip -qq *.zip &
wait
ls -a
echo "\033[0;32m\033[1mUnzipped latest wso2IS zip\033[0;m"

cd "$AUTOMATION_HOME_MAC"

# Download migration client
#wget -qq "$LINK_TO_MIGRATION_CLIENT" &
#sleep 30
#echo "\033[0;32m\033[1mDownloaded migration client successfully!\033[0;m"

#pwd
#ls -a

#bash download-migration-client.sh
# Wait for the Migration client to be copied 
#while [ ! -f "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/1-migration-automation/wso2is-migration-1.0.225" ]
#do
  #echo "\033[0;32m\033[1mMigration client not found in  folder, waiting...\033[0;m"
  #sleep 5
#done
#echo "\033[0;32m\033[1mMigration client found in folder, continuing...\033[0;m"

cd "$3-utils_MAC_PATH"
# Unzip migration client archive
unzip -qq wso2is-migration-1.0.225.zip &
sleep 60
echo "\033[0;32m\033[1mUnzipped migration client archive\033[0;m"

# Navigate to dropins folder 
cd "$DROPINS_PATH_HOME_MAC"

# Copy droipns folder to wso2IS (latest) dropins folder                                               
cp -r "$DROPINS_PATH_MAC" "$COMPONENTS_PATH_MAC" &
sleep 5
echo "\033[0;32m\033[1mJar files from migration client have been copied to IS_HOME_NEW/repository/components/dropins folder successfully!\033[0;m"
                                             
# Copy migration resources folder to wso2IS (latest) root folder
cp -r "$MIGRATION_RESOURCES_MAC" "$IS_NEW_ROOT_MAC" &
sleep 5
echo "\033[0;32m\033[1mMigration-resources from migration client have been copied to IS_HOME_NEW root folder successfully!\033[0;m"
                                                               
cd "$POC_HOME_MAC"
echo "\033[0;32m\033[1mDiverted to POC-Macos successfully\033[0;m"

# Needed changes in migration-config.yaml
sh migration-configyaml-mac.sh
echo "\033[0;32m\033[1mDid needed changes in migration-config.yaml file successfully\033[0;m" 
                     
# Copy userstores, tenants,jar files,.jks files from oldIS to newIS
cp -r "$LIB_MAC" "$LIB_NEW_MAC" 
echo "\033[0;34mJar files from /components/lib of OLD IS have been copied to NEW IS successfully!\033[0;34m"

cp -r "$TENANT_OLD_PATH_MAC" "$TENANT_NEW_PATH_MAC"
echo "\033[0;34mTenants of IS 5.11 copied to IS 6.1 successfully!\033[0;34m"

cp -r "$RESOURCES_OLD_PATH_MAC" "$RESOURCES_NEW_PATH_MAC" 
echo "\033[0;34m.jks files from IS 5.11 copied to IS 6.1 successfully!\033[0;34m"

cp -r "$USERSTORE_OLD_PATH_MAC" "$USERSTORE_NEW_PATH_MAC"
echo "\033[0;34mUserstores from IS 5.11 copied to IS 6.1 successfully!\033[0;34m"

# Get a backup of existing database
#sh backup-database.sh &
#sleep 30
#echo "\033[0;32m\033[1mData backedup successfully\033[0;m" 

cd "$AUTOMATION_HOME_MAC"

for file in $(find $DEPLOYMENT_PATH_NEW_MAC -type f -name 'deployment.toml');
do
cat $DEPLOYMENT_AUTOMATION_MAC > $file;

done
sleep 3
echo "\033[0;32m\033[1mChanged deployment toml successfully\033[0;m"

#Divert to bin folder
cd "$BIN_ISNEW_MAC"
pwd
echo "\033[0;32m\033[1mDiverted to bin folder successfully\033[0;m"

#changes in wso2server.sh file                                                                            Check here

# Run the migration client
toilet -f term -F border --gay 'Started running migration client'

echo "./wso2server.sh -Dmigrate -Dcomponent=identity -Dcarbon.bootstrap.timeout=300" > start.sh
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
        wait_time=$((wait_time+10))
        if [ "$wait_time" -ge "$timeout" ]; then
            echo "Timeout: server did not start within $timeout seconds"
            exit 1
        fi
    done
}

wait_until_server_is_up
toilet -f term -F border --gay 'Yay!Migration executed successfully.'

# If the process ID is not empty, use it to kill the process
if [ ! -z "$pid" ]; then
    kill $pid
    echo "\033[0;32m\033[1mTerminated process with PID $pid\033[0;m"
else
    echo "\033[0;32m\033[1mNo running process found\033[0;m"
fi
						
# Find the process ID of the WSO2 Identity Server process
process_id=$(pgrep -f "wso2server.sh")

# Find the process ID of the WSO2 Identity Server process
process_id2=$(pgrep -f "start.sh")

# Send a termination signal to the process
kill $process_id
kill $process_id2
sleep 30
toilet -f term -F border --gay 'Stopped migration terminal successfully.'

# Verify migration - Check CPU health
#sh check-cpu-health.sh

cd "$BIN_ISNEW_MAC"
toilet -f term -F border --gay 'Starting Migrated Identity Server'

echo "./wso2server.sh -Dcarbon.bootstrap.timeout=300"  > start.sh
chmod +x start.sh && chmod 777 start.sh
    
nohup ./start.sh &
sleep 60
echo "\033[0;32m\033[1mMigrated WSO2 Identity Server has started successfully\033[0;m"

cd "$AUTOMATION_HOME_MAC"

# Run the script to enter login credentials(admin) and divert to management console home page
sh enter-login-credentials.sh
echo "\033[0;32m\033[1mEntered to Management console home page successfully\033[0;m"
 
#cd "$DATA_POPULATION_MAC" 

cd /Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/02-POC/macos/2-data-population-and-validation/00-4service-provider-creation
echo "\033[0;32m\033[1mEntered to data population directory\033[0;m"

# Run data-population-script.sh which is capable of populating data to create users,tenants,userstores,generate tokens etc.
#sh validate-database.sh
sh generate-oauth-token-macos-POC.sh
sleep 5
echo "\033[0;32m\033[1mValidated database successfully\033[0;m"

#cd /home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/1-migration-automation
# log report
#chmod +x summary-report.sh
#sh summary-report.sh

#chmod +x artifacts.sh
#sh artifacts.sh &
#sleep 60

toilet --filter metal -w 140 'BYE!!'
