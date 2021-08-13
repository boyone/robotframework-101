*** Settings ***
Library     DatabaseLibrary

*** Test Cases ***
Check Existing Table
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=localhost     dbPort=1433
    Table Must Exist     products
    Disconnect from Database

Check Existing Product
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=localhost     dbPort=1433
    Check if exists in Database     select id from products where name= 'Scooter'
    Disconnect from Database

Count Row
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=localhost     dbPort=1433
    ${row}      Row Count     select id from products
    Should Be Equal As Integers     8     ${row}
    Disconnect from Database

Query Product
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=localhost     dbPort=1433
    @{row}      Query     select * from products
    Log    ${row}
    Disconnect from Database

Get Table Description
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=localhost     dbPort=1433
    @{rows}      Description     select * from products
    Log Many    @{rows}
    Disconnect from Database