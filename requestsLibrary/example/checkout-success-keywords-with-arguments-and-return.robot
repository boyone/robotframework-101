*** Settings ***
Library     RequestsLibrary
Library     Collections
Test Setup    Create Session    ${toy_store}      ${URL}
Test Teardown    Delete All Sessions

*** Variables ***
${toy_store}
${URL}      http://localhost:8000
&{CONTENT_TYPE}         Content-Type=application/json
&{ACCEPT}               Accept=application/json
&{POST_HEADERS}         &{ACCEPT}    &{CONTENT_TYPE}
${ORDER_TEMPLATE}       {"cart":[{"product_id": \${product_id},"quantity": \${quantity}}],"shipping_method": "Kerry","shipping_address": "405/37 ถ.มหิดล","shipping_sub_district": "ท่าศาลา","shipping_district": "เมือง","shipping_province": "เชียงใหม่","shipping_zip_code": "50000","recipient_name": "ณัฐญา ชุติบุตร","recipient_phone_number": "0970809292"}
${CONFIRM_PAYMENT_TEMPLATE}    {"order_id": \${order_id},"payment_type": "credit","type": "visa","card_number": "4719700591590995","cvv": "752","expired_month": 7,"expired_year": 20,"card_name": "Karnwat Wongudom","total_price": \${total_price}}

*** Test Cases ***
Checkout Diner Set
    ${products}=    Get Product List
    ${id}=    Find Product by Name    43 Piece dinner Set    ${products}
    Get Product Detail    ${id}
    ${order_id}=    Order Diner Set     1    14.95     ${id}
    Confirm Payment     14.95    ${order_id}

*** Keywords ***
Get Product List
    ${productList}=   Get Request    ${toy_store}    /api/v1/product    headers=&{ACCEPT}
    Status Should Be  200            ${productList}
    Should Be Equal     ${productList.json()["total"]}     ${2}
    ${products}=    Get From Dictionary     ${productList.json()}    products
    Return From Keyword    ${products}
    
Find Product by Name
    [Arguments]    ${product_name}    ${products}
    ${id}=    Set Variable    ${0}
    FOR     ${product}    IN     @{products}
        ${id}=      Set Variable    ${product["id"]}
        Run Keyword If    '${product["product_name"]}' == '${product_name}'   Exit For Loop
        ${id}=      Set Variable    ${0}
    END
    Should Be True     ${id} != 0    product id should not equal 0
    Return From Keyword    ${id}

Get Product Detail
    [Arguments]    ${product_id}
    ${productDetail}=    Get Request    ${toy_store}    /api/v1/product/${product_id}    headers=&{ACCEPT}
    Request Should Be Successful    ${productDetail}
    Should Be Equal     ${productDetail.json()["product_name"]}    43 Piece dinner Set

Order Diner Set
    [Arguments]     ${quantity}    ${total_price}    ${product_id}
    ${message}=     Replace Variables    ${ORDER_TEMPLATE}
    ${order}=    To json    ${message}
    ${orderStatus}=     Post Request    ${toy_store}    /api/v1/order    data=${order}    headers=&{POST_HEADERS}
    Status Should Be    200    ${orderStatus}
    Should Be Equal As Strings    ${orderStatus.json()["total_price"]}   ${total_price}
    Return From Keyword    ${orderStatus.json()["order_id"]}

Confirm Payment
    [Arguments]     ${total_price}    ${order_id}
    ${message}=     Replace Variables    ${CONFIRM_PAYMENT_TEMPLATE}
    ${confirmPayment}=    To Json    ${message}
    ${confirmPaymentStatus}=     Post Request    ${toy_store}    /api/v1/confirmPayment    data=${confirmPayment}    headers=&{POST_HEADERS}
    Request Should Be Successful    ${confirmPaymentStatus}
    Should Be Equal As Strings    ${confirmPaymentStatus.json()["notify_message"]}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359104 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900