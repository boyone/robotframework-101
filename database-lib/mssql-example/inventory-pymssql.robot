*** Settings ***
Library     DatabaseLibrary

*** Test Cases ***
Check Existing Product
    Connect to Database    dbapiModuleName=pymssql    dbName=inventory  dbUsername=sa   dbPassword=myP@ssw0rd     dbHost=localhost     dbPort=1433
    Check if exists in Database     select id from products where name= 'Scooter'
    Disconnect from Database