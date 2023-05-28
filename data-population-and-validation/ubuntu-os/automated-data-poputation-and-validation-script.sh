#!/bin/bash

data_population_dir="/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/ubuntu-os"

echo "Running data population scripts"
if [ -d "$data_population_dir" ]; then
  cd "$data_population_dir" || { echo "Failed to change directory."; exit 1; }

  # execute scripts in order
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
    # construct the full path of the script
    script_path="$data_population_dir/$script"

    # check if script exists and is executable
    if [ -f "$script_path" ]; then
      chmod +x "$script_path"  # make the script executable
      printf "Running script: %s\n" "$script_path"
      # execute script and redirect output to stdout
      "$script_path" >&1
    else
      echo "Script '$script_path' does not exist."
    fi
  done
else
  echo "Directory '$data_population_dir' does not exist."
fi

# execute scripts in any other subdirectories
for dir in */; do
  # check if directory is not one of the specified ones and exists
  if [ "$dir" != "1-user-creation/" ] && [ "$dir" != "2-tenant-creation/" ] && [ "$dir" != "3-userstore-creation/" ] && [ "$dir" != "4-service-provider-creation/" ] && [ "$dir" != "5-group-creation/" ] && [ -d "$dir" ]; then
    # execute scripts in subdirectory
    cd "$dir" || exit
    for script in *.sh; do
      # check if script exists and is executable
      if [ -f "$script" ] && [ -x "$script" ]; then
        echo "Running script: $script"
        # execute script and redirect output to console
        "./$script" >/dev/tty
      fi
    done
    cd ..
  fi
done
