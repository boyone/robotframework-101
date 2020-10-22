*** Settings ***
Library    Number.py

*** Test Cases ***
Add Number
    ${result}=    Add    ${3}    ${5}
    Should Be Equal    ${result}   ${8}
    Hello   boyone