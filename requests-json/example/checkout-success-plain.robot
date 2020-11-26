*** Settings ***
Library     RequestsLibrary
Library     Collections

*** Test Cases ***
Checkout Diner Set
    Create Session    toy_store      http://localhost:8000
    &{accept}=    Create Dictionary    Accept=application/json
    ${productList}=   Get Request    toy_store    /api/v1/product    headers=&{accept}
    Status Should Be  200            ${productList}
    Should Be Equal    ${productList.json()["total"]}     ${2}

    ${products}=    Get From Dictionary     ${productList.json()}    products
    ${product_id}=    Set Variable    ${0}
    FOR     ${product}    IN     @{products}
        ${product_id}=      Set Variable    ${product["id"]}
        Run Keyword If    '${product["product_name"]}' == '43 Piece dinner Set'   Exit For Loop
        ${product_id}=      Set Variable    ${0}
    END
    Should Be True     ${product_id} != 0    product id should not equal 0 
    

    ${productDetail}=    Get Request    toy_store    /api/v1/product/${product_id}    headers=&{accept}
    Request Should Be Successful    ${productDetail}
    Should Be Equal As Strings    ${productDetail.json()["id"]}    ${product_id}
    Should Be Equal    ${productDetail.json()["product_name"]}    43 Piece dinner Set
    Should Be Equal As Numbers    ${productDetail.json()["product_price"]}    ${12.95}
    Should Be Equal    ${productDetail.json()["product_image"]}    /43_Piece_dinner_Set.png

    ${order}=    To json    {"cart":[{"product_id": 2,"quantity": 1}],"shipping_method": "Kerry","shipping_address": "405/37 ถ.มหิดล","shipping_sub_district": "ท่าศาลา","shipping_district": "เมือง","shipping_province": "เชียงใหม่","shipping_zip_code": "50000","recipient_name": "ณัฐญา ชุติบุตร","recipient_phone_number": "0970809292"}
    &{post_headers}=    Create Dictionary    Accept=application/json    Content-Type=application/json
    ${orderStatus}=     Post Request    toy_store    /api/v1/order    json=${order}    headers=&{post_headers}
    Status Should Be    200    ${orderStatus}
    Should Be Equal As Strings    ${orderStatus.json()["total_price"]}   14.95
    
    ${confirmPayment}=    To Json    {"order_id": ${orderStatus.json()["order_id"]},"payment_type": "credit","type": "visa","card_number": "4719700591590995","cvv": "752","expired_month": 7,"expired_year": 20,"card_name": "Karnwat Wongudom","total_price": 14.95}
    ${confirmPaymentStatus}=     Post Request    toy_store    /api/v1/confirmPayment    json=${confirmPayment}    headers=&{post_headers}
    Request Should Be Successful    ${confirmPaymentStatus}
    Should Match Regexp    ${confirmPaymentStatus.json()["payment_date"]}    ^\\d{1,2}/\\d{1,2}/\\d{4} \\d{2}:\\d{2}:\\d{2}$
    Should Be Equal As Strings    ${confirmPaymentStatus.json()["order_id"]}    ${orderStatus.json()["order_id"]}
    Delete All Sessions
