*** Settings ***
Resource    ../pages/Common.resource
Resource    ../pages/ProductDetailPage.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-05-01 Product Detail Page Displays All Required Information
    Open Home Page
    Go To In-Stock Product
    Verify Product Details Displayed

TC-05-02 Out-of-Stock Product Cannot Be Added to Cart
    Open Home Page
    Go To Out-Of-Stock Product
    Verify Product Details Displayed
    Verify Add To Cart Is Disabled
