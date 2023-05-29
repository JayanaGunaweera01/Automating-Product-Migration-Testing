#!/bin/bash

# Define color variables
GREEN='\033[0;32m\033[1m' # green color
RESET='\033[0m'           # reset color

# Get the value of the inputs
currentVersion="$1"
migratingVersion="$2"
os="$3"

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
  done

  if [ "$migratingVersion" = "6.0.0" ] || [ "$migratingVersion" = "6.1.0" ] || [ "$migratingVersion" = "6.2.0" ]; then
    cd "$MIGRATION_RESOURCES_NEW_IS_UBUNTU"
    chmod +x migration-config.yaml

    # Define the line number to replace
    line_number=394

    # Define the replacement line
    replacement_line='currentEncryptionAlgorithm: "RSA"'

    # Replace the line in the file
    sed -i "${line_number}s/.*/${replacement_line}/" migration-config.yaml

    echo "${GREEN}==> Replaced line 394 in the file with currentEncryptionAlgorithm: \"RSA\".${RESET}"

    echo "${GREEN}==> Replaced the currentEncryptionAlgorithm line in the specified code block.${RESET}"
  fi

  # Check conditions to modify transformToSymmetric (This is a special migration config change when migrating to IS 5.11.0)
  if [ "$migratingVersion" = "5.11.0" ] || [ "$migratingVersion" = "6.0.0" ] || [ "$migratingVersion" = "6.1.0" ] || [ "$migratingVersion" = "6.2.0" ]; then
    cd "$MIGRATION_RESOURCES_NEW_IS_UBUNTU"
    chmod +x migration-config.yaml

    for file in $(find "$MIGRATION_RESOURCES_NEW_IS_UBUNTU" -type f -name 'migration-config.yaml'); do
      sed -i 's~transformToSymmetric:.*~transformToSymmetric: "true"~' "$file"
      echo "Content of migration-config-yaml file:"
      cat "migration-config.yaml"
      echo "${GREEN}==> Value of transformToSymmetric changed to true in migration-config.yaml which is a special migration config change when migrating to versions above IS 5.11.0${RESET}"
      echo "${GREEN}==> Did all the needed changes to migration-config.yaml  successfully.${RESET}"

    done

  fi
fi

if [ "$os" = "macos-latest" ]; then
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
    echo "${GREEN}==> Versions Changed.${RESET}"
  done

  # Define the search pattern for the block of text
  if [ "$migratingVersion" = "6.0.0" ] || [ "$migratingVersion" = "6.1.0" ] || [ "$migratingVersion" = "6.2.0" ]; then
    cd "$MIGRATION_RESOURCES_NEW_IS_MAC"
    chmod +x migration-config.yaml

    for file in $(find "$MIGRATION_RESOURCES_NEW_IS_MAC" -type f -name 'migration-config.yaml'); do
      search_pattern='version: "5.11.0"\n   migratorConfigs:\n   -\n     name: "EncryptionAdminFlowMigrator"\n     order: 1\n     parameters:\n       currentEncryptionAlgorithm: "RSA/ECB/OAEPwithSHA1andMGF1Padding"\n       migratedEncryptionAlgorithm: "AES/GCM/NoPadding"\n       schema: "identity"'

      # Define the replacement line
      replacement_line='       currentEncryptionAlgorithm: "RSA"'
      for file in $(find "$MIGRATION_RESOURCES_NEW_IS_MAC" -type f -name 'migration-config.yaml'); do
        # Find and replace the line within the block of text
        sed -i "s~$search_pattern~$replacement_line~" "$file"
      done
    done
    echo "${GREEN}==> CurrentEncryptionAlgorithm changed to \"RSA\" which is a special migration config change when migrating to versions above IS 5.11.0${RESET}"
  fi

  # Check conditions to modify transformToSymmetric (This is a special migration config change when migrating to IS 5.11.0)
  if [ "$migratingVersion" = "5.11.0" ] || [ "$migratingVersion" = "6.0.0" ] || [ "$migratingVersion" = "6.1.0" ] || [ "$migratingVersion" = "6.2.0" ]; then
    cd "$MIGRATION_RESOURCES_NEW_IS_MAC"
    chmod +x migration-config.yaml
    for file in $(find "$MIGRATION_RESOURCES_NEW_IS_MAC" -type f -name 'migration-config.yaml'); do
      sed -i 's~transformToSymmetric:.*~transformToSymmetric: "true"~' "$file"
      echo "${GREEN}==> Value of transformToSymmetric changed to true in migration-config.yaml which is a special migration config change when migrating to versions above IS 5.11.0${RESET}"
      echo "Content of migration-config-yaml file:"
      cat "migration-config.yaml"
      echo "${GREEN}==> Did all the needed changes to migration-config.yaml  successfully.${RESET}"

    done

  fi
fi
