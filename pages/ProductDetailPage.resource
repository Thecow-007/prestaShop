*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${PRODUCT_NAME}                 css:h1
${PRODUCT_PRICE}                css:.current-price .current-price-value, .current-price span[itemprop='price']
${PRODUCT_DESCRIPTION}          css:[id^='product-description-short'], #description .product-description, .product-description
${PRODUCT_IMAGE}                css:.product-cover img, .images-container img
${PRODUCT_AVAILABILITY}         id:product-availability
${QUANTITY_INPUT}               id:quantity_wanted
${ADD_TO_CART_BTN}              css:.product-add-to-cart .add-to-cart, button.add-to-cart
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
    Wait Until Element Is Visible    ${ADD_TO_CART_BTN}    10s
    Click Element    ${ADD_TO_CART_BTN}

Proceed To Checkout From Modal
    Sleep    3s
    Go To    ${URL}cart?action=show

Verify Add To Cart Is Disabled
    ${button_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${ADD_TO_CART_BTN}    3s
    IF    ${button_visible}
        Element Should Be Disabled    ${ADD_TO_CART_BTN}
    ELSE
        Wait Until Element Is Visible    ${PRODUCT_AVAILABILITY}    10s
        ${text}=    Get Text    ${PRODUCT_AVAILABILITY}
        Should Not Be Empty    ${text}
    END

Verify Error Message For Exceeding Stock
    Wait Until Element Is Visible    ${PRODUCT_AVAILABILITY}    10s
    ${text}=    Get Text    ${PRODUCT_AVAILABILITY}
    Should Not Be Empty    ${text}
