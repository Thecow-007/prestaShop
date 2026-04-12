*** Settings ***
# test_product_detail.robot — Automation tests for the product detail page (FR-05)
# Test cases: TC-05-01, TC-05-02
# FR-05: View product detail information
# Author: Daniel Bierman (041106553)
Resource    ../pages/Common.resource
Resource    ../pages/ProductDetailPage.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-05-01 Product Detail Page Displays All Required Information
    [Documentation]    Verify that navigating to an in-stock product displays all
    ...    required product information (name, price, description, etc.).
    [Tags]    high    product-detail    FR-05
    # Step 1: Open the site and navigate to an in-stock product
    Open Home Page
    Go To In-Stock Product
    # Step 2: Verify all expected product details are visible on the page
    Verify Product Details Displayed

TC-05-02 Out-of-Stock Product Cannot Be Added to Cart
    [Documentation]    Verify that an out-of-stock product still displays its details
    ...    but the Add to Cart button is disabled to prevent ordering.
    [Tags]    high    product-detail    FR-05
    # Step 1: Open the site and navigate to an out-of-stock product
    Open Home Page
    Go To Out-Of-Stock Product
    # Step 2: Verify product details are still shown
    Verify Product Details Displayed
    # Step 3: Verify the Add to Cart button is disabled
    Verify Add To Cart Is Disabled
