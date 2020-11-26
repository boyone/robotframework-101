*** Variables ***
${toy_store}
${URL}      http://localhost:8000
&{CONTENT_TYPE}         Content-Type=text/xml
&{ACCEPT}               Accept=text/xml
&{POST_HEADERS}         &{ACCEPT}    &{CONTENT_TYPE}
${ORDER_TEMPLATE}       
...                <orders>
...                  <cart>
...                    <order>
...                      <product_id>\${product_id}</product_id>
...                      <quantity>\${quantity}</quantity>
...                    </order>
...                  </cart>
...                  <shipping_method>Kerry</shipping_method>
...                  <shipping_address>405/37 ถ.มหิดล</shipping_address>
...                  <shipping_sub_district>ท่าศาลา</shipping_sub_district>
...                  <shipping_district>เมือง</shipping_district>
...                  <shipping_province>เชียงใหม่</shipping_province>
...                  <shipping_zip_code>50000</shipping_zip_code>
...                  <recipient_name>ณัฐญา ชุติบุตร</recipient_name>
...                  <recipient_phone_number>0970809292</recipient_phone_number>
...                </orders>

${CONFIRM_PAYMENT_TEMPLATE}    
...               <confirm-payment>
...                 <order_id>\${order_id}</order_id>
...                 <payment_type>credit</payment_type>
...                 <type>visa</type>
...                 <card_number>4719700591590995</card_number>
...                 <cvv>752</cvv>
...                 <expired_month>7</expired_month>
...                 <expired_year>20</expired_year>
...                 <card_name>Karnwat Wongudom</card_name>
...                 <total_price>\${total_price}</total_price>
...               </confirm-payment>

*** Keywords ***
Checkout Product
    [Arguments]    ${product_name}    ${quantity}    ${total_price}
    Get Product List
    Find Product by Name    ${product_name}
    Get Product Detail     ${product_name}
    Order Diner Set     ${quantity}    ${total_price}
    Confirm Payment     ${total_price}

Get Product List
    ${resp}=   Get Request    ${toy_store}    /api/v1/product    headers=&{ACCEPT}
    Status Should Be  200            ${resp}
    ${text}=    Decode Bytes To String    ${resp.content}    UTF-8
    ${xml}    Parse Xml   ${text}
    ${total}=    Get Element    ${xml}    total
    Should Be Equal As Integers    ${total.text}     ${2}
    @{products}=    Get Element    ${xml}    products
    Length Should Be	${products}	    2
    Set Test Variable    ${products}    ${products}
    
Find Product by Name
    [Arguments]    ${product_name}
    ${id}=    Set Variable    0
    FOR     ${product}    IN     @{products}
        ${id}=      Get Element Text   ${product}    id
        ${name}=    Get Element Text    ${product}    product_name
        Run Keyword If    '${name}' == '${product_name}'   Exit For Loop
        ${id}=      Set Variable    0
    END
    Should Be True     ${id} != 0    product id should not equal 0
    Set Test Variable    ${product_id}    ${id}

Get Product Detail
    [Arguments]    ${product_name}
    ${productDetail}=    Get Request    ${toy_store}    /api/v1/product/${product_id}    headers=&{ACCEPT}
    Request Should Be Successful    ${productDetail}
    ${xml}    Parse Xml     ${productDetail.content}
    ${name}=      Get Element Text   ${xml}    product_name
    Should Be Equal     ${name}    ${product_name}

Order Diner Set
    [Arguments]     ${quantity}    ${total_price}
    ${message}=     Replace Variables    ${ORDER_TEMPLATE}
    ${order}=    Encode String To Bytes    ${message}    UTF-8
    ${orderStatus}=     Post Request    ${toy_store}    /api/v1/order    data=${order}    headers=&{POST_HEADERS}
    Status Should Be    200    ${orderStatus}
    ${xml}    Parse Xml    ${orderStatus.content}
    ${actual_total_price}=      Get Element Text   ${xml}    total_price
    Should Be Equal    ${total_price}    ${actual_total_price}
    ${order_id}=      Get Element Text   ${xml}    order_id
    Set Test Variable    ${order_id}    ${order_id}

Confirm Payment
    [Arguments]     ${total_price}
    ${message}=     Replace Variables    ${CONFIRM_PAYMENT_TEMPLATE}
    ${confirmPayment}=    Encode String To Bytes    ${message}    UTF-8
    ${confirmPaymentStatus}=     Post Request    ${toy_store}    /api/v1/confirmPayment    data=${confirmPayment}    headers=&{POST_HEADERS}
    Request Should Be Successful    ${confirmPaymentStatus}
    ${xml}    Parse Xml    ${confirmPaymentStatus.content}
    ${payment_date}=      Get Element Text   ${xml}    payment_date
    Should Match Regexp    ${payment_date}        ^\\d{1,2}/\\d{1,2}/\\d{4} \\d{2}:\\d{2}:\\d{2}$
    ${actual_order_id}=      Get Element Text   ${xml}    order_id
    Should Be Equal As Strings    ${actual_order_id}    ${order_id}
    ${tracking_id}=      Get Element Text   ${xml}    tracking_id
    Should Match Regexp	   ${tracking_id}    ^\\d{10}$