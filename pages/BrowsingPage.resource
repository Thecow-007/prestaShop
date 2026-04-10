*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables ***
${ACCESSORIES_LINK}       css:#category-6 > a
${STATIONERY_LINK}        css:#category-7 > a
${SORT_DROPDOWN}          css:div.products-sort-order button.select-title
${PRODUCT_IMAGE}          css:article.product-miniature
${PRODUCT_PRICE}          css:span.price

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
    Execute Javascript
    ...    var $slider = jQuery('.ui-slider');
    ...    $slider.slider('values', 0, ${min});
    ...    $slider.slider('values', 1, ${max});
    ...    var stopFn = $slider.slider('option', 'stop');
    ...    if (stopFn) stopFn.call($slider[0], null, {values: [${min}, ${max}], handle: $slider.find('.ui-slider-handle')[1]});
    Sleep    5s

Filter By Color
    [Arguments]    ${color_name}
    Scroll Element Into View    css:section[data-name="Color"] .facet-title
    Click Element    css:section[data-name="Color"] .facet-title
    Sleep    1s
    Click Element    xpath://section[@data-name='Color']//a[contains(text(), '${color_name}')]
    Sleep    2s

Sort Products By
    [Arguments]    ${sort_option_text}
    Wait Until Element Is Visible    ${SORT_DROPDOWN}    10s
    Click Element    ${SORT_DROPDOWN}
    Click Element    xpath://div[contains(@class,'products-sort-order')]//a[contains(text(),'${sort_option_text}')]
    Sleep    2s

Verify Product Count
    [Arguments]    ${expected_count}
    IF    ${expected_count} == 1
        Wait Until Page Contains    There is 1 product.    10s
    ELSE
        Wait Until Page Contains    There are ${expected_count} products.    10s
    END
    Page Should Contain Element    ${PRODUCT_IMAGE}    limit=${expected_count}

Get All Product Prices As Floats
    ${elements}=    Get WebElements    ${PRODUCT_PRICE}
    ${prices}=    Create List
    FOR    ${el}    IN    @{elements}
        ${text}=    Get Text    ${el}
        ${value}=    Evaluate    float('${text}'.replace('€', '').replace(',', '').strip())
        Append To List    ${prices}    ${value}
    END
    RETURN    ${prices}
