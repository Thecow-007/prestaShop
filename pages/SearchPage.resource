*** Settings ***
# SearchPage.resource — Page object for the PrestaShop product search feature
# Covers: search input, result verification, no-results handling, and product count
Library    SeleniumLibrary

*** Variables ***
# Search form and result locators
${SEARCH_BAR}             css:#search_widget input[name="s"]
${PRODUCT_IMAGE}          css:article.product-miniature

*** Keywords ***
Input Search
    [Documentation]    Type a search query into the search bar and press Enter
    [Arguments]    ${search_text}
    Wait Until Element Is Visible    ${SEARCH_BAR}    10s
    Input Text    ${SEARCH_BAR}    ${search_text}
    Press Keys    ${SEARCH_BAR}    ENTER

Verify Search Match
    [Documentation]    Assert that the search results page contains the query text and at least one product
    [Arguments]    ${search_text}
    Wait Until Page Contains    ${search_text}    10s
    Page Should Contain Element    ${PRODUCT_IMAGE}

Verify No Search Match
    [Documentation]    Assert that the "no matches" message is displayed for an unmatched query
    [Arguments]    ${search_text}
    Wait Until Page Contains    No matches were found for your search    10s

Verify Product Count
    [Documentation]    Assert that the page displays the expected number of product results
    [Arguments]    ${expected_count}
    IF    ${expected_count} == 1
        Page Should Contain    There is 1 product.
    ELSE
        Page Should Contain    There are ${expected_count} products.
    END
    Page Should Contain Element    ${PRODUCT_IMAGE}    limit=${expected_count}
