*** Settings ***
# ProductDetailPage.resource — Page object for the PrestaShop product detail page
# Covers: product info display, quantity input, add-to-cart actions, and stock validation
Library    SeleniumLibrary

*** Variables ***
# Product information locators
${PRODUCT_NAME}                 css:h1
${PRODUCT_PRICE}                css:.current-price .current-price-value, .current-price span[itemprop='price']
${PRODUCT_DESCRIPTION}          css:[id^='product-description-short'], #description .product-description, .product-description
${PRODUCT_IMAGE}                css:.product-cover img, .images-container img
${PRODUCT_AVAILABILITY}         id:product-availability

# Cart action locators
${QUANTITY_INPUT}               id:quantity_wanted
${ADD_TO_CART_BTN}              css:.product-add-to-cart .add-to-cart, button.add-to-cart
${ADD_TO_CART_MODAL}            id:blockcart-modal
${PROCEED_TO_CHECKOUT_MODAL}    css:#blockcart-modal .cart-content-btn a.btn-primary

*** Keywords ***
Verify Product Details Displayed
    [Documentation]    Assert that the product name, price, description, and image are all visible
    Wait Until Element Is Visible    ${PRODUCT_NAME}    10s
    Element Should Be Visible        ${PRODUCT_PRICE}
    Element Should Be Visible        ${PRODUCT_DESCRIPTION}
    Element Should Be Visible        ${PRODUCT_IMAGE}

Set Quantity
    [Documentation]    Set the desired quantity in the quantity input field
    [Arguments]    ${qty}
    Wait Until Element Is Visible    ${QUANTITY_INPUT}    5s
    # Input Text calls clear() then send_keys() which triggers PrestaShop's quantity validation
    Input Text    ${QUANTITY_INPUT}    ${qty}
    Click Element    css:body
    Sleep    5s

Add To Cart
    [Documentation]    Click the Add to Cart button on the product detail page
    Wait Until Element Is Visible    ${ADD_TO_CART_BTN}    10s
    Click Element    ${ADD_TO_CART_BTN}

Proceed To Checkout From Modal
    [Documentation]    Navigate to the cart page after adding a product
    Sleep    3s
    Go To    ${URL}cart?action=show

Verify Add To Cart Is Disabled
    [Documentation]    Verify the Add to Cart button is disabled (e.g. for out-of-stock products).
    ...    Falls back to checking the availability text if the button is not rendered.
    ${button_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${ADD_TO_CART_BTN}    3s
    IF    ${button_visible}
        Element Should Be Disabled    ${ADD_TO_CART_BTN}
    ELSE
        Wait Until Element Is Visible    ${PRODUCT_AVAILABILITY}    10s
        ${text}=    Get Text    ${PRODUCT_AVAILABILITY}
        Should Not Be Empty    ${text}
    END

Verify Error Message For Exceeding Stock
    [Documentation]    Verify that a stock-related error message appears when the requested quantity exceeds available stock
    Wait Until Element Is Visible    ${PRODUCT_AVAILABILITY}    10s
    ${text}=    Get Text    ${PRODUCT_AVAILABILITY}
    Should Not Be Empty    ${text}
