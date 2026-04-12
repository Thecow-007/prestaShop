*** Settings ***
# test_search.robot — Automation tests for the product search feature (FR-04)
# Test cases: TC-04-01, TC-04-02
# FR-04: Product search
# Authors: Robert Ohly (041092144), Daniel Bierman (041106553), Michael Dagher (041088202), Nicholas Jacques (041110677)
Resource    ../pages/Common.resource
Resource    ../pages/SearchPage.resource
Test Setup    Open Home Page
Test Teardown    Close Browser

*** Test Cases ***
TC-04-01 Search Returns Relevant Results for Valid Keyword
    [Documentation]    Verify that searching for a valid keyword returns matching products.
    [Tags]    high    search    FR-04
    # Step 1: Search for "shirt"
    Input Search    shirt
    # Step 2: Verify the results contain the search term and exactly 1 product
    Verify Search Match    shirt
    Verify Product Count    1

TC-04-02 Search Displays No Results Message for Unmatched Query
    [Documentation]    Verify that searching for a nonsense string displays the "no results" message.
    [Tags]    medium    search    FR-04
    # Step 1: Search for a term that matches nothing
    Input Search    qwerty1234
    # Step 2: Verify the no-results message is shown
    Verify No Search Match    qwerty1234