*** Variables ***
@{list}

*** Test Cases ***

Example Should Be Empty
    Should Be Empty    ${list}

Example Should Be Equal
    Should Be Equal    1    1

Example Should Be Equal As Integers
    Should Be Equal As Integers     1    ${1.0}

Example Should Be Equal As Numbers
    Should Be Equal As Numbers      1.1     1.10
    Should Be Equal As Numbers      1.1     1.103    precision=1
    Should Be Equal As Numbers      1.1     1.403    precision=0
    Should Be Equal As Numbers      123.1     75.103    precision=-2