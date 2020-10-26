*** Settings ***
Library        String
Library        XML

*** Variables ***
${product_list}    
...        <product-list>
...          <total>2</total>
...          <products>
...            <product>
...              <id>1</id>
...              <product_name>Balance Training Bicycle</product_name>
...              <product_price>119.95</product_price>
...              <product_image>/Balance_Training_Bicycle.png</product_image>
...            </product>
...            <product>
...              <id>2</id>
...              <product_name>43 Piece dinner Set</product_name>
...              <product_price>12.95</product_price>
...              <product_image>/43_Piece_dinner_Set.png</product_image>
...            </product>
...          </products>
...        </product-list>

${dinner_set}    
...              <product>
...                <id>2</id>
...                <product_name>43 Piece dinner Set</product_name>
...                <product_price>12.95</product_price>
...                <product_image>/43_Piece_dinner_Set.png</product_image>
...                <quantity>10</quantity>
...                <product_brand>CoolKidz</product_brand>
...              </product>

*** Test Cases ***
Test Assert XML

    ${xml}    Parse Xml    ${product_list}
    ${total}=    Get Element    ${xml}    total
    Should Be Equal As Integers    ${total.text}     ${2}
    @{products}=    Get Element    ${xml}    products
    Length Should Be	${products}	    2