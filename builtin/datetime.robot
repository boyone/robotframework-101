*** Settings ***
Library    DateTime

*** Test Cases ***
Example DateTime
    ${date1} =    Convert Date    2014-06-11 10:07:42.000    
    ${date2} =    Convert Date    20140611 100742    result_format=timestamp
    Should Be Equal    ${date1}    ${date2}    
    ${date} =    Convert Date    20140612 12:57    exclude_millis=yes
    Should Be Equal    ${date}    2014-06-12 12:57:00

    ${date} =    Convert Date    28.05.2014 12:05    date_format=%d.%m.%Y %H:%M
    Should Be Equal    ${date}    2014-05-28 12:05:00.000    
    ${date} =    Convert Date    ${date}    result_format=%d.%m.%Y
    Should Be Equal    ${date}    28.05.2014