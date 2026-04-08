*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${ACCESSORIES_LINK}       css=#top-menu > li:nth-child(2) > div.ps-mainmenu__tree-item-wrapper > a
${STATIONERY_LINK}        css=#submenu-category-6 > div > div > div.submenu__left.col-sm-3 > a.submenu__left-item.active
${SORT_DROPDOWN}          id:sort_dropdown_button
${PRODUCT_IMAGE}          css:.product-miniature__image
${PRODUCT_PRICE}          css:.product-miniature__price

*** Keywords ***
Open Accessories Category
    Wait Until Element Is Visible    ${ACCESSORIES_LINK}    10s
    Click Link    ${ACCESSORIES_LINK}

Hover Accessories And Select Stationery
    Wait Until Element Is Visible    ${ACCESSORIES_LINK}    10s
    Mouse Over    ${ACCESSORIES_LINK}
    Wait Until Element Is Visible    ${STATIONERY_LINK}    10s
    Click Element    ${STATIONERY_LINK}

Set Price Range Exactly
    [Arguments]    ${min}    ${max}
    Execute Javascript    document.querySelector('.noUi-target').noUiSlider.set([${min}, ${max}]);

Filter By Color
    [Arguments]    ${color_name}
    Click Button    css=#search-filters > div > section:nth-child(5) > button
    Wait Until Page Contains    ${color_name}    10s
    Click Element    xpath://label[contains(., '${color_name}')]

Sort Products By
    [Arguments]    ${sort_option_text}
    Wait Until Element Is Visible    ${SORT_DROPDOWN}    10s
    Click Button    ${SORT_DROPDOWN}
    Click Link    css=#js-product-list-top > div > div.products__sort > div.products__sort-dropdown > div > a:nth-child(5)
    Wait Until Page Contains    ${sort_option_text}    10s
    Sleep    1s

Verify Product Count
    [Arguments]    ${expected_count}
    Wait Until Page Contains    There are ${expected_count} products.    10s
    Page Should Contain Element    ${PRODUCT_IMAGE}    limit=${expected_count}

Get All Product Prices As Floats
    ${elements}=    Get WebElements    ${PRODUCT_PRICE}
    ${prices}=    Create List
    FOR    ${el}    IN    @{elements}
        ${text}=    Get Text    ${el}
        ${value}=    Evaluate    float('${text}'.removeprefix('€').replace(',', ''))
        Append To List    ${prices}    ${value}
    END
    RETURN    ${prices}
