*** Settings ***
# CartPage.resource — Page object for the PrestaShop shopping cart page
# Covers: quantity updates, item removal, line total verification, and empty cart state
Library    SeleniumLibrary

*** Variables ***
# Cart item list and individual item locators
${CART_ITEMS_LIST}              css:.cart__item
${CART_ITEM}                    css:.cart-item
${ITEM_QTY_INPUT}               css:input.js-cart-line-product-quantity
${ITEM_REMOVE_BTN}              css:.remove-from-cart, .js-remove-from-cart

# Price and total locators
${ITEM_LINE_TOTAL}              css:.product-line-grid-right .current-price .price, .product-line-grid-right .product-price
${CART_TOTAL}                   css:.cart-summary .value, .cart-summary-line.cart-total .value

# Empty cart state locator
${EMPTY_CART_MESSAGE}           xpath=//*[contains(@class,'no-items') or contains(.,'There are no more items in your cart')]

*** Keywords ***
Change Item Quantity
    [Documentation]    Update the quantity of a cart item and wait for the cart to refresh
    [Arguments]    ${qty}
    Wait Until Element Is Visible    ${ITEM_QTY_INPUT}    10s
    Press Keys    ${ITEM_QTY_INPUT}    CTRL+a+BACKSPACE
    Input Text    ${ITEM_QTY_INPUT}    ${qty}
    # Click outside the input to trigger the AJAX cart update
    Click Element    css:body
    Sleep    2s

Remove Item From Cart
    [Documentation]    Click the remove button to delete an item from the cart
    Wait Until Element Is Visible    ${ITEM_REMOVE_BTN}    10s
    Click Element    ${ITEM_REMOVE_BTN}
    Sleep    2s

Verify Item Quantity In Cart
    [Documentation]    Assert that the cart item quantity input matches the expected value
    [Arguments]    ${expected_qty}
    Wait Until Element Is Visible    ${ITEM_QTY_INPUT}    10s
    ${actual}=    Get Value    ${ITEM_QTY_INPUT}
    Should Be Equal    ${actual}    ${expected_qty}

Verify Line Total Updates
    [Documentation]    Verify that the line total price element is visible after a quantity change
    Wait Until Element Is Visible    ${ITEM_LINE_TOTAL}    10s
    Element Should Be Visible        ${ITEM_LINE_TOTAL}

Verify Cart Is Empty
    [Documentation]    Verify that the empty cart message is displayed
    Wait Until Element Is Visible    ${EMPTY_CART_MESSAGE}    10s
    Element Should Be Visible        ${EMPTY_CART_MESSAGE}

Verify Item In Cart
    [Documentation]    Confirms presence of an item in the cart
    Wait Until Element Is Visible   ${CART_ITEM}  10s
    Element Should Be Visible       ${CART_ITEM}