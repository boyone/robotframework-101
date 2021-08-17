*** Settings ***
Library     DatabaseLibrary

*** Variables ***
${DB_HOST}    localhost
${DB_PORT}    1433

*** Test Cases ***
Check Existing Table
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=${DB_HOST}     dbPort=${DB_PORT}
    Table Must Exist     products
    Disconnect from Database

Check Existing Product
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=${DB_HOST}     dbPort=${DB_PORT}
    Check if exists in Database     select id from products where name= 'Scooter'
    Disconnect from Database

Count Row
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=${DB_HOST}     dbPort=${DB_PORT}
    ${row}      Row Count     select id from products
    Should Be Equal As Integers     9     ${row}
    Disconnect from Database

Query Product
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=${DB_HOST}     dbPort=${DB_PORT}
    @{row}      Query     select * from products
    Log    ${row}
    Disconnect from Database

Get Table Description
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=${DB_HOST}     dbPort=${DB_PORT}
    @{rows}      Description     select * from products
    Log Many    @{rows}
    Disconnect from Database