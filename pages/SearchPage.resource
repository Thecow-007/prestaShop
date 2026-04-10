*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${SEARCH_BAR}             css:#search_widget input[name="s"]
${PRODUCT_IMAGE}          css:article.product-miniature

*** Keywords ***
Input Search
    [Arguments]    ${search_text}
    Wait Until Element Is Visible    ${SEARCH_BAR}    10s
    Input Text    ${SEARCH_BAR}    ${search_text}
    Press Keys    ${SEARCH_BAR}    ENTER

Verify Search Match
    [Arguments]    ${search_text}
    Wait Until Page Contains    ${search_text}    10s
    Page Should Contain Element    ${PRODUCT_IMAGE}

Verify No Search Match
    [Arguments]    ${search_text}
    Wait Until Page Contains    No matches were found for your search    10s

Verify Product Count
    [Arguments]    ${expected_count}
    IF    ${expected_count} == 1
        Page Should Contain    There is 1 product.
    ELSE
        Page Should Contain    There are ${expected_count} products.
    END
    Page Should Contain Element    ${PRODUCT_IMAGE}    limit=${expected_count}
