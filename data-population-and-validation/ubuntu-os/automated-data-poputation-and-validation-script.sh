#!/bin/bash

echo "Running data population scripts"
# execute scripts in order
for script in \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/create-user.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/create-bulk-users.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/create-tenant.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/register-an-app-in-a-tenant.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/get-access-token-tenantwise.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/create-userstore.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/create-user-in-userstore.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/register-a-service-provider.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/create-user-in-a-service-provider.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/get-oauth-token.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/create-group.sh" \
  "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/data-population-and-validation/1-user-creation/ubuntu-os/create-groups-with-users.sh"; do
  # check if script exists and is executable
  if [ -f "$script" ]; then
    if [ -x "$script" ]; then
      chmod +x "$script"
      printf "Running script: %s\n" "$script"
      # execute script and redirect output to stdout
      "./$script" >&1
    else
      echo "Script '$script' is not executable."
    fi
  else
    echo "Script '$script' does not exist."
  fi
done

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
