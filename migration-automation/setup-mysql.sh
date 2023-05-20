#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Method to source the relevant env file based on the OS input
source_env_file() {
  local os=$1

  case $os in
    "ubuntu-latest")
      source_env_file_ubuntu
      ;;
    "macos-latest")
      source_env_file_macos
      ;;
    "windows-latest")
      source_env_file_windows
      ;;
    *)
      echo -e "${GREEN}==> Unknown OS: $os${RESET}"
      ;;
  esac
}

# Method to source the env file for Ubuntu
source_env_file_ubuntu() {
  cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
  chmod +x env.sh
  . ./env.sh
}

# Method to source the env file for macOS
source_env_file_macos() {
  cd "/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/01-Migration-Automation"
  source ./env.sh
  echo -e "${GREEN}==> Env file sourced successfully${RESET}"
}

# Method to source the env file for Windows
source_env_file_windows() {
  cd "D:\a\Automating-Product-Migration-Testing\Automating-Product-Migration-Testing\migration-automation"
  . ./env.sh
  echo -e "${GREEN}==> Env file sourced successfully${RESET}"
}

# Get the value of the inputs
os=$6

# Source the relevant env file based on the OS input
source_env_file $os

# Method Ubuntu
ubuntu_method() {
  # Stop mysql running inside github actions and wait for the MySQL container to start
  sudo systemctl stop mysql &
  sleep 10
  echo "${GREEN}==> Local mysql stopped successfully${RESET}"

  # Start running docker container
  docker run --name "$CONTAINER_NAME" -p "$HOST_PORT":"$CONTAINER_PORT" -e MYSQL_ROOT_PASSWORD="$ROOT_PASSWORD" -d mysql:"$MYSQL_VERSION"

  # Wait for container to start up
  while [ "$(docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME")" != "running" ]; do
    printf "${GREEN}==> Waiting for container to start up...${RESET}\n"
    sleep 1
  done
  echo "${GREEN}==> Container is up and running.${RESET}"

  # Get container IP address
  CONTAINER_ID=$(docker ps -aqf "name=$CONTAINER_NAME")
  DB_HOST=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$CONTAINER_ID")

  while ! mysqladmin ping -h"$DB_HOST" --silent; do
    printf "${GREEN}==> Waiting for mysql server to be healthy...${RESET}\n"
    sleep 1
  done

  # Connect to MySQL server
  echo "${GREEN}==> MySQL server is available on $DB_HOST${RESET}"

  # MySQL is available
  echo "${GREEN}==> MySQL is now available!${RESET}"

  # Check docker status
  docker ps

  # Find the ID of the running MySQL container
  MYSQL_CONTAINER_ID=$(docker ps | grep mysql | awk '{print $1}')

  # Start the MySQL container
  if [ -n "$MYSQL_CONTAINER_ID" ]; then
    docker start $MYSQL_CONTAINER_ID
    echo "${GREEN}==> MySQL container started successfully${RESET}"
  else
    echo "${GREEN}==> No running MySQL container found${RESET}"
  fi

  # Check if MySQL is listening on the default MySQL port (3306)
  if netstat -ln | grep ':3306'; then
    echo "${GREEN}==> MySQL is listening on port 3306${RESET}"
  else
    echo "${GREEN}==> MySQL is not listening on port 3306${RESET}"
  fi

  # Create database
  chmod +x "$DATABASE_CREATION_SCRIPT"
  docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD'' <"$DATABASE_CREATION_SCRIPT"
  echo "${GREEN}==> Database created successfully!${RESET}"

  # Execute SQL scripts
  chmod +x ~/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/db-scripts/IS-5.11/mysql.sql
  docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD' -D '$DATABASE_NAME'' <"$DB_SCRIPT_MYSQL"
  docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD' -D '$DATABASE_NAME'' <"$DB_SCRIPT_IDENTITY"
  docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD' -D '$DATABASE_NAME'' <"$DB_SCRIPT_UMA"
  docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD' -D '$DATABASE_NAME'' <"$DB_SCRIPT_CONSENT"
  docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD' -D '$DATABASE_NAME'' <"$DB_SCRIPT_METRICS"
  echo "${GREEN}==> Database scripts executed and created tables successfully!${RESET}"
}

# Method Macos
macos_method() {
  # Stop mysql running inside github actions and wait for the MySQL container to start
  brew services stop mysql &
  sleep 20

  brew install mysql
  sleep 20

  sudo chown -R _mysql:mysql /usr/local/var/mysql
  sudo mysql.server start

  # Wait for MySQL to start
  sleep 20

  mysql -u root
  mysqladmin -u root password root

  # Check if MySQL is running
  if ! pgrep mysql &> /dev/null; then
    echo "MySQL is not running"
    exit 1
  fi

  # Create the database
  mysql -u root -proot -e "CREATE DATABASE testdb CHARACTER SET latin1;"

  cd $UTILS_MAC

  # Specify the path to the MySQL script
  script_path1="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/mysql.sql"
  script_path2="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/identity/mysql.sql"
  script_path3="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/identity/uma/mysql.sql"
  script_path4="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/consent/mysql.sql"
  script_path5="/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts/metrics/mysql.sql"

  # Specify the database name
  database="testdb"

  cd "/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/utils/dbscripts"

  # Execute the script against the specified database
  mysql -u root -proot -D testdb < $script_path1
  mysql -u root -proot -D testdb < $script_path2
  mysql -u root -proot -D testdb < $script_path3
  mysql -u root -proot -D testdb < $script_path4
  mysql -u root -proot -D testdb < $script_path5

  echo "${GREEN}==> Created database and run needed SQL scripts against it - for current IS${RESET}"
}

# Method Windows
windows_method() {
  # Method implementation for Windows goes here
  echo "${GREEN}==> Method for Windows OS is not implemented yet.${RESET}"
}

# Execute the method based on the OS input
case $os in
  "ubuntu-latest")
    ubuntu_method
    ;;
  "macos-latest")
    macos_method
    ;;
  "windows-latest")
    windows_method
    ;;
  *)
    echo -e "${GREEN}==> Unknown OS: $os${RESET}"
    ;;
esac


