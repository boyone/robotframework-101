*** Settings ***
Library    FakerLibrary

*** Test Cases ***
Example Faker
    ${company_email}=    Company Email
    Log    ${company_email}
    ${uuid}=    Uuid 4
    Log    ${uuid}
    ${name}=    Name
    Log    ${name}