*** Settings ***
Resource    ../pages/Common.resource
Resource    ../pages/ProductDetailPage.resource
Resource    ../pages/CartPage.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-06-01 Add Item to Cart with Valid Quantity
    Open Home Page
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    Verify Item Quantity In Cart    1

TC-06-02 Adding Quantity Exceeding Stock is Rejected
    Open Home Page
    Go To In-Stock Product
    Set Quantity    999
    Verify Error Message For Exceeding Stock
    Verify Add To Cart Is Disabled

TC-07-01 Update Item Quantity in Cart Updates Total
    Open Home Page
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    Change Item Quantity    2
    Verify Line Total Updates

TC-07-02 Remove Item from Cart
    Open Home Page
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    Remove Item From Cart
    Verify Cart Is Empty
