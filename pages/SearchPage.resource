*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${SEARCH_BAR}             css:#ps_searchbar > form > input.js-search-input.form-control.ps-searchbar__input
${PRODUCT_IMAGE}          css:.product-miniature__image

*** Keywords ***
Input Search
    [Arguments]    ${search_text}
    Wait Until Element Is Visible    ${SEARCH_BAR}    10s
    Input Text    ${SEARCH_BAR}    ${search_text}
    Press Keys    ${SEARCH_BAR}    ENTER

Verify Search Match
    [Arguments]    ${search_text}
    Page Should Contain    Search results for "${search_text}"
    Page Should Contain Element    ${PRODUCT_IMAGE}

Verify No Search Match
    [Arguments]    ${search_text}
    Page Should Contain    No search results for "${search_text}"    10s
    Page Should Contain    Search again what you are looking for.

Verify Product Count
    [Arguments]    ${expected_count}
    IF    ${expected_count} == 1
        Page Should Contain    There is 1 product.
    ELSE
        Page Should Contain    There are ${expected_count} products.
    END
    Page Should Contain Element    ${PRODUCT_IMAGE}    limit=${expected_count}