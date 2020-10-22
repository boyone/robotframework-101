*** Settings ***

*** Variables ***
@{list}    Hello    World
*** Test Cases ***
List Variable
    Print    @{list}
    Print List  @{list}

*** Keywords ***
Print
    [Arguments]    ${arg1}    ${arg2}
    Log     ${arg1} ${arg2}

Print List
    [Arguments]     @{arg}
    Log    ${arg}
    Log Many    @{arg}