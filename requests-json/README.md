# HTTP RequestsLibrary (Python)

- [https://github.com/MarketSquare/robotframework-requests](https://github.com/MarketSquare/robotframework-requests#readme)
- [Keywords Documentation](https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html)

## Install

```sh
pip install robotframework-requests
```

## Start Store Service Stub

- Clone or Download [Store Service Stub](https://github.com/boyone/store-service-stub) Project
- Start Stub Service

  ```sh
  mb start --configfile store-service.json --allowInjection &
  ```

## Sample Test Cases with Shopping Cart

- Test Cases: Checkout Diner Set from Store Service
- Tasks:

  - Get Product List
    - assert http status code should be 200
    - assert products should have 2 items
    - assert products should contain '43 Piece dinner Set'
  - Get Product Detail
    - assert http status code should be 200
    - assert product name should contain '43 Piece dinner Set'
  - Order Diner Set
    - assert http status code should be 200
    - assert product total price should be 14.95
  - Confirm Payment

    - assert http status code should be 200
    - assert notification message should be 'วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359104 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900'

  - How to pass the id from 'Get Product List' to 'Get Product Detail' id?
  - How to pass the return order id from 'Order Diner Set' to 'Confirm Payment' order id?

  - Which parameters in each task that we have to concern?
    - consequence
    - specific

### Get Product List

#### Import Library

```robot
*** Settings ***
Library     RequestsLibrary
```

#### Create Session

```robot
*** Test Cases ***
Checkout Diner Set
    Create Session    toy_store      http://localhost:8000
```

### Call Request With GET Method and Header

```robot
*** Test Cases ***
Checkout Diner Set
    ...
    ${productList}=   Get Request    toy_store    /api/v1/product    headers=&{accept}
```

```robot
*** Test Cases ***
Checkout Diner Set
    ...
    Status Should Be    200    ${productList}
```

```robot
*** Test Cases ***
Checkout Diner Set
    Create Session    toy_store      http://localhost:8000

    &{accept}=    Create Dictionary    Accept=application/json

    ${productList}=   Get Request    toy_store    /api/v1/product    headers=&{accept}
    Status Should Be    200    ${productList}
```

```robot
*** Test Cases ***
Checkout Diner Set
    Create Session    toy_store      http://localhost:8000
    &{accept}=    Create Dictionary    Accept=application/json
    ${productList}=   Get Request    toy_store    /api/v1/product    headers=&{accept}

    Status Should Be    200    ${productList}
    Should Be Equal   ${productList.json()["total"]}   ${2}
```

### Get Product Detail

```robot
*** Test Cases ***
Checkout Diner Set
    ...
    ${productDetail}=    Get Request    toy_store    /api/v1/product/2    headers=&{accept}
    Request Should Be Successful    ${productDetail}
    Should Be Equal    ${productDetail.json()["id"]}    2
    Should Be Equal    ${productDetail.json()["product_name"]}    43 Piece dinner Set
    Should Be Equal    ${productDetail.json()["product_price"]}    ${12.95}
    Should Be Equal    ${productDetail.json()["product_image"]}    /43_Piece_dinner_Set.png
```

### Order Diner Set

```robot
*** Test Cases ***
Checkout Diner Set
    ...
    ${order}=    To Json    {"cart":[{"product_id": 2,"quantity": 1}],"shipping_method": "Kerry","shipping_address": "405/37 ถ.มหิดล","shipping_sub_district": "ท่าศาลา","shipping_district": "เมือง","shipping_province": "เชียงใหม่","shipping_zip_code": "50000","recipient_name": "ณัฐญา ชุติบุตร","recipient_phone_number": "0970809292"}

    &{post_headers}=    Create Dictionary    Accept=application/json    Content-Type=application/json

    ${orderStatus}=    Post Request    toy_store    /api/v1/order    data=${order}    headers=&{post_headers}
```

#### Assert Order Status

```robot
*** Test Cases ***
Checkout Diner Set
    ...
    ${order}=    To Json    {"cart":[{"product_id": 2,"quantity": 1}], "shipping_method": "Kerry", "shipping_address": "405/37 ถ.มหิดล", "shipping_sub_district": "ท่าศาลา", "shipping_district": "เมือง", "shipping_province": "เชียงใหม่", "shipping_zip_code": "50000", "recipient_name": "ณัฐญา ชุติบุตร", "recipient_phone_number": "0970809292"}
    &{post_headers}=    Create Dictionary    Accept=application/json    Content-Type=application/json
    ${orderStatus}=    Post Request    toy_store    /api/v1/order    json=${order}    headers=&{post_headers}
    Request Should Be Successful    ${orderStatus}
    Should Be Equal    ${orderStatus.json()["order_id"]}    8004359122
    Should Be Equal    ${orderStatus.json()["total_price"]}    ${14.95}
```

### Confirm Payment

```robot
Checkout Diner Set
    ...
    ${confirmPayment}=    To Json    {"order_id": 8004359122,"payment_type": "credit","type": "visa","card_number": "4719700591590995","cvv": "752","expired_month": 7,"expired_year": 20,"card_name": "Karnwat Wongudom","total_price": 14.95}
```

#### Assert Confirm Payment Status

```robot
Checkout Diner Set
    ...
    ${confirmPaymentStatus}=     Post Request    toy_store    /api/v1/confirmPayment    json=${confirmPayment}    headers=&{post_headers}
    Request Should Be Successful    ${confirmPaymentStatus}
    Should Be Equal As Strings    ${confirmPaymentStatus.json()["notify_message"]}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
```

### Assertion with HTTP Status 200

```robot
*** Test Cases ***
Checkout Diner Set
    ...
    Request Should Be Successful    ${productList}
```

## Checkout Diner Set

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
