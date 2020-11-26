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

Examlple Should Match Regexp
    Should Match Regexp	   123456    \\d{6}	# Output contains six numbers
    Should Match Regexp	   123456    ^\\d{6}$	# Six numbers and nothing more
    Should Match Regexp	   AB12345    ^\\w{2}\\d{5}$
    Should Match Regexp	   AB12345    ^[A-Z]{2}\\d{5}$
    Should Match Regexp	   A12345    ^[A-Z]{1,2}\\d{5}$
    Should Match Regexp	   AB12345    ^[A-Z]{1,2}\\d{5}$
    Should Match Regexp    1/3/2020 13:30:00    ^\\d{1,2}/\\d{1,2}/\\d{4} \\d{2}:\\d{2}:\\d{2}$
    Should Match Regexp    1/3/2020 13:30:00    ^\\d{1,2}/\\d{1,2}/\\d{4} \\d{2}:\\d{2}:\\d{2}$