*** Settings ***
# OrderConfirmationPage.resource — Page object for the order confirmation page
# Displayed after a successful checkout; shows order reference and summary
Library    SeleniumLibrary

*** Variables ***
# Order confirmation page locators
${ORDER_CONF_SECTION}       css:#content-hook_order_confirmation, .page-order-confirmation
${ORDER_CONF_HEADING}       css:.page-order-confirmation .card-title, #content-hook_order_confirmation h3
${ORDER_REFERENCE}          css:#order-details
${ORDER_ITEMS}              css:.order-confirmation-table, .order-details
${ORDER_TOTAL}              css:.total-value, .order-confirmation-table .total-value

*** Keywords ***
Verify Order Confirmation Displayed
    [Documentation]    Verify that the order confirmation page is shown after checkout
    # Wait for the confirmation section to appear
    Wait Until Element Is Visible    ${ORDER_CONF_SECTION}    15s
    # Verify the page contains confirmation text
    ${page_text}=    Get Text    css:body
    Should Contain Any    ${page_text}    order is confirmed    Order confirmation    Your order
    ...    msg=Order confirmation page text not found

Get Order Reference
    [Documentation]    Retrieve the order reference number from the confirmation page
    Wait Until Element Is Visible    ${ORDER_REFERENCE}    10s
    ${reference_text}=    Get Text    ${ORDER_REFERENCE}
    Log    Order reference details: ${reference_text}
    RETURN    ${reference_text}
