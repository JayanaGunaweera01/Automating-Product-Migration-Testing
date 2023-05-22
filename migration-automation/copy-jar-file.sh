#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
database=$1
os=$2

# Set deployment file and path based on OS
if [ "$os" == "ubuntu-latest" ]; then
  cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
  chmod +x env.sh
  source ./env.sh
  echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"

elif [ "$os" == "macos-latest" ]; then
  cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
  chmod +x env.sh
  source ./env.sh
  echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
fi

# Modify the JDBC driver path based on the database and OS
if [ "$database" == "mssql" ]; then
  if [[ "$os" == "ubuntu-latest" ]]; then
    jdbc_driver="$JAR_MSSQL"
  elif [[ "$os" == "macos-latest" ]]; then
    jdbc_driver="$JAR_MSSQL_MAC"
  fi
elif [ "$database" == "postgres" ]; then
  if [[ "$os" == "ubuntu-latest" ]]; then
    jdbc_driver="$JAR_POSTGRE"
  elif [[ "$os" == "macos-latest" ]]; then
    jdbc_driver="$JAR_POSTGRE_MAC"
  fi
else
  if [ "$os" == "ubuntu-latest" ]; then
    jdbc_driver="$JAR_MYSQL"
  elif [ "$os" == "macos-latest" ]; then
    jdbc_driver="$JAR_MYSQL_MAC"
  fi
fi

# Copy the JDBC driver to the target directory based on OS
if [ "$os" == "ubuntu-latest" ]; then
  cp -r "$jdbc_driver" "$LIB"
  lib_folder="$LIB"
elif [ "$os" == "macos-latest" ]; then
  cp -r "$jdbc_driver" "$LIB_MAC"
  lib_folder="$LIB_MAC"
fi

# Wait for the JDBC driver to be copied to the lib folder
while [ ! -f "$jdbc_driver" ]; do
  echo "${GREEN}==> JDBC driver $jdbc_driver not found in lib folder, waiting...${RESET}"
  sleep 5
done

echo "${GREEN}==> JDBC driver $jdbc_driver found in lib folder, continuing...${RESET}"
