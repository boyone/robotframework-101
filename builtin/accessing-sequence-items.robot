*** Variables ***
@{ITEMS}    0   1   2   3   4   5   6   7   8   9

*** Test Cases ***
Start index
    Log    ${ITEMS}[1:]

End index
    Log    ${ITEMS}[:4]

Start and end
    Log    ${ITEMS}[2:-1]

Step
    Log    ${ITEMS}[::2]
    Log    ${ITEMS}[1:-1:10]