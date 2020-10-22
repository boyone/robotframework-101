*** Settings ***
Suite Setup         Log     This is Suite Setup
Suite Teardown      Log     This is Suite Teardown
Test Setup          Log     This is Test Setup
Test Teardown       Log     This is Test Teardown
Test Template       My Log

*** Test Cases ***
Test Case No. 1     Test Case No. 1

Test Case No. 2     Test Case No. 2

*** Keywords ***
My Log
    [Arguments]    ${message}
    Log    ${message}