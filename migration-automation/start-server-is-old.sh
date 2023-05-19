#!/bin/bash

# Breakdown this script into several scripts and reuse those without having 2 scripts as old and new 

# Source env file
. ./env.sh
echo "\033[0;32m\033[1mEnv file sourced successfully\033[0;m"

# Define color variables
GREEN='\033[0;32m\033[1m' # green color

cd "$IS_OLD_BIN"
echo "${GREEN}Diverted to bin${RESET}"

echo "./wso2server.sh -Dcarbon.bootstrap.timeout=300" > start.sh
chmod +x start.sh && chmod 777 start.sh
nohup ./start.sh &

# Wait until server is up
is_server_up() {
    local status
    status=$(curl -k -L -s \
        -o /dev/null \
        -w "%{http_code}" \
        --request GET \
        "https://localhost:9443/")
    if [ "$status" -eq 200 ]; then
        return 0
    fi
    return 1
}

wait_until_server_is_up() {
    local timeout=600
    local wait_time=0
    while ! is_server_up; do
        echo "Waiting until server starts..." &&
        sleep 10
        wait_time=$((wait_time+10))
        if [ "$wait_time" -ge "$timeout" ]; then
            echo "Timeout: server did not start within $timeout seconds"
            exit 1
        fi
    done
}

wait_until_server_is_up
echo "${GREEN}WSO2 Identity Server has started successfully${RESET}"



