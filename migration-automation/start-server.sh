#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

os=$1
version=$2

# Get the value of the inputs

# Setup file and path based on OS and server number
if [ "$os" = "ubuntu-latest" ]; then
  if [ "$version" = "3" ]; then
   cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
   chmod +x env.sh
   . ./env.sh
    echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"
    cd "$IS_OLD_BIN"
    echo "${GREEN}Diverted to bin${RESET}"
    echo "${GREEN}Starting Identity Server in Ubuntu OS${RESET}"
  elif [ "$server_number" == "4" ]; then
    cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
    chmod +x env.sh
   . ./env.sh
    echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"
    cd "$BIN_ISNEW"
    echo "${GREEN}Diverted to bin${RESET}"
    echo "${GREEN}Starting Migrating Identity Server in Ubuntu OS${RESET}"
  fi
elif [ "$1" == "macos-latest" ]; then
  if [ "$2" == "3" ]; then
    cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
    chmod +x env.sh
    source ./env.sh
    echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
    cd "$IS_OLD_BIN_MAC"
    echo "${GREEN}Diverted to bin${RESET}"
    echo "${GREEN}Starting Identity Server in macOS${RESET}"
  elif [ "$server_number" == "4" ]; then
    cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" || exit 1
    chmod +x env.sh
    source ./env.sh
    cd "$BIN_ISNEW_MAC"
    echo "${GREEN}Diverted to bin${RESET}"
    echo "${GREEN}Starting Migrating Identity Server in macOS${RESET}"
  fi
fi

echo "./wso2server.sh -Dcarbon.bootstrap.timeout=300" > start.sh
chmod +x start.sh

# Start the Identity Server in the background
nohup ./start.sh >/dev/null 2>&1 &

# Wait until server is up
is_server_up() {
  local status
  status=$(curl -k -L -s -o /dev/null -w "%{http_code}" --request GET "https://localhost:9443/")
  if [ "$status" -eq 200 ]; then
    return 0
  fi
  return 1
}

wait_until_server_is_up() {
  local timeout=600
  local wait_time=0
  while ! is_server_up; do
    echo "Waiting until the server starts..."
    sleep 10
    wait_time=$((wait_time + 10))
    if [ "$wait_time" -ge "$timeout" ]; then
      echo "Timeout: The server did not start within $timeout seconds"
      exit 1
    fi
  done
}

wait_until_server_is_up
echo "${GREEN}WSO2 Identity Server has started successfully${RESET}"
