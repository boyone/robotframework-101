*** Settings ***
Library     RequestsLibrary
Library     Collections
Suite Setup    Create Session    ${toy_store}      ${URL}
Suite Teardown    Delete All Sessions
Test Template    Checkout Product
Resource     ./resources.robot

*** Test Cases ***
Diner Set    43 Piece dinner Set    1    14.95
Bicycle      Balance Training Bicycle    2    241.90
