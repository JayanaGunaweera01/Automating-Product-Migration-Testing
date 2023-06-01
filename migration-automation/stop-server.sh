#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
os=$1
server_number=$2

# Setup file and path based on OS
if [ "$os" = "ubuntu-latest" ]; then
  cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
  chmod +x env.sh
   . ./env.sh
  echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"

elif [ "$os" = "macos-latest" ]; then
  cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" 
  chmod +x env.sh
  source ./env.sh
  echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
fi

# Setup file and path based on OS and server number
if [ "$os" = "ubuntu-latest" ]; then
  if [ "$server_number" = "3" ]; then
    cd "$IS_OLD_BIN"
    echo "${GREEN}Diverted to bin${RESET}"
    echo "${GREEN}Stopping Identity Server in Ubuntu OS${RESET}"
  elif [ "$server_number" = "4" ]; then
    cd "$BIN_ISNEW"
    echo "${GREEN}Diverted to bin${RESET}"
    echo "${GREEN}Shutting down Migrating Identity Server in Ubuntu OS${RESET}"
  fi
elif [ "$os" = "macos-latest" ]; then
  if [ "$server_number" = "3" ]; then
    cd "$IS_OLD_BIN_MAC"
    echo "${GREEN}Diverted to bin${RESET}"
    echo "${GREEN}Stopping Identity Server in macOS${RESET}"
  elif [ "$server_number" = "4" ]; then
    cd "$BIN_ISNEW_MAC"
    echo "${GREEN}Diverted to bin${RESET}"
    echo "${GREEN}Shutting down Migrating Identity Server in macOS${RESET}"
  fi
fi

# Execute the server stop command
./wso2server.sh stop

# Wait for the server to fully stop
is_stopped=false
while [ "$is_stopped" != true ]; do
    # Check if the server is still running
    status=$(ps -ef | grep "wso2server" | grep -v "grep")
    if [ -z "$status" ]; then
        is_stopped=true
    else
        # Sleep for a few seconds and check again
        sleep 5
        echo "${GREEN}==> Shutting down the current identity server${RESET}"
    fi
done

# Verify that the server is fully stopped
is_running=false
while [ "$is_running" != true ]; do
    # Check if the server is running
    status=$(ps -ef | grep "wso2server" | grep -v "grep")
    if [ -z "$status" ]; then
        is_running=true
    else
        # Sleep for a few seconds and check again
        sleep 5
    fi
    echo "${GREEN}==> Halted the wso2 IS server successfully${RESET}"
done
