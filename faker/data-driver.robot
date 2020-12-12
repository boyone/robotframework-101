*** Settings ***
Library    DataDriver    file=./example-data-driver-${env}.csv    dialect=unix    encoding='utf-8'
Test Template    Logg

*** Variables ***
${env}    dev

*** Test Cases ***
Log from csv    0    default

*** Keywords ***
Logg
    [Arguments]    ${id}    ${name}
    Log    ${id}: ${name}