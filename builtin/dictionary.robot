*** Variables ***
#&{DATA}     [{'id': 1, 'name': 'Robot'}, {'id': 2, 'name': 'Mr. X'}]

*** Test Cases ***
Dictionary Variable
    &{FIRST}=    Create Dictionary    id=1    name=Robot
    &{SECOND}=    Create Dictionary    id=2    name=Mr. X
    &{DATA}=    Create Dictionary    0=&{FIRST}    1=&{SECOND}
    Log     ${DATA}[0][name]
    Log     ${DATA}[1][id]
