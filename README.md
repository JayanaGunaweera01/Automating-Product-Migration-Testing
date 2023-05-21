
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

Feel free to explore each directory to find more details about the specific components and scripts.

## Getting Started

Configure the necessary environment variables:

- Open the .env file in the root directory.

- Update the required environment variables according to your setup.

Execute the migration automation scripts:

- Navigate to https://github.com/JayanaGunaweera01/Automating-Product-Migration-Testing/actions/workflows/MainMigrationWorkflow.yml 

- Get urls of wso2 identity server releases from : https://github.com/wso2/product-is/releases

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





