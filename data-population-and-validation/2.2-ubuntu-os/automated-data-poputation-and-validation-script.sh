#!/bin/bash

# execute scripts in order
for script in \
"00-1user-creation/create-user.sh" \
"00-1user-creation/create-bulk-users.sh" \
"00-2tenant-creation/create-tenant.sh" \
"00-2tenant-creation/register-an-app-in-a-tenant.sh" \
"00-2tenant-creation/get-access-token-tenantwise.sh" \
"00-3userstore-creation/create-userstore.sh" \
"00-3userstore-creation/create-user-in-userstore.sh" \
"00-4service-provider-creation/register-a-service-provider.sh" \
"00-4service-provider-creation/create-user-in-a-service-provider.sh" \
"00-4service-provider-creation/get-oauth-token.sh" \
"00-5group-creation/create-group.sh" \
"00-5group-creation/create-groups-with-users.sh"; do
  # check if script exists and is executable
  if [ -f "$script" ] && [ -x "$script" ]; then
    echo "Running script: $script"
    # execute script and redirect output to console and file
    "./$script" | tee -a /home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/logs.txt
  fi
done

# execute scripts in any other subdirectories
for dir in */; do
  # check if directory is not one of the specified ones and exists
  if [ "$dir" != "00-1user-creation/" ] && [ "$dir" != "00-2tenant-creation/" ] && [ "$dir" != "00-3userstore-creation/" ] && [ "$dir" != "00-4service-provider-creation/" ] && [ "$dir" != "00-5group-creation/" ] && [ -d "$dir" ]; then
    # execute scripts in subdirectory
    cd "$dir" || exit
    for script in *.sh; do
      # check if script exists and is executable
      if [ -f "$script" ] && [ -x "$script" ]; then
        echo "Running script: $script"
        # execute script and redirect output to console and file
        "./$script" | tee -a /home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/migration-automation/logs.txt
      fi
    done
    cd ..
  fi
done

