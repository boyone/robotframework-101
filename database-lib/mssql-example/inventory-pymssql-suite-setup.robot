*** Settings ***
Library     DatabaseLibrary
Suite Setup     Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=localhost     dbPort=1433
Suite Teardown      Disconnect from Database

*** Test Cases ***
Check Existing Table
    Table Must Exist     products

Check Existing Product    
    Check if exists in Database     select id from products where name= 'Scooter'

Count Row
    ${row}      Row Count     select id from products
    Should Be Equal As Integers     8     ${row}

Query Product
    @{row}      Query     select * from products
    Log    ${row}

Get Table Description
    @{rows}      Description     select * from products
    Log Many    @{rows}