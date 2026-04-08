*** Settings ***
Resource          ../pages/Common.resource
Resource          ../pages/BrowsingPage.resource
Test Setup        Open Home Page
Test Teardown     Close Browser

*** Test Cases ***
TC-03-01 Browse Products by Category 
    Hover Accessories And Select Stationery
    Wait Until Page Contains    notebook    10s
    Verify Product Count    3

TC-03-02 Filter Products by Price Range 
    Open Accessories Category
    Verify Product Count    11
    Wait Until Page Contains    Price    10s
    Set Price Range Exactly    18.0    20.0
    Verify Product Count    3
    Wait Until Page Contains    €18.00 - €20.00    10s

TC-03-03 Sort Products by Price Ascending
    Open Accessories Category
    Sort Products By    Price, low to high
    
    # Validation Logic
    ${actual_prices}=      Get All Product Prices As Floats
    ${expected_prices}=    Evaluate    sorted(${actual_prices})
    Lists Should Be Equal  ${actual_prices}    ${expected_prices}
    Log    Sorted Prices: ${actual_prices}

TC-03-04 Filter Products by Colour 
    Open Accessories Category
    Wait Until Page Contains    Color    10s
    Filter By Color             Black
    
    Verify Product Count        3
    Wait Until Page Contains    Color: Black    10s