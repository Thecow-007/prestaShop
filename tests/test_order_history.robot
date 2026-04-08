*** Settings ***
# test_order_history.robot — Automation tests for order history (FR-10)
# Test cases: TC-10-01, TC-10-02
# Author: Daniel Bierman (041106553)
Resource    ../pages/Common.resource
Resource    ../pages/ProductDetailPage.resource
Resource    ../pages/CartPage.resource
Resource    ../pages/CheckoutPage.resource
Resource    ../pages/OrderConfirmationPage.resource
Resource    ../pages/OrderHistoryPage.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-10-01 Logged-In User Can View Order History
    [Documentation]    Verify that a logged-in user who has placed an order can view their
    ...    order history page with at least one order listed.
    [Tags]    medium    order-history    FR-10
    # Step 1: Register a fresh test account
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    Test    User    ${email}    ${TEST_PASSWORD}
    # Step 2: Place an order so the account has order history
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
    Verify Order Confirmation Displayed
    # Step 3: Navigate to order history
    Go To Order History
    # Step 4: Verify at least one order is listed
    Verify Order History Displayed

TC-10-02 Order History Not Accessible When Logged Out
    [Documentation]    Verify behavior when accessing order history without being logged in.
    ...    Expected: user is redirected to the login page.
    ...    Note: Related to DEF-001 (order confirmation page accessible without authentication,
    ...    classified as Won't Fix). This test documents the current access control behavior.
    [Tags]    high    order-history    FR-10    DEF-001
    # Step 1: Open site without logging in
    Open Home Page
    # Step 2: Attempt to access the order history page directly
    Go To Order History
    # Step 3: Document whether the user is redirected to login
    Verify Order History Redirects To Login
