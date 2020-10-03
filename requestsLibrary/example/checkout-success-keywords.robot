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
${ORDER_TEMPLATE}       {"cart":[{"product_id": 2,"quantity": 1}],"shipping_method": "Kerry","shipping_address": "405/37 ถ.มหิดล","shipping_sub_district": "ท่าศาลา","shipping_district": "เมือง","shipping_province": "เชียงใหม่","shipping_zip_code": "50000","recipient_name": "ณัฐญา ชุติบุตร","recipient_phone_number": "0970809292"}
${CONFIRM_PAYMENT_TEMPLATE}    {"order_id": 8004359122,"payment_type": "credit","type": "visa","card_number": "4719700591590995","cvv": "752","expired_month": 7,"expired_year": 20,"card_name": "Karnwat Wongudom","total_price": 14.95}

*** Test Cases ***
Checkout Diner Set
    Get Product List
    Get Product Detail
    Order Diner Set
    Confirm Payment

*** Keywords ***
Get Product List
    ${productList}=   Get Request    ${toy_store}    /api/v1/product    headers=&{ACCEPT}
    Status Should Be  200            ${productList}
    Should Be Equal     ${productList.json()["total"]}     ${2}
    ${products}=    Get From Dictionary     ${productList.json()}    products
    Log List   ${products}
    ${id}=    Set Variable    ${0}
    FOR     ${product}    IN     @{products}
        ${id}=      Set Variable    ${product["id"]}
        Run Keyword If    '${product["product_name"]}' == '43 Piece dinner Set'   Exit For Loop
        ${id}=      Set Variable    ${0}
    END
    Should Be True     ${id} != 0    product id should not equal 0
    Set Test Variable    ${product_id}    ${id}

Get Product Detail
    ${productDetail}=    Get Request    ${toy_store}    /api/v1/product/${product_id}    headers=&{ACCEPT}
    Request Should Be Successful    ${productDetail}
    Should Be Equal     ${productDetail.json()["product_name"]}    43 Piece dinner Set

Order Diner Set
    ${order}=    To json    ${ORDER_TEMPLATE}
    ${orderStatus}=     Post Request    ${toy_store}    /api/v1/order    json=${order}    headers=&{POST_HEADERS}
    Status Should Be    200    ${orderStatus}
    Should Be Equal As Strings    ${orderStatus.json()["total_price"]}   14.95

Confirm Payment
    ${confirmPayment}=    To Json    ${CONFIRM_PAYMENT_TEMPLATE}
    ${confirmPaymentStatus}=     Post Request    ${toy_store}    /api/v1/confirmPayment    json=${confirmPayment}    headers=&{POST_HEADERS}
    Request Should Be Successful    ${confirmPaymentStatus}
    Should Be Equal As Strings    ${confirmPaymentStatus.json()["notify_message"]}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900