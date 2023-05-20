#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the values of the inputs
database=$5
os=$6

# Method to copy the relevant JDBC driver to the target directory based on the database and OS input
copy_jdbc_driver() {
  case "$database-$os" in
    "mysql-ubuntu-latest")
      cp -r "$JAR_MYSQL" "$LIB"
      ;;
    "mssql-ubuntu-latest")
      cp -r "$JAR_MSSQL" "$LIB"
      ;;
    "postgres-ubuntu-latest")
      cp -r "$JAR_POSTGRE" "$LIB"
      ;;
    "mysql-macos-latest")
      cp -r "$JAR_MYSQL_MAC" "$LIB_MAC"
      ;;
    "mssql-macos-latest")
      cp -r "$JAR_MSSQL_MAC" "$LIB_MAC"
      ;;
    "postgres-macos-latest")
      cp -r "$JAR_POSTGRE_MAC" "$LIB_MAC"
      ;;
  esac

  # Determine the JDBC driver file path based on the database and OS
  driver_file=""
  if test "$os" = "ubuntu-latest"; then
    case "$database" in
      "mysql")
        driver_file="$JAR_MYSQL"
        ;;
      "mssql")
        driver_file="$JAR_MSSQL"
        ;;
      "postgres")
        driver_file="$JAR_POSTGRE"
        ;;
    esac
  elif test "$os" = "macos-latest"; then
    case "$database" in
      "mysql")
        driver_file="$JAR_MYSQL_MAC"
        ;;
      "mssql")
        driver_file="$JAR_MSSQL_MAC"
        ;;
      "postgres")
        driver_file="$JAR_POSTGRE_MAC"
        ;;
    esac
  fi

  # Wait for the JDBC driver to be copied to the lib folder
  while ! test -f "$driver_file"; do
    echo "${GREEN}==> JDBC driver not found in lib folder, waiting...${RESET}"
    sleep 5
  done

  echo "${GREEN}==> JDBC driver found in lib folder, continuing...${RESET}"
}

# Copy the relevant JDBC driver to the target directory based on the database and OS input
copy_jdbc_driver

