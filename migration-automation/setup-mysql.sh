#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
os=$1

# Setup file and path based on OS
if [ "$os" == "ubuntu-latest" ]; then
  cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
  chmod +x env.sh
   . ./env.sh
  echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"

elif [ "$os" == "macos-latest" ]; then
  cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
  chmod +x env.sh
  source ./env.sh
  echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
fi

# Method Ubuntu
ubuntu_method() {
  # Stop MySQL running inside GitHub Actions and wait for the MySQL container to start
  sudo systemctl stop mysql
  sleep 10
  echo "${GREEN}==> Local MySQL stopped successfully${RESET}"

  # Start running Docker container
  docker run --name "$CONTAINER_NAME" -p "$HOST_PORT":"$CONTAINER_PORT" -e MYSQL_ROOT_PASSWORD="$ROOT_PASSWORD" -d mysql:"$MYSQL_VERSION"

  # Wait for the container to start up
  until docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME" | grep -q "running"; do
    echo "${GREEN}==> Waiting for container to start up...${RESET}"
    sleep 1
  done
  echo "${GREEN}==> Container is up and running.${RESET}"

  # Get container IP address
  CONTAINER_ID=$(docker ps -aqf "name=$CONTAINER_NAME")
  DB_HOST=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$CONTAINER_ID")

  until mysqladmin ping -h"$DB_HOST" --silent; do
    echo "${GREEN}==> Waiting for MySQL server to be healthy...${RESET}"
    sleep 1
  done

  # Connect to MySQL server
  echo "${GREEN}==> MySQL server is available on $DB_HOST${RESET}"

  # Check Docker status
  docker ps

  # Find the ID of the running MySQL container
  MYSQL_CONTAINER_ID=$(docker ps -q --filter "name=$CONTAINER_NAME")

  # Start the MySQL container
  if [ -n "$MYSQL_CONTAINER_ID" ]; then
    docker start "$MYSQL_CONTAINER_ID"
    echo "${GREEN}==> MySQL container started successfully${RESET}"
  else
    echo "${GREEN}==> No running MySQL container found${RESET}"
  fi

  # Check if MySQL is listening on the default MySQL port (3306)
  if netstat -ln | grep -q ':3306'; then
    echo "${GREEN}==> MySQL is listening on port 3306${RESET}"
  else
    echo "${GREEN}==> MySQL is not listening on port 3306${RESET}"
  fi

  # Create database
  chmod +x "$DATABASE_CREATION_SCRIPT"
  docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD'' <"$DATABASE_CREATION_SCRIPT"
  echo "${GREEN}==> Database created successfully!${RESET}"

  # Execute SQL scripts
  db_scripts=("mysql.sql" "identity/mysql.sql" "identity/uma/mysql.sql" "consent/mysql.sql" "metrics/mysql.sql")
  for script in "${db_scripts[@]}"; do
    chmod +x "$source_path/utils/db-scripts/IS-5.11/$script"
    docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD' -D '$DATABASE_NAME'' <"$source_path/utils/db-scripts/IS-5.11/$script"
  done
  echo "${GREEN}==> Database scripts executed and tables created successfully inside Ubuntu!${RESET}"
}

# Method Macos
macos_method() {
  # Stop MySQL running inside GitHub Actions and wait for the MySQL container to start
  brew services stop mysql
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
  if ! pgrep mysql &>/dev/null; then
    echo "MySQL is not running"
    exit 1
  fi

  # Create the database
  mysql -u root -proot -e "CREATE DATABASE testdb CHARACTER SET latin1;"

  cd "$source_path/utils/db-scripts/IS-5.11" || exit 1

  # Execute the SQL scripts against the specified database
  db_scripts=("mysql.sql" "identity/mysql.sql" "identity/uma/mysql.sql" "consent/mysql.sql" "metrics/mysql.sql")
  for script in "${db_scripts[@]}"; do
    mysql -u root -proot -D testdb <"$script"
  done

  echo "${GREEN}==> MySQL database created and scripts executed successfully inside Mac!${RESET}"
}

# Method Windows
windows_method() {
  # Stop MySQL running inside GitHub Actions and wait for the MySQL container to start
  powershell -Command 'Stop-Service -Name "mysql"'

  # Start running Docker container
  docker run --name "$CONTAINER_NAME" -p "$HOST_PORT":"$CONTAINER_PORT" -e MYSQL_ROOT_PASSWORD="$ROOT_PASSWORD" -d mysql:"$MYSQL_VERSION"

  # Wait for the container to start up
  until docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME" | grep -q "running"; do
    echo "${GREEN}==> Waiting for container to start up...${RESET}"
    sleep 1
  done
  echo "${GREEN}==> Container is up and running.${RESET}"

  # Get container IP address
  CONTAINER_ID=$(docker ps -aqf "name=$CONTAINER_NAME")
  DB_HOST=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_ID")

  until mysqladmin ping -h "$DB_HOST" --silent; do
    echo "${GREEN}==> Waiting for MySQL server to be healthy...${RESET}"
    sleep 1
  done

  # Connect to MySQL server
  echo "${GREEN}==> MySQL server is available on $DB_HOST${RESET}"

  # Check Docker status
  docker ps

  # Find the ID of the running MySQL container
  MYSQL_CONTAINER_ID=$(docker ps | grep mysql | awk '{print $1}')

  # Start the MySQL container
  if [ -n "$MYSQL_CONTAINER_ID" ]; then
    docker start "$MYSQL_CONTAINER_ID"
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
  docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD'' <"$DATABASE_CREATION_SCRIPT"
  echo "${GREEN}==> Database created successfully!${RESET}"

  # Execute SQL scripts
  db_scripts=("mysql.sql" "identity/mysql.sql" "identity/uma/mysql.sql" "consent/mysql.sql" "metrics/mysql.sql")
  for script in "${db_scripts[@]}"; do
    docker exec -i "$CONTAINER_NAME" sh -c 'exec mysql -uroot -p'$ROOT_PASSWORD' -D '$DATABASE_NAME'' <"$UTILS_DIR/db-scripts/IS-5.11/'"$script"
  done
  echo "${GREEN}==> Database scripts executed and tables created successfully!${RESET}"
}

# Check which OS is provided and execute the respective method
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
esac
