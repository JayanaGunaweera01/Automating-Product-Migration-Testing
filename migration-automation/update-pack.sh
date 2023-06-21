#!/bin/bash

email=$1
password=$2
startServer=$3

# Copy update tool from utils to bin folder
cd "/home/runner/work/Automating-Product-Migration-Testing/Automating-Product-Migration-Testing/utils/update-tools"
if [ "$startServer" = "current" ]; then
    cp -r "$UPDATE_TOOL_UBUNTU" "$BIN_ISOLD"
    copy_exit_code=$?
    if [ $copy_exit_code -eq 0 ]; then
        echo "==> Update tool successfully copied to $currentVersion"
    else
        echo "==> Failed to copy the update tool."
    fi
fi

if [ "$startServer" = "migrating" ]; then
    cp -r "$UPDATE_TOOL_UBUNTU" "$BIN_ISNEW"
    copy_exit_code=$?
    if [ $copy_exit_code -eq 0 ]; then
        echo "==> Update tool successfully copied to $currentVersion"
    else
        echo "==> Failed to copy the update tool."
    fi
fi

if [ "$startServer" = "current" ]; then
    cd "$BIN_ISOLD"
fi

if [ "$startServer" = "migrating" ]; then
    cd "$BIN_ISNEW"
fi

sudo apt-get install expect -y

# Set executable permissions for the expect script
chmod +x ./wso2update_linux

# Create an expect script file
cat >wso2update_script.expect <<EOF
#!/usr/bin/expect -f
# Set executable permissions for the expect script
spawn chmod +x ./wso2update_linux
spawn ./wso2update_linux
expect "Please enter your credentials to continue."
sleep 5
send -- "$email\r"
expect "Email:"
sleep 5
send -- "$password\r"
expect {
    "wso2update: Error while authenticating user: Error while authenticating user credentials: Invalid email address '*'" {
        puts "Invalid email address. Please check the MIGRATION_EMAIL environment variable."
        exit 1
    }
    "wso2update: Error while authenticating user: Error while authenticating user credentials: Unable to read input: EOF" {
        puts "Error while authenticating user credentials. Please check the MIGRATION_PASSWORD environment variable."
        exit 1
    }
    eof {
        puts "Updated the Client Tool successfully"
        exit 0
    }
}
EOF

# Set executable permissions for the expect script
chmod +x wso2update_script.expect

# Run the expect script as root
sudo ./wso2update_script.expect

echo "${GREEN}==> Updated the Client Tool successfully${RESET}" &
wait $!

# Update Product Pack
sudo chmod +x ./wso2update_linux
sudo ./wso2update_linux
./wso2update_linux
echo "${GREEN}==> Updated the Product Pack successfully${RESET}" &
wait $!
