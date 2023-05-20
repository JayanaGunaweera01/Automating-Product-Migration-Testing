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
    "mysql-windows-latest")
      Copy-Item -Path "D:\a\Automate-Product-Migration-Testing\Automate-Product-Migration-Testing\utils\mysql-connector-java-8.0.29.jar" -Destination "D:\a\Automate-Product-Migration-Testing\Automate-Product-Migration-Testing\01-Migration-Automation\IS_HOME_OLD\wso2is-5.11.0\repository\components\lib\"
      Write-Host "`e[0;32m`e[1mPlaced JDBC driver successfully`e[0m"
      ;;
    *)
      echo "${GREEN}==> Unknown combination of database and OS: $database-$os${RESET}"
      ;;
  esac

  # Determine the JDBC driver file path based on the database and OS
  driver_file=""
  if [ "$os" == "ubuntu-latest" ]; then
    case "$database" in
      "mysql")
        driver_file="$LIB/$JAR_MYSQL"
        ;;
      "mssql")
        driver_file="$LIB/$JAR_MSSQL"
        ;;
      "postgres")
        driver_file="$LIB/$JAR_POSTGRE"
        ;;
    esac
  elif [ "$os" == "macos-latest" ]; then
    case "$database" in
      "mysql")
        driver_file="$LIB_MAC/$JAR_MYSQL_MAC"
        ;;
      "mssql")
        driver_file="$LIB_MAC/$JAR_MSSQL_MAC"
        ;;
      "postgres")
        driver_file="$LIB_MAC/$JAR_POSTGRE_MAC"
        ;;
    esac
  elif [ "$os" == "windows-latest" ]; then
    case "$database" in
      "mysql")
        driver_file="D:\a\Automate-Product-Migration-Testing\Automate-Product-Migration-Testing\01-Migration-Automation\IS_HOME_OLD\wso2is-5.11.0\repository\components\lib\mysql-connector-java-8.0.29.jar"
        ;;
    esac
  fi

  # Wait for the JDBC driver to be copied to the lib folder
  while [ ! -f "$driver_file" ]
  do
    echo "${GREEN}==> JDBC driver not found in lib folder, waiting...${RESET}"
    sleep 5
  done

  echo "${GREEN}==> JDBC driver found in lib folder, continuing...${RESET}"
}

# Copy the relevant JDBC driver to the target directory based on the database and OS input
copy_jdbc_driver
