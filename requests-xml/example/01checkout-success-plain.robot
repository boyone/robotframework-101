*** Settings ***
Library     RequestsLibrary
Library     Collections
Library        String
Library        XML

*** Test Cases ***
Checkout Diner Set
    Create Session    toy_store      http://localhost:8000
    &{accept}=    Create Dictionary    Accept=text/xml
    ${productList}=   Get Request    toy_store    /api/v1/product    headers=&{accept}
    Status Should Be  200            ${productList}

    ${text}=    Decode Bytes To String    ${productList.content}    UTF-8
    ${xml}    Parse Xml   ${text}
    ${total}=    Get Element    ${xml}    total
    Should Be Equal As Integers    ${total.text}     ${2}
    @{products}=    Get Element    ${xml}    products
    Length Should Be	${products}	    2

    # ${id}=    Set Variable    0
    # FOR     ${product}    IN     @{products}
    #     ${id}=      Get Element Text   ${product}    id
    #     ${name}=    Get Element Text    ${product}    product_name
    #     Run Keyword If    '${name}' == '43 Piece dinner Set'   Exit For Loop
    #     ${id}=      Set Variable    0
    # END
    # Should Be True     ${id} != 0    product id should not equal 0
    
    ${productDetail}=    Get Request    toy_store    /api/v1/product/2    headers=&{accept}
    Request Should Be Successful    ${productDetail}
    ${xml}    Parse Xml     ${productDetail.content}
    ${name}=      Get Element Text   ${xml}    product_name
    Should Be Equal     ${name}    43 Piece dinner Set

    ${order}=    Encode String To Bytes    <orders><cart><order><product_id>2</product_id><quantity>2</quantity></order></cart><shipping_method>Kerry</shipping_method><shipping_address>405/37 ถ.มหิดล</shipping_address><shipping_sub_district>ท่าศาลา</shipping_sub_district><shipping_district>เมือง</shipping_district><shipping_province>เชียงใหม่</shipping_province><shipping_zip_code>50000</shipping_zip_code><recipient_name>ณัฐญา ชุติบุตร</recipient_name><recipient_phone_number>0970809292</recipient_phone_number></orders>    UTF-8
    &{post_headers}=    Create Dictionary    Accept=text/xml    Content-Type=text/xml
    ${orderStatus}=     Post Request    toy_store    /api/v1/order    data=${order}    headers=&{post_headers}
    Status Should Be    200    ${orderStatus}
    ${xml}    Parse Xml    ${orderStatus.content}
    ${total_price}=      Get Element Text   ${xml}    total_price
    Should Be Equal    ${total_price}    14.95
    ${order_id}=      Get Element Text   ${xml}    order_id
    
    ${confirmPayment}=    Encode String To Bytes    <confirm-payment><order_id>${order_id}</order_id><payment_type>credit</payment_type><type>visa</type><card_number>4719700591590995</card_number><cvv>752</cvv><expired_month>7</expired_month><expired_year>20</expired_year><card_name>Karnwat Wongudom</card_name><total_price>${total_price}</total_price></confirm-payment>    UTF-8
    ${confirmPaymentStatus}=     Post Request    toy_store    /api/v1/confirmPayment    data=${confirmPayment}    headers=&{post_headers}
    Request Should Be Successful    ${confirmPaymentStatus}
    ${xml}    Parse Xml    ${confirmPaymentStatus.content}
    ${payment_date}=      Get Element Text   ${xml}    payment_date
    Should Match Regexp    ${payment_date}        ^\\d{1,2}/\\d{1,2}/\\d{4} \\d{2}:\\d{2}:\\d{2}$
    ${actual_order_id}=      Get Element Text   ${xml}    order_id
    Should Be Equal As Strings    ${actual_order_id}    ${order_id}
    ${tracking_id}=      Get Element Text   ${xml}    tracking_id
    Should Match Regexp	   ${tracking_id}    ^\\d{10}$
