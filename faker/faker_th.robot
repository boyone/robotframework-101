*** Settings ***
#Library    FakerLibrary    locale=th_TH    #seed=0

*** Test Cases ***
Example Faker TH
    #Init    locale=th_TH    seed=0
    # Add Provider    providers=person
    Import Library    FakerLibrary    th_TH
    ${name}=    Name
    Log    ${name}
    ${ID}=    Ssn
    Log    ${ID}