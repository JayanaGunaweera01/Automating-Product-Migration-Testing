#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
database=$5
os=$6

# Modify the JDBC driver path based on the database
if [ "$database" = "mssql" ]; then
  jdbc_driver="$JAR_MSSQL"
elif [ "$database" = "postgres" ]; then
  jdbc_driver="$JAR_POSTGRE"
else
  jdbc_driver="$JAR_MYSQL"
fi

# Copy the JDBC driver to the target directory
cp -r "$jdbc_driver" "$LIB"

# Wait for the JDBC driver to be copied to the lib folder
while [ ! -f "$jdbc_driver" ]; do
  echo "${GREEN}==> JDBC driver not found in lib folder, waiting...${RESET}"
  sleep 5
done
echo "${GREEN}==> JDBC driver found in lib folder, continuing...${RESET}"
