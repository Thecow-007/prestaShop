*** Settings ***
# test_integration.robot — Automation tests for integration of various components
# Test cases: TC-INT-01, TC-INT-02, TC-INT-03
# Authors: Robert Ohly (041092144), Daniel Bierman (041106553), Michael Dagher (041088202), Nicholas Jacques (041110677)
Resource    ../pages/Common.resource
Resource    ../pages/ProductDetailPage.resource
Resource    ../pages/CartPage.resource
Resource    ../pages/CheckoutPage.resource
Resource    ../pages/OrderConfirmationPage.resource
Resource    ../pages/OrderHistoryPage.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-INT-01 Cart Items Persist After Login
    [Documentation]    Verify that items added to the cart as a guest are 
    ...               retained after the user logs into an account.
    [Tags]    high    cart    FR-04
    # Step 1: Open site and add item as guest
    Open Home Page
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    # Step 2: Verify item is in cart before login
    Verify Item In Cart
    
    # Step 3: Login with an existing account
    # Note: Using a unique email for a fresh account to ensure a clean test
    ${email}=    Generate Unique Email
    Register New Customer    Cart    Persist    ${email}    ${TEST_PASSWORD}
    
    # Step 4: Navigate back to cart and verify item still exists
    Go To    ${URL}cart?action=show
    Verify Item In Cart

TC-INT-02 Cart Total Updates Correctly After Quantity Change
    [Documentation]    Verify that changing the quantity of an item 
    ...               correctly updates the line total.
    [Tags]    medium    cart    FR-04
    Open Home Page
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    
    # Step 1: Set quantity to 2
    Change Item Quantity    2
    
    # Step 2: Verify the line total updates
    Verify Line Total Updates
    # Note: In a production environment, you might fetch the unit price 
    # and use 'Evaluate' to check the math specifically.

TC-INT-03 Order Recorded In History After Checkout
    [Documentation]    Verify that a successfully placed order appears 
    ...               in the customer's Order History.
    [Tags]    high    order-history    FR-09
    # Step 1: Setup - Login and place an order
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    History    Tester    ${email}    ${TEST_PASSWORD}
    
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    Go To Checkout
    Fill Shipping Address
    Confirm Address
    Select Shipping Method
    Confirm Shipping
    Select Payment By Check
    Accept Terms And Place Order
    
    # Step 2: Verify confirmation and get reference
    Verify Order Confirmation Displayed
    ${reference}=    Get Clean Order Reference
    
    # Step 3: Navigate to Order History and verify the order is listed
    Go To Order History
    Verify Order History Displayed
    Page Should Contain    ${reference}