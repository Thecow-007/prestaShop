*** Settings ***
# test_cart.robot — Automation tests for cart functionality (FR-06, FR-07)
# Test cases: TC-06-01, TC-06-02, TC-07-01, TC-07-02, TC-07-03
# FR-06: Add items to cart   FR-07: Manage cart contents
# Author: Daniel Bierman (041106553)
Resource    ../pages/Common.resource
Resource    ../pages/ProductDetailPage.resource
Resource    ../pages/CartPage.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-06-01 Add Item to Cart with Valid Quantity
    [Documentation]    Verify that a user can add an in-stock product to the cart
    ...    with the default quantity of 1 and see it reflected in the cart.
    [Tags]    high    cart    FR-06
    # Step 1: Open the site and navigate to an in-stock product
    Open Home Page
    Go To In-Stock Product
    # Step 2: Add the product to the cart and proceed to the cart page
    Add To Cart
    Proceed To Checkout From Modal
    # Step 3: Verify the cart contains exactly 1 item
    Verify Item Quantity In Cart    1

TC-06-02 Adding Quantity Exceeding Stock is Rejected
    [Documentation]    Verify that setting a quantity higher than available stock
    ...    displays an error message and disables the Add to Cart button.
    [Tags]    high    cart    FR-06
    # Step 1: Open the site and navigate to an in-stock product
    Open Home Page
    Go To In-Stock Product
    # Step 2: Attempt to set an unreasonably high quantity
    Set Quantity    999
    # Step 3: Verify the store rejects the quantity and blocks the add action
    Verify Error Message For Exceeding Stock
    Verify Add To Cart Is Disabled

TC-07-01 Update Item Quantity in Cart Updates Total
    [Documentation]    Verify that changing the quantity of a cart item
    ...    correctly recalculates the line total price.
    [Tags]    medium    cart    FR-07
    # Step 1: Open the site and add a product to the cart
    Open Home Page
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    # Step 2: Change the item quantity to 2
    Change Item Quantity    2
    # Step 3: Verify the line total updates to reflect the new quantity
    Verify Line Total Updates

TC-07-02 Remove Item from Cart
    [Documentation]    Verify that a user can remove an item from the cart
    ...    and the cart becomes empty after removal.
    [Tags]    medium    cart    FR-07
    # Step 1: Open the site and add a product to the cart
    Open Home Page
    Go To In-Stock Product
    Add To Cart
    Proceed To Checkout From Modal
    # Step 2: Remove the item from the cart
    Remove Item From Cart
    # Step 3: Verify the cart is now empty
    Verify Cart Is Empty

TC-07-03 Empty Cart Displays Appropriate Message
    [Documentation]    Verify that visiting the cart without adding any items shows an empty cart message.
    [Tags]    low    cart    FR-07
    # Step 1: Open the site and navigate directly to the cart page without adding products
    Open Home Page
    Go To    ${URL}cart?action=show
    # Step 2: Verify the empty cart message is displayed
    Verify Cart Is Empty
