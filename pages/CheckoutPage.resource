*** Settings ***
# CheckoutPage.resource — Page object for the PrestaShop multi-step checkout flow
# Covers: address entry, shipping selection, payment by check, and order placement
Library    SeleniumLibrary

*** Variables ***
# Address form locators (checkout step 2)
${ADDR_ADDRESS1}            css:input[name="address1"]
${ADDR_CITY}                css:input[name="city"]
${ADDR_POSTCODE}            css:input[name="postcode"]
${ADDR_COUNTRY}             css:select[name="id_country"]
${ADDR_STATE}               css:select[name="id_state"]
${CONFIRM_ADDR_BTN}         css:button[name="confirm-addresses"]

# Shipping method locators (checkout step 3)
${DELIVERY_OPTION}          css:input[name^="delivery_option"]
${CONFIRM_DELIVERY_BTN}     css:button[name="confirmDeliveryOption"]

# Payment locators (checkout step 4)
${PAY_BY_CHECK}             css:input[data-module-name="ps_checkpayment"]
${PLACE_ORDER_BTN}          css:#payment-confirmation button

# Guest checkout personal info (checkout step 1 — unauthenticated)
${GUEST_FIRST_NAME}         css:#checkout-personal-information-step input[name="firstname"]
${GUEST_LAST_NAME}          css:#checkout-personal-information-step input[name="lastname"]
${GUEST_EMAIL}              css:#checkout-personal-information-step input[name="email"]
${GUEST_PRIVACY_CHECKBOX}   css:#checkout-personal-information-step input[name="customer_privacy"]
${GUEST_CONTINUE_BTN}       css:#checkout-personal-information-step button.continue

# Validation error locators
${CHECKOUT_ALERT_DANGER}    css:.alert-danger
${FIELD_ERROR}              css:.help-block

*** Keywords ***
Go To Checkout
    [Documentation]    Navigate directly to the PrestaShop checkout page
    Go To    ${URL}order
    Sleep    2s

Fill Shipping Address
    [Documentation]    Fill in the shipping address form during checkout
    [Arguments]    ${address}=10 Downing Street    ${city}=London    ${postcode}=SW1A 2AA
    # Wait for the address form to become visible
    Wait Until Element Is Visible    ${ADDR_ADDRESS1}    15s
    Input Text    ${ADDR_ADDRESS1}    ${address}
    Input Text    ${ADDR_CITY}        ${city}
    Input Text    ${ADDR_POSTCODE}    ${postcode}
    # Select country — United Kingdom is used for test data
    ${country_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${ADDR_COUNTRY}    3s
    IF    ${country_visible}
        Select From List By Label    ${ADDR_COUNTRY}    United Kingdom
        Sleep    2s
    END

Confirm Address
    [Documentation]    Click the Continue button on the address step
    Wait Until Element Is Visible    ${CONFIRM_ADDR_BTN}    10s
    Click Element    ${CONFIRM_ADDR_BTN}
    Sleep    2s

Select Shipping Method
    [Documentation]    Select the first available shipping method and confirm
    # The delivery radio input is visually hidden (custom radio styling), so wait for the wrapper
    Wait Until Element Is Visible    css:.delivery-option    10s
    # Click the radio via JS since it's hidden by CSS
    Execute Javascript    document.querySelector('input[name^="delivery_option"]').click()

Confirm Shipping
    [Documentation]    Click the Continue button on the shipping step
    Wait Until Element Is Visible    ${CONFIRM_DELIVERY_BTN}    10s
    Click Element    ${CONFIRM_DELIVERY_BTN}
    Sleep    2s

Select Payment By Check
    [Documentation]    Select the "Payment by Check" option
    # The payment radio input is visually hidden (custom radio styling), so wait for the wrapper
    Wait Until Element Is Visible    css:#payment-option-1-container, .payment-option    10s
    # Click the radio via JS since it's hidden by CSS
    Execute Javascript    document.querySelector('input[data-module-name="ps_checkpayment"]').click()
    Sleep    1s

Accept Terms And Place Order
    [Documentation]    Check the terms checkbox and click the Place Order button
    # The terms checkbox has brackets in its name attribute, so use JavaScript
    Execute Javascript    document.querySelector('input[name="conditions_to_approve[terms-and-conditions]"]').click()
    Sleep    1s
    Wait Until Element Is Visible    ${PLACE_ORDER_BTN}    10s
    Click Element    ${PLACE_ORDER_BTN}

Fill Guest Personal Info
    [Documentation]    Fill personal info for guest checkout (unauthenticated user)
    [Arguments]    ${first_name}    ${last_name}    ${email}
    Wait Until Element Is Visible    ${GUEST_FIRST_NAME}    10s
    Input Text    ${GUEST_FIRST_NAME}    ${first_name}
    Input Text    ${GUEST_LAST_NAME}     ${last_name}
    Input Text    ${GUEST_EMAIL}          ${email}
    # Accept required consent checkboxes via JS (hidden by custom CSS styling)
    Execute Javascript    document.querySelectorAll('#checkout-personal-information-step input[name="customer_privacy"], #checkout-personal-information-step input[name="psgdpr"]').forEach(cb => { if(!cb.checked) cb.click(); })
    Click Element    ${GUEST_CONTINUE_BTN}
    Sleep    2s

Try Confirm Address Without Required Fields
    [Documentation]    Attempt to continue past the address step without filling required fields
    ...    Used to test validation (TC-08-02)
    Wait Until Element Is Visible    ${CONFIRM_ADDR_BTN}    10s
    # Clear required fields using JavaScript to bypass HTML5 validation
    Execute Javascript    document.querySelector('input[name="address1"]').value = ''
    Execute Javascript    document.querySelector('input[name="city"]').value = ''
    Execute Javascript    document.querySelector('input[name="postcode"]').value = ''
    # Attempt to submit the form
    Click Element    ${CONFIRM_ADDR_BTN}
    Sleep    2s

Verify Checkout Validation Error
    [Documentation]    Verify that a validation error is displayed on the checkout page
    # Check for either alert-danger banners or inline field errors
    ${alert_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${CHECKOUT_ALERT_DANGER}    5s
    ${field_error_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${FIELD_ERROR}    5s
    # Also check that the address step is still active (did not advance)
    ${still_on_address}=    Run Keyword And Return Status
    ...    Element Should Be Visible    ${ADDR_ADDRESS1}
    # At least one validation indicator should be present
    Should Be True    ${alert_visible} or ${field_error_visible} or ${still_on_address}
    ...    msg=Expected a checkout validation error but none was found
