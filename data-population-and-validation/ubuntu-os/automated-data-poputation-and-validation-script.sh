#!/bin/bash

# Define the log file path
log_file="script_execution.log"

# Function to execute a script and log the output
execute_script() {
  local script="$1"
  echo "Running script: $script"
  "./$script" 2>&1 | tee -a "$log_file"
}

# Clear the log file before execution
> "$log_file"

# Execute scripts in order
for script in \
  "1-user-creation/create-user.sh" \
  "1-user-creation/create-bulk-users.sh" \
  "2-tenant-creation/create-tenant.sh" \
  "2-tenant-creation/register-an-app-in-a-tenant.sh" \
  "2-tenant-creation/get-access-token-tenantwise.sh" \
  "3-userstore-creation/create-userstore.sh" \
  "3-userstore-creation/create-user-in-userstore.sh" \
  "4-service-provider-creation/register-a-service-provider.sh" \
  "4-service-provider-creation/create-user-in-a-service-provider.sh" \
  "4-service-provider-creation/get-oauth-token.sh" \
  "5-group-creation/create-group.sh" \
  "5-group-creation/create-groups-with-users.sh"; do
  # Check if script exists and is executable
  if [ -f "$script" ] && [ -x "$script" ]; then
    chmod +x "$script"
    execute_script "$script"
  fi
done

# Execute scripts in any other subdirectories
for dir in */; do
  # Check if directory is not one of the specified ones and exists
  if [ "$dir" != "1-user-creation/" ] && [ "$dir" != "2-tenant-creation/" ] && [ "$dir" != "3-userstore-creation/" ] && [ "$dir" != "4-service-provider-creation/" ] && [ "$dir" != "5-group-creation/" ] && [ -d "$dir" ]; then
    # Execute scripts in subdirectory
    cd "$dir" || exit
    for script in *.sh; do
      # Check if script exists and is executable
      if [ -f "$script" ] && [ -x "$script" ]; then
        execute_script "$script"
      fi
    done
    cd ..
  fi
done




