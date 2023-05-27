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
  echo "${GREEN}==> Env file for Ubuntu sourced successfully${RESET}"
  cd "$MIGRATION_RESOURCES_NEW_IS_UBUNTU"
  chmod +x "$MIGRATION_CONFIG_YAML_UBUNTU"

  for file in $(find "$MIGRATION_RESOURCES_NEW_IS_UBUNTU" -type f -name 'migration-config.yaml'); do
    sed -i "s/\(.*migrationEnable:.*\)/migrationEnable: \"true\"/" "$file"
    sed -i "s/\(.*currentVersion: .*\)/currentVersion: \"$currentVersion\"/" "$file"
    sed -i "s/\(.*migrateVersion: .*\)/migrateVersion: \"$migratingVersion\"/" "$file"
    echo "${GREEN}==> Versions Changed.${RESET}"

    # Define the search pattern for the block of text
    if [ "$currentVersion" = "5.9.0" || "$currentVersion" = "5.10.0" || "$currentVersion" = "5.11.0" || "$currentVersion" = "6.0.0" || "$currentVersion" = "6.1.0" || "$currentVersion" = "6.2.0" ] && [ "$migratingVersion" = "6.0.0" || "$migratingVersion" = "6.1.0" || "$migratingVersion" = "6.2.0" ]; then
      search_pattern='version: "5.11.0"\n   migratorConfigs:\n   -\n     name: "EncryptionAdminFlowMigrator"\n     order: 1\n     parameters:\n       currentEncryptionAlgorithm: "RSA/ECB/OAEPwithSHA1andMGF1Padding"\n       migratedEncryptionAlgorithm: "AES/GCM/NoPadding"\n       schema: "identity"'

      # Define the replacement line
      replacement_line='       currentEncryptionAlgorithm: "RSA"'

      # Find and replace the line within the block of text
      sed -i "/$search_pattern/{n;n;n;n;n;s/.*/$replacement_line/}" "$file"
      echo "${GREEN}==> CurrentEncryptionAlgorithm changed to \"RSA\" which is a special migration config change when migrating to versions above IS 5.11.0${RESET}"
    fi

    # Check conditions to modify transformToSymmetric (This is a special migration config change when migrating to IS 5.11.0)
    if [ "$currentVersion" = "5.9.0" || "$currentVersion" = "5.10.0" || "$currentVersion" = "5.11.0" || "$currentVersion" = "6.0.0" || "$currentVersion" = "6.1.0" || "$currentVersion" = "6.2.0" ] && [ "$migratingVersion" = "5.11.0" || "$migratingVersion" = "6.0.0" || "$migratingVersion" = "6.1.0" || "$migratingVersion" = "6.2.0" ]; then
      sed -i 's/transformToSymmetric:.*/transformToSymmetric: "true"/' "$file"
      echo "${GREEN}==> Value of transformToSymmetric changed to true in migration-config.yaml which is a special migration config change when migrating to versions above IS 5.11.0${RESET}"
    fi
  done
fi

elif [ "$os" = "macos-latest" ]; then
  cd "/Users/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation"
  chmod +x env.sh
  source ./env.sh
  echo -e "${GREEN}==> Env file for Mac sourced successfully${RESET}"
  cd "$MIGRATION_RESOURCES_NEW_IS_MAC"
  chmod +x "$MIGRATION_CONFIG_YAML_MAC"

  for file in $(find "$MIGRATION_RESOURCES_NEW_IS_MAC" -type f -name 'migration-config.yaml'); do
    sed -i "s/\(.*migrationEnable:.*\)/migrationEnable: \"true\"/" "$file"
    sed -i "s/\(.*currentVersion: .*\)/currentVersion: \"$currentVersion\"/" "$file"
    sed -i "s/\(.*migrateVersion: .*\)/migrateVersion: \"$migratingVersion\"/" "$file"

    # Define the search pattern for the block of text
    if [ "$currentVersion" = "5.9.0" || "$currentVersion" = "5.10.0" || "$currentVersion" = "5.11.0" || "$currentVersion" = "6.0.0" || "$currentVersion" = "6.1.0" || "$currentVersion" = "6.2.0" ] && [ "$migratingVersion" = "6.0.0" || "$migratingVersion" = "6.1.0" || "$migratingVersion" = "6.2.0" ]; then
      search_pattern='version: "5.11.0"\n   migratorConfigs:\n   -\n     name: "EncryptionAdminFlowMigrator"\n     order: 1\n     parameters:\n       currentEncryptionAlgorithm: "RSA/ECB/OAEPwithSHA1andMGF1Padding"\n       migratedEncryptionAlgorithm: "AES/GCM/NoPadding"\n       schema: "identity"'

      # Define the replacement line
      replacement_line='       currentEncryptionAlgorithm: "RSA"'

      # Find and replace the line within the block of text
      sed -i "/$search_pattern/{n;n;n;n;n;s/.*/$replacement_line/}" "$file"
      echo "${GREEN}==> CurrentEncryptionAlgorithm changed to \"RSA\" which is a special migration config change when migrating to to versions above IS 5.11.0${RESET}"
    fi

    # Check conditions to modify transformToSymmetric (This is a special migration config change when migrating to IS 5.11.0)
    if [ "$currentVersion" = "5.9.0" || "$currentVersion" = "5.10.0" || "$currentVersion" = "5.11.0" || "$currentVersion" = "6.0.0" || "$currentVersion" = "6.1.0" || "$currentVersion" = "6.2.0" ] && [ "$migratingVersion" = "5.11.0" || "$migratingVersion" = "6.0.0" || "$migratingVersion" = "6.1.0" || "$migratingVersion" = "6.2.0" ]; then
      sed -i 's/transformToSymmetric:.*/transformToSymmetric: "true"/' "$file"
      echo "${GREEN}==> Value of transformToSymmetric changed to true in migration-config.yaml which is a special migration config change when migrating to versions above IS 5.11.0${RESET}"
    fi
  done
fi
