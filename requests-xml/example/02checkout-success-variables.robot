*** Settings ***
Library     RequestsLibrary
Library     Collections
Library        String
Library        XML
Test Setup    Create Session    ${toy_store}      ${URL}
Test Teardown    Delete All Sessions

*** Variables ***
${toy_store}
${URL}                  http://localhost:8000
&{CONTENT_TYPE}         Content-Type=text/xml
&{ACCEPT}               Accept=text/xml
&{POST_HEADERS}         &{ACCEPT}    &{CONTENT_TYPE}
${ORDER_TEMPLATE}       
...             <orders>
...               <cart>
...                 <order>
...                   <product_id>\${id}</product_id>
...                   <quantity>2</quantity>
...                 </order>
...               </cart>
...               <shipping_method>Kerry</shipping_method>
...               <shipping_address>405/37 ถ.มหิดล</shipping_address>
...               <shipping_sub_district>ท่าศาลา</shipping_sub_district>
...               <shipping_district>เมือง</shipping_district>
...               <shipping_province>เชียงใหม่</shipping_province>
...               <shipping_zip_code>50000</shipping_zip_code>
...               <recipient_name>ณัฐญา ชุติบุตร</recipient_name>
...               <recipient_phone_number>0970809292</recipient_phone_number>
...             </orders>
${CONFIRM_PAYMENT_TEMPLATE}    
...             <confirm-payment>
...               <order_id>\${order_id}</order_id>
...               <payment_type>credit</payment_type>
...               <type>visa</type>
...               <card_number>4719700591590995</card_number>
...               <cvv>752</cvv>
...               <expired_month>7</expired_month>
...               <expired_year>20</expired_year>
...               <card_name>Karnwat Wongudom</card_name>
...               <total_price>\${total_price}</total_price>
...             </confirm-payment>

*** Test Cases ***
Checkout Diner Set
    ${productList}=   Get Request    ${toy_store}    /api/v1/product    headers=&{ACCEPT}
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

    ${productDetail}=    Get Request    ${toy_store}    /api/v1/product/${id}    headers=&{ACCEPT}
    Request Should Be Successful    ${productDetail}
    ${xml}    Parse Xml     ${productDetail.content}
    ${name}=      Get Element Text   ${xml}    product_name
    Should Be Equal     ${name}    43 Piece dinner Set

    ${order_message}=     Replace Variables    ${ORDER_TEMPLATE}
    ${order}=    Encode String To Bytes    ${order_message}    UTF-8
    ${orderStatus}=     Post Request    ${toy_store}    /api/v1/order    data=${order}    headers=&{POST_HEADERS}
    Status Should Be    200    ${orderStatus}
    ${xml}    Parse Xml    ${orderStatus.content}
    ${total_price}=      Get Element Text   ${xml}    total_price
    Should Be Equal    ${total_price}    14.95
    ${order_id}=      Get Element Text   ${xml}    order_id

    ${payment_message}=     Replace Variables    ${CONFIRM_PAYMENT_TEMPLATE}
    ${confirmPayment}=    Encode String To Bytes    ${payment_message}    UTF-8
    ${confirmPaymentStatus}=     Post Request    ${toy_store}    /api/v1/confirmPayment    data=${confirmPayment}    headers=&{POST_HEADERS}
    Request Should Be Successful    ${confirmPaymentStatus}
    ${xml}    Parse Xml    ${confirmPaymentStatus.content}
    ${message}=      Get Element Text   ${xml}
    Should Be Equal As Strings    ${message}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
