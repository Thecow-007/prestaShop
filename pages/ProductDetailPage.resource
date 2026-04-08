*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${PRODUCT_NAME}                 css:h1
${PRODUCT_PRICE}                css:.product__price
${PRODUCT_DESCRIPTION}          css:#product_description
${PRODUCT_IMAGE}                css:.product__images img
${PRODUCT_AVAILABILITY}         id:product-availability
${QUANTITY_INPUT}               id:quantity_wanted
${ADD_TO_CART_BTN}              css:.product__add-to-cart-button
${ADD_TO_CART_MODAL}            id:blockcart-modal
${PROCEED_TO_CHECKOUT_MODAL}    css:#blockcart-modal .cart-content-btn a.btn-primary

*** Keywords ***
Verify Product Details Displayed
    Wait Until Element Is Visible    ${PRODUCT_NAME}    10s
    Element Should Be Visible        ${PRODUCT_PRICE}
    Element Should Be Visible        ${PRODUCT_DESCRIPTION}
    Element Should Be Visible        ${PRODUCT_IMAGE}

Set Quantity
    [Arguments]    ${qty}
    Wait Until Element Is Visible    ${QUANTITY_INPUT}    5s
    # PrestaShop quantity uses an input with up/down arrows. We clear with JS or double click and type.
    Press Keys    ${QUANTITY_INPUT}    CTRL+a+BACKSPACE
    Input Text    ${QUANTITY_INPUT}    ${qty}
    Press Keys    ${QUANTITY_INPUT}    ENTER
    Click Element    css:body
    # Allow PrestaShop to complete its backend debounce validation before adding to cart
    Sleep    3s

Add To Cart
    Wait Until Element Is Visible    ${ADD_TO_CART_BTN}    5s
    Sleep    1s
    Execute Javascript    document.querySelector('.product__add-to-cart-button').click()

Proceed To Checkout From Modal
    Sleep    3s
    Go To    ${URL}cart?action=show

Verify Add To Cart Is Disabled
    Wait Until Element Is Visible    ${ADD_TO_CART_BTN}    5s
    Element Should Be Disabled       ${ADD_TO_CART_BTN}

Verify Error Message For Exceeding Stock
    Wait Until Element Is Visible    ${PRODUCT_AVAILABILITY}    10s
    ${text}=    Get Text    ${PRODUCT_AVAILABILITY}
    Should Not Be Empty    ${text}
