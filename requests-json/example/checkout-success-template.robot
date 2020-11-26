*** Settings ***
Library     RequestsLibrary
Library     Collections
Suite Setup    Create Session    ${toy_store}      ${URL}
Suite Teardown    Delete All Sessions
Test Template    Checkout Product

*** Variables ***
${toy_store}
${URL}                         http://localhost:8000
&{CONTENT_TYPE}                Content-Type=application/json
&{ACCEPT}                      Accept=application/json
&{POST_HEADERS}                &{ACCEPT}    &{CONTENT_TYPE}

${ORDER_TEMPLATE}              {
...                                "cart":[{
...                                        "product_id": \${product_id}, 
...                                        "quantity": \${quantity}
...                                }],
...                                "shipping_method": "Kerry", 
...                                "shipping_address": "405/37 ถ.มหิดล",
...                                "shipping_sub_district": "ท่าศาลา",
...                                "shipping_district": "เมือง",
...                                "shipping_province": "เชียงใหม่",
...                                "shipping_zip_code": "50000",
...                                "recipient_name": "ณัฐญา ชุติบุตร",
...                                "recipient_phone_number": "0970809292"
...                            }

${CONFIRM_PAYMENT_TEMPLATE}    {
...                               "order_id": \${order_id}, 
...                               "payment_type": "credit",
...                               "type": "visa",
...                               "card_number": "4719700591590995",
...                               "cvv": "752",
...                               "expired_month": 7,
...                               "expired_year": 20,
...                               "card_name": "Karnwat Wongudom",
...                               "total_price": \${total_price}
...                            }

*** Test Cases ***
Diner Set    43 Piece dinner Set    1    14.95
Bicycle      Balance Training Bicycle    2    241.90

*** Keywords ***
Checkout Product
    [Arguments]    ${product_name}    ${quantity}    ${total_price}
    Get Product List
    Find Product by Name    ${product_name}
    Get Product Detail     ${product_name}
    Order Product     ${quantity}    ${total_price}
    Confirm Payment     ${total_price}

Get Product List
    ${productList}=   Get Request    ${toy_store}    /api/v1/product    headers=&{ACCEPT}
    Status Should Be  200            ${productList}
    Should Be Equal     ${productList.json()["total"]}     ${2}
    ${products}=    Get From Dictionary     ${productList.json()}    products
    Set Test Variable    ${products}    ${products}
    
Find Product by Name
    [Arguments]    ${product_name}
    ${id}=    Set Variable    ${0}
    FOR     ${product}    IN     @{products}
        ${id}=      Set Variable    ${product["id"]}
        Run Keyword If    '${product["product_name"]}' == '${product_name}'   Exit For Loop
        ${id}=      Set Variable    ${0}
    END
    Should Be True     ${id} != 0    product id should not equal 0
    Set Test Variable    ${product_id}    ${id}

Get Product Detail
    [Arguments]    ${product_name}
    ${productDetail}=    Get Request    ${toy_store}    /api/v1/product/${product_id}    headers=&{ACCEPT}
    Request Should Be Successful    ${productDetail}
    Should Be Equal     ${productDetail.json()["product_name"]}    ${product_name}

Order Product
    [Arguments]     ${quantity}    ${total_price}
    ${message}=     Replace Variables    ${ORDER_TEMPLATE}
    ${order}=    To json    ${message}
    ${orderStatus}=     Post Request    ${toy_store}    /api/v1/order    json=${order}    headers=&{POST_HEADERS}
    Status Should Be    200    ${orderStatus}
    Should Be Equal As Numbers    ${orderStatus.json()["total_price"]}   ${total_price}
    Set Test Variable    ${order_id}    ${orderStatus.json()["order_id"]}

Confirm Payment
    [Arguments]     ${total_price}
    ${message}=     Replace Variables    ${CONFIRM_PAYMENT_TEMPLATE}
    ${confirmPayment}=    To Json    ${message}
    ${confirmPaymentStatus}=     Post Request    ${toy_store}    /api/v1/confirmPayment    json=${confirmPayment}    headers=&{POST_HEADERS}
    Request Should Be Successful    ${confirmPaymentStatus}
    Should Match Regexp    ${confirmPaymentStatus.json()["payment_date"]}    ^\\d{1,2}/\\d{1,2}/\\d{4} \\d{2}:\\d{2}:\\d{2}$
    Should Be Equal As Strings    ${confirmPaymentStatus.json()["order_id"]}    ${order_id}
    Should Match Regexp	   ${confirmPaymentStatus.json()["tracking_id"]}    ^\\d{10}$