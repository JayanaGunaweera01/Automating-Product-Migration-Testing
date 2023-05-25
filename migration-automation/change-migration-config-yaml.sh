#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
currentVersion="$1"
migratingVersion="$2"
os="$3"

# Setup file and path based on OS
if [ "$os" = "ubuntu-latest" ]; then
  cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
  chmod +x env.sh
  . ./env.sh
  echo -e "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"
  cd "$MIGRATION_RESOURCES_NEW_IS"
  chmod +x "$MIGRATION_CONFIG_YAML"

  for file in $(find "$MIGRATION_RESOURCES_NEW_IS" -type f -name 'migration-config.yaml'); do
    sed -i "s/\(.*migrationEnable:.*\)/migrationEnable: \"true\"/" "$file"
    sed -i "s/\(.*currentVersion: .*\)/currentVersion: \"$currentVersion\"/" "$file"
    sed -i "s/\(.*migrateVersion: .*\)/migrateVersion: \"$migratingVersion\"/" "$file"
    
    # Check conditions to modify transformToSymmetric (This is a special migration config change when migrating to IS 5.11.0)
    if [[ "$currentVersion" == "5.9.0" || "$currentVersion" == "5.10.0" ]] && [ "$migratingVersion" = "5.11.0" ]; then
      sed -i 's/transformToSymmetric:.*/transformToSymmetric: "true"/' "$file"
      echo "${GREEN}==> Value of transformToSymmetric changed to true in migration-config.yaml which is a is a special migration config change when migrating to IS 5.11.0${RESET}"
    fi
  done

elif [ "$os" = "macos-latest" ]; then
  cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation" 
  chmod +x env.sh
  source ./env.sh
  echo "${GREEN}==> Env file for Mac sourced successfully${RESET}"
  cd "$MIGRATION_RESOURCES_NEW_IS_MAC"
  chmod +x "$MIGRATION_CONFIG_YAML_MAC"

  for file in $(find "$MIGRATION_RESOURCES_NEW_IS_MAC" -type f -name 'migration-config.yaml'); do
    sed -i "s/\(.*migrationEnable:.*\)/migrationEnable: \"true\"/" "$file"
    sed -i "s/\(.*currentVersion: .*\)/currentVersion: \"$currentVersion\"/" "$file"
    sed -i "s/\(.*migrateVersion: .*\)/migrateVersion: \"$migratingVersion\"/" "$file"
    
    # Check conditions to modify transformToSymmetric (This is a special migration config change when migrating to IS 5.11.0)
    if [[ "$currentVersion" == "5.9.0" || "$currentVersion" == "5.10.0" ]] && [ "$migratingVersion" = "5.11.0" ]; then
      sed -i 's/transformToSymmetric:.*/transformToSymmetric: "true"/' "$file"
      echo "${GREEN}==> Value of transformToSymmetric changed to true in migration-config.yaml which is a is a special migration config change when migrating to IS 5.11.0${RESET}"
    fi
  done
fi
