# Define color variables
$GREEN = "`033[0;32m`033[1m" # green color
$RESET = "`033[0m" # reset color

# Get the value of the inputs
$currentVersion = $env:INPUT_CURRENTVERSION
$database = $env:INPUT_DATABASE
$os = $env:INPUT_OS

# Source env file                   methana path eka pwsh widiyata denna
& chmod +x env.sh
. ./env.sh
Write-Host "==> $GREEN`Env file sourced successfully$RESET"

# Function to perform cat operation based on conditions
function Perform-Cat {
    param (
        [string]$cat_file,
        [string]$deployment_file
    )

    if ($database -eq "mysql" -and $os -eq "ubuntu" -and $currentVersion -eq $cat_file) {
        Get-Content -Path "$DEPLOYMENT_AUTOMATION_MYSQL_WINDOWS_IS_$cat_file" | Set-Content -Path $deployment_file
    }
    elseif ($database -eq "mssql" -and $os -eq "ubuntu" -and $currentVersion -eq $cat_file) {
        Get-Content -Path "$DEPLOYMENT_AUTOMATION_MSSQL_WINDOWS_IS_$cat_file" | Set-Content -Path $deployment_file
    }
    elseif ($database -eq "postgres" -and $os -eq "ubuntu" -and $currentVersion -eq $cat_file) {
        Get-Content -Path "$DEPLOYMENT_AUTOMATION_POSTGRE_WINDOWS_IS_$cat_file" | Set-Content -Path $deployment_file
    }
}

# Iterate over deployment files
Get-ChildItem -Path $DEPLOYMENT_PATH -Recurse -Filter 'deployment.toml' | ForEach-Object {
    $file = $_.FullName
    Perform-Cat "5.9" $file
    Perform-Cat "5.10" $file
    Perform-Cat "5.11" $file
    Perform-Cat "6.0" $file
    Perform-Cat "6.1" $file
    Perform-Cat "6.2" $file
}
