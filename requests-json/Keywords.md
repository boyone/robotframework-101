# Keywords

## Init checkout-success-keywords.robot

```robot
*** Settings ***
Library          RequestsLibrary
Test Setup       Create Session    ${toy_store}   ${URL}
Test Teardown    Delete All Sessions

*** Variables ***
${toy_store}
${URL}        http://localhost:8000
&{CONTENT_TYPE}      Content-Type=application/json
&{ACCEPT}            Accept=application/json
&{POST_HEADERS}      &{ACCEPT}    &{CONTENT_TYPE}
${ORDER_TEMPLATE}    {"cart":[{"product_id": 2,"quantity": 1}],"shipping_method": "Kerry","shipping_address": "405/37 ถ.มหิดล","shipping_sub_district": "ท่าศาลา","shipping_district": "เมือง","shipping_province": "เชียงใหม่","shipping_zip_code": "50000","recipient_name": "ณัฐญา ชุติบุตร","recipient_phone_number": "0970809292"}
${OK}         200  

*** Test Cases ***
Checkout Diner Set
    ${productList}=   Get Request    ${toy_store}    /api/v1/product    headers=&{ACCEPT}
    Status Should Be  ${OK}            ${productList}
    Should Be Equal   ${productList.json()["total"]}   ${2}

    ${productDetail}=    Get Request    ${toy_store}    /api/v1/product/2    headers=&{ACCEPT}
    Request Should Be Successful    ${productDetail}
    Should Be Equal    ${productDetail.json()["id"]}    ${2}
    Should Be Equal    ${productDetail.json()["product_name"]}    43 Piece dinner Set

    ${order}=    To Json    ${ORDER_TEMPLATE}
    ${orderStatus}=    Post Request    ${toy_store}    /api/v1/order    json=${order}    headers=&{POST_HEADERS}
    Request Should Be Successful    ${orderStatus}
    Should Be Equal    ${orderStatus.json()["order_id"]}    ${8004359122}
    Should Be Equal    ${orderStatus.json()["total_price"]}    ${14.95}

    ${confirmPayment}=    To Json    {"order_id": 8004359122,"payment_type": "credit","type": "visa","card_number": "4719700591590995","cvv": "752","expired_month": 7,"expired_year": 20,"card_name": "Karnwat Wongudom","total_price": 14.95}
    ${confirmPaymentStatus}=     Post Request    ${toy_store}    /api/v1/confirmPayment    json=${confirmPayment}    headers=&{POST_HEADERS}
    Request Should Be Successful    ${confirmPaymentStatus}
    Should Be Equal As Strings    ${confirmPaymentStatus.json()["notify_message"]}    วันเวลาที่ชำระเงิน 1/3/2020 13:30:00 หมายเลขคำสั่งซื้อ 8004359122 คุณสามารถติดตามสินค้าผ่านช่องทาง Kerry หมายเลข 1785261900
```