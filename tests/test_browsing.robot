*** Settings ***
# test_browsing.robot — Automation tests for product browsing, filtering, and sorting (FR-03)
# Test cases: TC-03-01, TC-03-02, TC-03-03, TC-03-04
# FR-03: Browse and filter product catalogue
# Authors: Robert Ohly (041092144), Daniel Bierman (041106553), Michael Dagher (041088202), Nicholas Jacques (041110677)
Resource          ../pages/Common.resource
Resource          ../pages/BrowsingPage.resource
Test Setup        Open Home Page
Test Teardown     Close Browser

*** Test Cases ***
TC-03-01 Browse Products by Category
    [Documentation]    Verify that navigating to a subcategory (Stationery) displays
    ...    the correct products filtered by that category.
    [Tags]    high    browsing    FR-03
    # Step 1: Hover over Accessories and click the Stationery subcategory
    Hover Accessories And Select Stationery
    # Step 2: Verify the Stationery category shows the expected products
    Wait Until Page Contains    notebook    10s
    Verify Product Count    3

TC-03-02 Filter Products by Price Range
    [Documentation]    Verify that the price range slider filters products correctly
    ...    and only products within the selected range are displayed.
    [Tags]    high    browsing    FR-03
    # Step 1: Open the Accessories category and confirm all products are listed
    Open Accessories Category
    Verify Product Count    11
    # Step 2: Apply a price range filter of 18–20
    Wait Until Page Contains    Price    10s
    Set Price Range Exactly    18    20
    # Step 3: Verify only 3 products fall within that price range
    Verify Product Count    3

TC-03-03 Sort Products by Price Ascending
    [Documentation]    Verify that sorting by "Price, low to high" orders products
    ...    in ascending price order.
    [Tags]    medium    browsing    FR-03
    # Step 1: Open the Accessories category
    Open Accessories Category
    # Step 2: Sort by price ascending
    Sort Products By    Price, low to high
    # Step 3: Collect all visible prices and verify they are in ascending order
    ${actual_prices}=      Get All Product Prices As Floats
    ${expected_prices}=    Evaluate    sorted(${actual_prices})
    Lists Should Be Equal  ${actual_prices}    ${expected_prices}
    Log    Sorted Prices: ${actual_prices}

TC-03-04 Filter Products by Colour
    [Documentation]    Verify that the colour facet filter narrows results to only
    ...    products matching the selected colour.
    [Tags]    medium    browsing    FR-03
    # Step 1: Open the Accessories category
    Open Accessories Category
    # Step 2: Apply the Black colour filter
    Wait Until Page Contains    Color    10s
    Filter By Color             Black
    # Step 3: Verify only 3 black products are shown and the active filter is visible
    Verify Product Count        3
    Wait Until Element Is Visible    css:#js-active-search-filters    10s