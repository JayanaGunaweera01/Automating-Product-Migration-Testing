#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the values of the inputs
database=$5
os=$6

# Method to source the relevant env file based on the OS input
source_env_file() {
  
  case $os in
    "ubuntu-latest")
      cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
      chmod +x env.sh
      . ./env.sh
      ;;
    "macos-latest")
      cd "/Users/runner/work/Automate-Product-Migration-Testing/Automate-Product-Migration-Testing/01-Migration-Automation"
      source ./env.sh
      echo -e "${GREEN}==> Env file sourced successfully${RESET}"
      ;;
    "windows-latest")
      cd "D:\a\Automating-Product-Migration-Testing\Automating-Product-Migration-Testing\migration-automation"
      . ./env.sh
      echo -e "${GREEN}==> Env file sourced successfully${RESET}"
      ;;
  esac
}

# Method to copy the relevant JDBC driver to the target directory based on the database input
copy_jdbc_driver() {
  local database=$1

  case $database in
    "mysql")
      cp -r "$JAR_MYSQL" "$LIB"
      ;;
    "mssql")
      cp -r "$JAR_MSSQL" "$LIB"
      ;;
    "postgres")
      cp -r "$JAR_POSTGRE" "$LIB"
      ;;
  esac

  # Wait for the JDBC driver to be copied to the lib folder
  while [ ! -f "$LIB/$database-jdbc-driver.jar" ]; do
    echo -e "${GREEN}==> JDBC driver not found in lib folder, waiting...${RESET}"
    sleep 5
  done

  echo -e "${GREEN}==> JDBC driver found in lib folder, continuing...${RESET}"
}


# Source the relevant env file based on the OS input
source_env_file $os

# Copy the relevant JDBC driver to the target directory based on the database input
copy_jdbc_driver $database



