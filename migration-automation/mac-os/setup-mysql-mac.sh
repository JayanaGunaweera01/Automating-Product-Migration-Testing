#!/bin/bash


# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
database=$5

# Source env file
cd /Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation
chmod +x env.sh
source ./env.sh

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


cd $UTILS_MAC

# specify the path to the MySQL script
script_path1="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/mysql.sql"
script_path2="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/identity/mysql.sql"
script_path3="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/identity/uma/mysql.sql"
script_path4="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/consent/mysql.sql"
script_path5="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/metrics/mysql.sql"

# specify the database name
database="testdb"

cd "/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts"
# execute the script against the specified database
mysql -u root -proot -D testdb < $script_path1
mysql -u root -proot -D testdb < $script_path2
mysql -u root -proot -D testdb < $script_path3
mysql -u root -proot -D testdb < $script_path4
mysql -u root -proot -D testdb < $script_path5

echo "\033[0;32m\033[1mCreated database and run needed sql scripts against it - for current IS"   
