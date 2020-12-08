*** Settings ***

*** Variables ***
${TEMPLATE}=    {"product_id": \${product_id},"quantity": \${quantity}}
${EXPECTED_VALUE}=    {"product_id": 1,"quantity": 2}
${product_id}=    1

*** Test Cases ***
Set Variables within Test Case Scope Example 
    ${product_id}=    Set Variable    1
    ${quantity}=    Set Variable    2
    ${message}=    Set Variable    {"product_id": ${product_id},"quantity": ${quantity}}
    #${message}=    Replace Variables    ${template}
    Should Be Equal    ${EXPECTED_VALUE}    ${message}

Replace Template Variables in Test Suite Scope Example 
    ${product_id}=    Set Variable    1
    ${quantity}=    Set Variable    2
    ${message}=    Replace Variables    ${TEMPLATE}
    #${message}=    Set Variable    ${TEMPLATE}
    Should Be Equal    ${EXPECTED_VALUE}    ${message}

Replace Template Variables in Test Suite Scope2 Example 
    ${quantity}=    Set Variable    2
    ${message}=    Replace Variables    ${TEMPLATE}
    #${message}=    Set Variable    ${TEMPLATE}
    Should Be Equal    ${EXPECTED_VALUE}    ${message}