# Database Library

## Setup Database

- [Setup MsSql Server](./setup-mssql-server.md)

## Install Database Library

```sh
pip install -U robotframework-databaselibrary
```

or

```
python3 -m pip install -U robotframework-databaselibrary
```

- References:
  - [https://franz-see.github.io/Robotframework-Database-Library/](https://franz-see.github.io/Robotframework-Database-Library/)

## A Database API Specification 2.0 Python Module

General Purpose Database Systems

- [MySQL](https://wiki.python.org/moin/MySQL)
- [PostgreSQL](https://wiki.python.org/moin/PostgreSQL)
- [Microsoft SQL Server](https://wiki.python.org/moin/SQL%20Server)

  - [pymssql](http://pymssql.org/)

    ```sh
    pip install pymssql
    ```

  - [pyodbc](https://github.com/mkleehammer/pyodbc)

    - [Download ODBC Driver for SQL Server](https://docs.microsoft.com/en-us/sql/connect/odbc/microsoft-odbc-driver-for-sql-server?view=sql-server-ver15)

      - [windows](https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver15)
      - [linux](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15)
      - [mac](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver15)

        ```sh
        softwareupdate --all --install --force
        ```

    - Install pyodbc

      ```sh
      pip install pyodbc
      ```

- References:
  - [https://wiki.python.org/moin/DatabaseInterfaces](https://wiki.python.org/moin/DatabaseInterfaces)
  - [https://docs.microsoft.com/en-us/sql/connect/python/python-driver-for-sql-server?view=sql-server-ver15#getting-started](https://docs.microsoft.com/en-us/sql/connect/python/python-driver-for-sql-server?view=sql-server-ver15#getting-started)

## Keywords

[Library Keywords](https://franz-see.github.io/Robotframework-Database-Library/api/1.2.2/DatabaseLibrary.html)

Call Stored Procedure · Check If Exists In Database · Check If Not Exists In Database · Connect To Database · Connect To Database Using Custom Params · Delete All Rows From Table · Description · Disconnect From Database · Execute Sql Script · Execute Sql String · Query · Row Count · Row Count Is 0 · Row Count Is Equal To X · Row Count Is Greater Than X · Row Count Is Less Than X · Set Auto Commit · Table Must Exist

## Example Test Cases

- Setup
- Action
- Verify
- Teardown

```robot
*** Settings ***
Library     DatabaseLibrary # Setup

*** Test Cases ***
Check Existing Product
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=localhost     dbPort=1433  # Setup
    Check if exists in Database     select id from products where name= 'Scooter' # Action, Verify
    Disconnect from Database # Teardown
```

### Run robot

```sh
robot <filename>.robot
```

- example

  ```sh
  robot inventory-pymssql.robot
  ```

### Run robot with `variables`

```sh
robot -v <variable-name>:<value> <filename>.robot
```

- example

  ```sh
  robot -v DB_HOST:localhost -v DB_PORT:1433 inventory-pymssql-variables.robot
  ```

### Run robot with `tags`

```sh
robot --include <tag-name> <filename>.robot
```

- example

  ```sh
  robot --include smoke-testing inventory-pymssql-tags.robot
  ```

## 3 A Structure

1. Arrange
2. Act
3. Assert
