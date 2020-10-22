# Variables

## Check out Order Set

```robot
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
    Log List   ${products}
    ${product_id}=    Set Variable    ${0}
    FOR     ${product}    IN     @{products}
        ${product_id}=      Set Variable    ${product["id"]}
        Run Keyword If    '${product["product_name"]}' == '43 Piece dinner Set'   Exit For Loop
        ${product_id}=      Set Variable    ${0}
    END
    Should Be True     ${product_id} != 0    product id should not equal 0


    ${productDetail}=    Get Request    toy_store    /api/v1/product/2    headers=&{accept}
    Should Be Equal    ${productDetail.json()["id"]}    ${product_id}
    Should Be Equal    ${productDetail.json()["product_name"]}    43 Piece dinner Set

    ${order}=    To json    {"cart":[{"product_id": 2,"quantity": 1}],"shipping_method": "Kerry","shipping_address": "405/37 ถ.มหิดล","shipping_sub_district": "ท่าศาลา","shipping_district": "เมือง","shipping_province": "เชียงใหม่","shipping_zip_code": "50000","recipient_name": "ณัฐญา ชุติบุตร","recipient_phone_number": "0970809292"}
    &{post_headers}=    Create Dictionary    Accept=application/json    Content-Type=application/json
    ${orderStatus}=     Post Request    toy_store    /api/v1/order    data=${order}    headers=&{post_headers}
    Status Should Be    200    ${orderStatus}
    Should Be Equal As Strings    ${orderStatus.json()["total_price"]}   14.95

    ${confirmPayment}=    To Json    {"order_id": 8004359104,"payment_type": "credit","type": "visa","card_number": "4719700591590995","cvv": "752","expired_month": 7,"expired_year": 20,"card_name": "Karnwat Wongudom","total_price": 14.95}
    ${confirmPaymentStatus}=     Post Request    toy_store    /api/v1/confirmPayment    data=${confirmPayment}    headers=&{post_headers}
    Request Should Be Successful    ${confirmPaymentStatus}
    Should Be Equal As Strings    ${confirmPaymentStatus.json()["notify_message"]}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359104 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
    Delete All Sessions
```

## Create Variables

```robot
*** Variables ***
${toy_store}
${URL}        http://localhost:8000
&{ACCEPT}     Accept=application/json
${OK}         200
*** Test Cases ***
Checkout Diner Set
    Create Session    ${toy_store}      http://localhost:8000
    ${productList}=   Get Request    toy_store    /api/v1/product    headers=&{ACCEPT}
    Status Should Be  ${OK}            ${productList}
```

## Create Order Template and Post Headers

```robot
*** Variables ***
&{CONTENT_TYPE}      Content-Type=application/json
&{ACCEPT}            Accept=application/json
&{POST_HEADERS}      &{ACCEPT}    &{CONTENT_TYPE}
${ORDER_TEMPLATE}    {"cart":[{"product_id": 2,"quantity": 1}],"shipping_method": "Kerry","shipping_address": "405/37 ถ.มหิดล","shipping_sub_district": "ท่าศาลา","shipping_district": "เมือง","shipping_province": "เชียงใหม่","shipping_zip_code": "50000","recipient_name": "ณัฐญา ชุติบุตร","recipient_phone_number": "0970809292"}

*** Test Cases ***
Checkout Diner Set
    ...
    ${order}=    To json   ${ORDER_TEMPLATE}
    ${orderStatus}=     Post Request    ${toy_store}    /api/v1/order    json=${order}    headers=&{POST_HEADERS}
```

## Create Confirm Payment Template

```robot
*** Variables ***
${CONFIRM_PAYMENT_TEMPLATE}    {"order_id": 8004359122, "payment_type": "credit","type": "visa","card_number": "4719700591590995", "cvv": "752", "expired_month": 7, "expired_year": 20, "card_name": "Karnwat Wongudom", "total_price": 14.95}

*** Test Cases ***
Checkout Diner Set
    ...
    ${confirmPayment}=    To Json    ${CONFIRM_PAYMENT_TEMPLATE}
```

## Create Test Setup and Test Teardown

```robot
*** Settings ***
Library          RequestsLibrary
Test Setup       Create Session    ${toy_store}      ${URL}
Test Teardown    Delete All Sessions

*** Test Cases ***
Checkout Diner Set
    &{accept}=    Create Dictionary    Accept=application/json
    ...
    Should Be Equal As Strings    ${confirmPaymentStatus.json()["notify_message"]}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359104 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
```
