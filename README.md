
# 🪄Automating-Product-Migration-Testing
:small_blue_diamond: A migration client is provided to handle the WSO2 Identity Server migration between different product versions.

:small_blue_diamond: The client needs to be tested manually when we do a new release with different infrastructure combinations such as database and OS.

:small_blue_diamond: We can reduce that overhead by automating the migration client test execution.:v:

## Workflow Status

[![Workflow Status](https://github.com/JayanaGunaweera01/Automating-Product-Migration-Testing/actions/workflows/.github/workflows/MainMigrationWorkflow.yml/badge.svg)](https://github.com/JayanaGunaweera01/Automating-Product-Migration-Testing/actions)


## Repository Structure

This repository contains automation scripts and tools for automating product migration testing.

It is organized into the following directories:

- .github/workflows: Contains GitHub Actions workflows for CI/CD.
- data-population-and-validation: Scripts for data population and validation.
- documents: Documentation files related to the project.
- local-setups: Scripts and configurations for setting up the local environment.
- migration-automation: Scripts and utilities for automating product migration testing.
- utils: Utility scripts and helper functions.

## Directory Structure

```

Automating-Product-Migration-Testing
├── .github
│   └── workflows
│       └── MainMigrationWorkflow.yml
├── data-population-and-validation
│   ├── mac-os
│   │   ├── 1-user-creation
│   │   ├── 2-tenant-creation
│   │   ├── 3-userstore-creation
│   │   ├── 4-service-provider-creation
│   │   ├── 5-group-creation
│   │   └── data-population-script.sh
│   ├── ubuntu-os
│   │   ├── 1-user-creation
│   │   ├── 2-tenant-creation
│   │   ├── 3-userstore-creation
│   │   ├── 4-service-provider-creation
│   │   ├── 5-group-creation
│   │   └── data-population-script.sh
│   └── windows-os
│       ├── 1-user-creation
│       ├── 2-tenant-creation
│       ├── 3-userstore-creation
│       ├── 4-service-provider-creation
│       ├── 5-group-creation
│       └── data-population-script.sh
├── documents
│   └── Automating Product Migration Testing.word
├── local-setups
│   ├── mac-os
│   │   ├── change-deployment-toml-mac.sh
│   │   ├── change-migration-config-yaml-mac.sh
│   │   ├── copy-jar-file-mac.sh
│   │   ├── migration-script-mac.sh
│   │   └── setup-mysql-mac.sh
│   ├── ubuntu-os
│   │   ├── change-deployment-toml-ubuntu-new.sh
│   │   ├── change-deployment-toml-ubuntu.sh
│   │   ├── change-migration-config-yaml-ubuntu.sh
│   │   ├── copy-jar-file-ubuntu.sh
│   │   ├── migration-script-ubuntu.sh
│   │   └── setup-mysql-ubuntu.sh
│   └── windows-os
│       ├── change-deployment-toml-windows.ps1
│       ├── change-migration-config-yaml-windows.ps1
│       ├── migration-script-windows.ps1
│       ├── enter-login-credentials.sh
│       ├── env.sh
│       ├── logs.txt
│       ├── setup-mysql.sh
│       ├── start-server-is-new.sh
│       └── start-server-is-old.sh
├── migration-automation
│   ├── deployment-tomls
│   │   ├── IS-5.10
│   │   │   ├── deployment-mssql.toml
│   │   │   ├── deployment-mysql.toml
│   │   │   └── deployment-postgre.toml
│   │   ├── IS-5.11
│   │   │   ├── deployment-mssql.toml
│   │   │   ├── deployment-mysql.toml
│   │   │   └── deployment-postgre.toml
│   │   ├── IS-5.9
│   │   │   ├── deployment-mssql.toml
│   │   │   ├── deployment-mysql.toml
│   │   │   └── deployment-postgre.toml
│   │   ├── IS-6.0
│   │   │   ├── deployment-mssql.toml
│   │   │   ├── deployment-mysql.toml
│   │   │   └── deployment-postgre.toml
│   │   ├── IS-6.1
│   │   │   ├── deployment-mssql.toml
│   │   │   ├── deployment-mysql.toml
│   │   │   └── deployment-postgre.toml
│   │   └── IS-6.2
│   │       ├── deployment-mssql.toml
│   │       ├── deployment-mysql.toml
│   │       └── deployment-postgre.toml
│   ├── mac-os
│   │   ├── change-deployment-toml-mac.sh
│   │   ├── change-migration-config-yaml-mac.sh
│   │   ├── copy-jar-file-mac.sh
│   │   ├── migration-script-mac.sh
│   │   └── setup-mysql-mac.sh
│   ├── ubuntu-os
│   │   ├── change-deployment-toml-ubuntu-new.sh
│   │   ├── change-deployment-toml-ubuntu.sh
│   │   ├── change-migration-config-yaml-ubuntu.sh
│   │   ├── copy-jar-file-ubuntu.sh
│   │   ├── migration-script-ubuntu.sh
│   │   └── setup-mysql-ubuntu.sh
│   └── windows-os
│       ├── change-deployment-toml-windows.ps1
│       ├── change-migration-config-yaml-windows.ps1
│       ├── migration-script-windows.ps1
│       ├── enter-login-credentials.sh
│       ├── env.sh
│       ├── logs.txt
│       ├── setup-mysql.sh
│       ├── start-server-is-new.sh
│       └── start-server-is-old.sh
├── db-scripts
│   ├── IS-5.11
│   │   ├── database-create-scripts
│   │   └── deployment-mssql.toml
│   └── IS-5.9
│       ├── database-create-scripts
│       └── deployment-mssql.toml
├── jars
│   ├── mssql
│   │   ├── mssql-jdbc-12.2.0.jre11.jar
│   │   ├── mssql-jdbc-12.2.0.jre8.jar
│   │   └── mssql-jdbc-9.2.0.jre8.jar
│   ├── mysql
│   │   └── mysql-connector-java-8.0.29.jar
│   └── postgresql
│       └── postgresql-42.5.3.jar
└── migration-client
    └── wso2is-migration-1.0.225.zip

├── LICENSE
└── README.md

```

- `.github/workflows`:
  - Contains the workflow file `MainMigrationWorkflow.yml`, which defines the main migration workflow for the repository.

- `data-population-and-validation`:
  - Contains subdirectories for different operating systems: `mac-os`, `ubuntu-os`, and `windows-os`.
  - Each OS directory includes scripts for data population and validation, such as user creation, tenant creation, user store creation, service provider creation, and group creation.
  - Additionally, the directory includes a common script named `data-population-script.sh` for data population.

- `documents`:
  - Contains the document file `Automating Product Migration Testing.word`, which likely provides documentation or instructions related to automating product migration testing.

- `local-setups`:
  - Contains subdirectories for different operating systems: `mac-os`, `ubuntu-os`, and `windows-os`.
  - Each OS directory includes setup scripts specific to that operating system, such as changing deployment toml files, migration configuration YAML files, copying jar files, migration scripts, and MySQL setup scripts.

- `migration-automation`:
  - Contains subdirectories for different operating systems: `mac-os`, `ubuntu-os`, and `windows-os`.
  - Each OS directory includes scripts specific to that operating system for migration automation, such as changing deployment toml files, changing migration configuration YAML files, copying jar files, migration scripts, and MySQL setup scripts.
  - The `deployment-tomls` directory includes subdirectories for different versions of the migration target (e.g., IS-5.10, IS-5.11) and respective deployment toml files for MSSQL, MySQL, and Postgre databases.

- `db-scripts`:
  - Contains subdirectories for different versions of the migration target (e.g., IS-5.11, IS-5.9) and respective subdirectories for database create scripts.
  - Additionally, the directory includes deployment toml files for MSSQL databases.

- `jars`:
  - Contains subdirectories for different database types: `mssql`, `mysql`, and `postgresql`.
  - The `mssql` directory includes multiple jar files for MSSQL database connectivity.
  - The `mysql` directory includes the `mysql-connector-java-8.0.29.jar` file for MySQL database connectivity.
  - The `postgresql` directory includes the `postgresql-42.5.3.jar` file for PostgreSQL database connectivity.

- `migration-client`:
  - Contains the `wso2is-migration-1.0.225.zip` file, which represents a migration client for performing specific migration tasks.

- `LICENSE`:
  - Represents the license file (`LICENSE`) for the repository, which is Apache License 2.0.

- `README.md`:
  - Represents the readme file (`README.md`) for the repository, which provides information about the project, its purpose, and instructions for usage or contribution.

Feel free to explore each directory to find more details about the specific components and scripts.

## Getting Started

Configure the necessary environment variables:

- Open the .env file in the root directory.

- Update the required environment variables according to your setup.

Execute the migration automation scripts:

- Get urls of wso2 identity server releases from : https://github.com/wso2/product-is/releases

- Navigate to https://github.com/JayanaGunaweera01/Automating-Product-Migration-Testing/actions/workflows/MainMigrationWorkflow.yml 

- Execute the main migration workflow with your inputs.

- Follow the on-screen prompts to proceed with the migration testing.

- Get the artifacts and test the migration.


## Technologies and Tools Used

- wso2 Identity Server versions - 5.9.0, 5.10.0, 5.11.0, 6.0.0, 6.1.0, 6.2.0
- wso2 migration client version - wso2is-migration-1.0.225.zip
- wso2 REST APIs
- wso2 SOAP APIs
- Bash Scripting
- Docker
- Git
- Github Actions
- Curl
- Powershell
- Home Brew
- Java 11 Temurin
- Dbeaver
- Meld
- VsCode
- SoapUI 5.7.0.desktop
- Keystore Explorer
- Postman
- Mysql version - 8  (JAR - mysql-connector-java-8.0.29.jar)
- Mssql version - 12 (JAR - mssql-jdbc-12.2.0.jre11.jar)
- Posgresql version - 42 (JAR - postgresql-42.5.3.jar)


## License

This project is licensed under the MIT License.





