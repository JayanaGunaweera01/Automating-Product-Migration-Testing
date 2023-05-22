#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
os=$1

# Setup file and path based on OS
if $1 == "ubuntu-latest" ; then
  cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
  chmod +x env.sh
   . ./env.sh
  echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"

elif $1 == "macos-latest"; then
  cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
  chmod +x env.sh
  source ./env.sh
  echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
fi

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
chmod +x ~/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/db-scripts/database-create-scripts/mysql.sql
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
script_path1="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/db-scripts/IS-5.11/mysql.sql"
script_path2="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/db-scripts/IS-5.11/identity/mysql.sql"
script_path3="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/db-scripts/IS-5.11/identity/uma/mysql.sql"
script_path4="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/db-scripts/IS-5.11/consent/mysql.sql"
script_path5="/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/db-scripts/IS-5.11/metrics/mysql.sql"

# specify the database name
database="testdb"

cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/db-scripts/IS-5.11"
# execute the script against the specified database
mysql -u root -proot -D testdb < $script_path1
mysql -u root -proot -D testdb < $script_path2
mysql -u root -proot -D testdb < $script_path3
mysql -u root -proot -D testdb < $script_path4
mysql -u root -proot -D testdb < $script_path5

echo "${GREEN}Created database and ran needed SQL scripts against it - for current IS${RESET}"

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
