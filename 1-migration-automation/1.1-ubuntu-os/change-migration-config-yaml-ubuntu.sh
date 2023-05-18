#!/bin/bash

cd "$MIGRATION_RESOURCES_NEW_IS"
chmod +x "$MIGRATION_CONFIG_YAML"

currentVersion="$3"
migratingVersion="$4"

for file in $(find "$MIGRATION_RESOURCES_NEW_IS" -type f -name 'migration-config.yaml');
do
    sed -i "s/\(.*migrationEnable:.*\)/migrationEnable: \"true\"/" "$file"
    sed -i "s/\(.*currentVersion: .*\)/currentVersion: \"$currentVersion\"/" "$file"
    sed -i "s/\(.*migrateVersion: .*\)/migrateVersion: \"$migratingVersion\"/" "$file"
done

# use $currentVersion and $migratingVersion to get URLs
