*** Settings ***
# test_checkout.robot — Automation tests for the checkout flow (FR-08) and order confirmation (FR-09)
# Test cases: TC-08-01, TC-08-02, TC-08-03, TC-09-01
# Author: Daniel Bierman (041106553)
Resource    ../pages/Common.resource
Resource    ../pages/ProductDetailPage.resource
Resource    ../pages/CartPage.resource
Resource    ../pages/CheckoutPage.resource
Resource    ../pages/OrderConfirmationPage.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-08-01 Complete Multi-Step Checkout Successfully
    [Documentation]    Verify that a logged-in user can complete the full checkout flow:
    ...    add product to cart, fill address, select shipping, pay by check, and place order.
    [Tags]    high    checkout    FR-08
    # Step 1: Open site, register a fresh test account
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    Test    User    ${email}    ${TEST_PASSWORD}
    # Step 2: Add the Hummingbird Printed Sweater to the cart
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    # Step 3: Navigate to checkout
    Go To Checkout
    # Step 4: Fill shipping address (new account has no address yet)
    Fill Shipping Address
    Confirm Address
    # Step 5: Select shipping method
    Select Shipping Method
    Confirm Shipping
    # Step 6: Select "Payment by Check" and place the order
    Select Payment By Check
    Accept Terms And Place Order
    # Step 7: Verify the order confirmation page is displayed
    Verify Order Confirmation Displayed

TC-08-02 Checkout Blocked When Required Fields Missing
    [Documentation]    Verify that checkout cannot proceed when required address fields are empty.
    ...    The form should display validation errors and remain on the address step.
    [Tags]    high    checkout    FR-08
    # Step 1: Open site, register a fresh test account
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    Test    User    ${email}    ${TEST_PASSWORD}
    # Step 2: Add product to cart and go to checkout
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    Go To Checkout
    # Step 3: Attempt to submit the address step with empty required fields
    Try Confirm Address Without Required Fields
    # Step 4: Verify a validation error is shown
    Verify Checkout Validation Error

TC-08-03 Unauthenticated User Can Complete Checkout
    [Documentation]    Verify that a user who is NOT logged in can complete checkout as a guest.
    ...    PrestaShop supports guest checkout without requiring account creation.
    [Tags]    high    checkout    FR-08
    # Step 1: Open site WITHOUT logging in
    Open Home Page
    # Step 2: Add product to cart
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    # Step 3: Go to checkout — personal info step should appear for guest
    Go To Checkout
    # Step 4: Fill guest personal information
    ${email}=    Generate Unique Email
    Fill Guest Personal Info    Guest    Tester    ${email}
    # Step 5: Fill shipping address
    Fill Shipping Address
    Confirm Address
    # Step 6: Select shipping method
    Select Shipping Method
    Confirm Shipping
    # Step 7: Pay by check and place order
    Select Payment By Check
    Accept Terms And Place Order
    # Step 8: Verify order confirmation
    Verify Order Confirmation Displayed

TC-09-01 Order Confirmation Page Displays After Purchase
    [Documentation]    Verify that after completing a purchase, the order confirmation page
    ...    displays the order reference number and order details.
    [Tags]    high    checkout    FR-09
    # Step 1: Open site and register
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    Test    User    ${email}    ${TEST_PASSWORD}
    # Step 2: Add product and go through full checkout
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
    # Step 3: Verify the confirmation page shows order details
    Verify Order Confirmation Displayed
    ${reference}=    Get Order Reference
    Log    Order placed successfully. Reference: ${reference}
