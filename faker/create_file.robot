*** Settings ***
Library    OperatingSystem
Library    FakerLibrary    locale=th_TH

*** Test Cases ***
Example
    #Create File    ${EXECDIR}/example.csv    id,name
    ${name}=    Name
    ${ID}=    Ssn
    Append To File    ${EXECDIR}/example.csv    \n"${ID}","${name}"