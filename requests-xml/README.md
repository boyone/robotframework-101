# HTTP RequestsLibrary (Python)

- [https://github.com/MarketSquare/robotframework-requests](https://github.com/MarketSquare/robotframework-requests#readme)
- [Keywords Documentation](https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html)

## Create Project and Install robotframework-requests

```sh
mkdir requests-xml  # create directory
cd requests-xml     # change workspace
python3 -m venv env # create a virtual environment
```

```sh
# Unix or MacOS
source env/bin/activate     # activate virtual environment
```

```sh
# Windows
env\Scripts\activate.bat    # activate virtual environment
```

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

    &{accept}=    Create Dictionary    Accept=text/xml

    ${productList}=   Get Request    toy_store    /api/v1/product    headers=&{accept}
    Status Should Be    200    ${productList}
```

```robot
*** Test Cases ***
Checkout Diner Set
    Create Session    toy_store      http://localhost:8000
    &{accept}=    Create Dictionary    Accept=text/xml
    ${productList}=   Get Request    toy_store    /api/v1/product    headers=&{accept}

    Status Should Be    200    ${productList}
    ${text}=    Decode Bytes To String    ${productList.content}    UTF-8
    ${xml}    Parse Xml   ${text}
    ${total}=    Get Element    ${xml}    total
    Should Be Equal As Integers    ${total.text}     ${2}
    @{products}=    Get Element    ${xml}    products
    Length Should Be    ${products}    2
```

### Get Product Detail

```robot
*** Test Cases ***
Checkout Diner Set
    ...
    ${productDetail}=    Get Request    toy_store    /api/v1/product/2    headers=&{accept}
    Request Should Be Successful    ${productDetail}
    ${xml}    Parse Xml     ${productDetail.content}
    ${name}=      Get Element Text   ${xml}    product_name
    Should Be Equal     ${name}    43 Piece dinner Set
```

### Order Diner Set

```robot
*** Test Cases ***
Checkout Diner Set
    ...
    ${order}=    Encode String To Bytes    <orders><cart><order><product_id>${id}</product_id><quantity>2</quantity></order></cart><shipping_method>Kerry</shipping_method><shipping_address>405/37 ถ.มหิดล</shipping_address><shipping_sub_district>ท่าศาลา</shipping_sub_district><shipping_district>เมือง</shipping_district><shipping_province>เชียงใหม่</shipping_province><shipping_zip_code>50000</shipping_zip_code><recipient_name>ณัฐญา ชุติบุตร</recipient_name><recipient_phone_number>0970809292</recipient_phone_number></orders>    UTF-8
    &{post_headers}=    Create Dictionary    Accept=text/xml    Content-Type=text/xml
    ${orderStatus}=     Post Request    toy_store    /api/v1/order    data=${order}    headers=&{post_headers}
```

#### Assert Order Status

```robot
*** Test Cases ***
Checkout Diner Set
    ...
    Status Should Be    200    ${orderStatus}
    ${xml}    Parse Xml    ${orderStatus.content}
    ${total_price}=      Get Element Text   ${xml}    total_price
    Should Be Equal    ${total_price}    14.95
```

### Confirm Payment

```robot
Checkout Diner Set
    ...
    ${confirmPayment}=    Encode String To Bytes    <confirm-payment><order_id>${order_id}</order_id><payment_type>credit</payment_type><type>visa</type><card_number>4719700591590995</card_number><cvv>752</cvv><expired_month>7</expired_month><expired_year>20</expired_year><card_name>Karnwat Wongudom</card_name><total_price>${total_price}</total_price></confirm-payment>    UTF-8
    ${confirmPaymentStatus}=     Post Request    toy_store    /api/v1/confirmPayment    data=${confirmPayment}    headers=&{post_headers}
```

#### Assert Confirm Payment Status

```robot
Checkout Diner Set
    ...
    ${confirmPaymentStatus}=     Post Request    toy_store    /api/v1/confirmPayment    data=${confirmPayment}    headers=&{post_headers}
    Request Should Be Successful    ${confirmPaymentStatus}
    ${xml}    Parse Xml    ${confirmPaymentStatus.content}
    ${message}=      Get Element Text   ${xml}
    Should Be Equal As Strings    ${message}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
```

## Checkout Diner Set

```robot
*** Settings ***
Library    RequestsLibrary
Library        String
Library        XML

*** Test Cases ***
Checkout Diner Set
    Create Session   toy_store   http://167.99.77.238:8000

    &{accept}=   Create Dictionary   Accept=text/xml
    
    ${productList}=   Get Request   toy_store   /api/v1/product    headers=&{accept}
    Status Should Be  200   ${productList}

    # ${text}=    Decode Bytes To String    ${productList.content}    UTF-8
    ${xml}    Parse Xml   ${productList.content}
    ${total}=    Get Element    ${xml}    total
    Should Be Equal As Integers    ${total.text}     ${2}
    @{products}=    Get Element    ${xml}    products
    Length Should Be	${products}	    2

    ${productDetail}=    Get Request    toy_store    /api/v1/product/2    headers=&{accept}
    Request Should Be Successful    ${productDetail}
    ${xml}    Parse Xml     ${productDetail.content}
    ${name}=      Get Element Text   ${xml}    product_name
    Should Be Equal     ${name}    43 Piece dinner Set

    ${order}=    Encode String To Bytes    <orders><cart><order><product_id>2</product_id><quantity>1</quantity></order></cart><shipping_method>Kerry</shipping_method><shipping_address>405/37 ถ.มหิดล</shipping_address><shipping_sub_district>ท่าศาลา</shipping_sub_district><shipping_district>เมือง</shipping_district><shipping_province>เชียงใหม่</shipping_province><shipping_zip_code>50000</shipping_zip_code><recipient_name>ณัฐญา ชุติบุตร</recipient_name><recipient_phone_number>0970809292</recipient_phone_number></orders>    UTF-8
    &{post_headers}=    Create Dictionary    Accept=text/xml    Content-Type=text/xml
    ${orderStatus}=     Post Request    toy_store    /api/v1/order        data=${order}    headers=&{post_headers}
    Status Should Be    200    ${orderStatus}
    ${xml}    Parse Xml    ${orderStatus.content}
    ${total_price}=      Get Element Text   ${xml}    total_price
    Should Be Equal    ${total_price}    14.95
    ${order_id}=      Get Element Text   ${xml}    order_id

    ${confirmPayment}=    Encode String To Bytes    <confirm-payment><order_id>${order_id}</order_id><payment_type>credit</payment_type><type>visa</type><card_number>4719700591590995</card_number><cvv>752</cvv><expired_month>7</expired_month><expired_year>20</expired_year><card_name>Karnwat Wongudom</card_name><total_price>${total_price}</total_price></confirm-payment>    UTF-8
    ${confirmPaymentStatus}=     Post Request    toy_store    /api/v1/confirmPayment    data=${confirmPayment}    headers=&{post_headers}
    Request Should Be Successful    ${confirmPaymentStatus}
    ${xml}    Parse Xml    ${confirmPaymentStatus.content}
    ${message}=      Get Element Text   ${xml}
    Should Be Equal As Strings    ${message}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
```
