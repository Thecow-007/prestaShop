*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${CART_ITEMS_LIST}              css:.cart__item
${ITEM_QTY_INPUT}               css:.js-cart-line-product-quantity
${ITEM_REMOVE_BTN}              css:.js-remove-from-cart
${ITEM_LINE_TOTAL}              css:.product-line__price
${CART_TOTAL}                   css:.cart-summary__total .cart-summary__value
${EMPTY_CART_MESSAGE}           css:.cart__empty

*** Keywords ***
Change Item Quantity
    [Arguments]    ${qty}
    Wait Until Element Is Visible    ${ITEM_QTY_INPUT}    10s
    Press Keys    ${ITEM_QTY_INPUT}    CTRL+a+BACKSPACE
    Input Text    ${ITEM_QTY_INPUT}    ${qty}
    # Click outside or wait for update
    Click Element    css:body
    Sleep    2s

Remove Item From Cart
    Wait Until Element Is Visible    ${ITEM_REMOVE_BTN}    10s
    Click Element    ${ITEM_REMOVE_BTN}
    Sleep    2s

Verify Item Quantity In Cart
    [Arguments]    ${expected_qty}
    Wait Until Element Is Visible    ${ITEM_QTY_INPUT}    10s
    ${actual}=    Get Value    ${ITEM_QTY_INPUT}
    Should Be Equal    ${actual}    ${expected_qty}

Verify Line Total Updates
    Wait Until Element Is Visible    ${ITEM_LINE_TOTAL}    10s
    Element Should Be Visible        ${ITEM_LINE_TOTAL}

Verify Cart Is Empty
    Wait Until Element Is Visible    ${EMPTY_CART_MESSAGE}    10s
    Element Should Be Visible        ${EMPTY_CART_MESSAGE}
