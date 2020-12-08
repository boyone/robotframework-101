*** Test Cases ***
For Loop with List Example
    @{fruits}=    Create List    "apple"    "banana"    "cherry"
    FOR     ${fruit}    IN    @{fruits}
        Log    fruit: ${fruit}
    END

For Loop with Range Example
    FOR     ${number}    IN RANGE    10
        Log    No: ${number}
    END

For Loop with Start and End Range Example
    FOR     ${number}    IN RANGE    5    10
        Log    No: ${number}
    END