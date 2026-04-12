*** Settings ***
# ProfilePage.resource — Page object for the customer identity / profile page
# Covers personal information updates, email changes, and validation
Library    SeleniumLibrary

*** Variables ***
# Profile/Identity page locators
${IDENTITY_PAGE_HEADER}     css:.page-header h1
${CURRENT_PASSWORD_FIELD}   id:field-password
${NEW_PASSWORD_FIELD}       id:field-new_password
${PROFILE_SAVE_BTN}         css:#customer-form button.form-control-submit, button[data-link-action="save-customer"]

# Success and error message locators
${PROFILE_SUCCESS_ALERT}    css:.alert-success
${PROFILE_DANGER_ALERT}     css:.alert-danger
${PROFILE_FIELD_ERROR}      css:.help-block, .form-error-message

*** Keywords ***
Go To Profile Page
    [Documentation]    Navigate to the customer identity (profile) page
    Go To    ${URL}identity
    Wait Until Element Is Visible    ${IDENTITY_PAGE_HEADER}    10s

Update First Name
    [Documentation]    Clear and set a new first name on the profile page
    [Arguments]    ${new_first_name}
    # field-firstname is defined in Common.resource as ${FIELD_FIRST_NAME}
    Wait Until Element Is Visible    ${FIELD_FIRST_NAME}    10s
    # Clear the existing value and type the new one
    Press Keys    ${FIELD_FIRST_NAME}    CTRL+a+BACKSPACE
    Input Text    ${FIELD_FIRST_NAME}    ${new_first_name}

Update Email
    [Documentation]    Clear and set a new email on the profile page
    [Arguments]    ${new_email}
    Wait Until Element Is Visible    ${FIELD_EMAIL}    10s
    Press Keys    ${FIELD_EMAIL}    CTRL+a+BACKSPACE
    Input Text    ${FIELD_EMAIL}    ${new_email}

Enter New Password
    [Documentation]    Enter a new password in the new-password field
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${NEW_PASSWORD_FIELD}    10s
    Input Text    ${NEW_PASSWORD_FIELD}    ${password}

Enter Current Password
    [Documentation]    Enter the current password (required to save profile changes)
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${CURRENT_PASSWORD_FIELD}    10s
    Input Text    ${CURRENT_PASSWORD_FIELD}    ${password}

Save Profile
    [Documentation]    Click the Save button on the profile form
    # Accept required consent checkboxes (hidden by custom CSS styling)
    Execute Javascript    document.querySelectorAll('#customer-form input[name="customer_privacy"], #customer-form input[name="psgdpr"]').forEach(cb => { if(!cb.checked) cb.click(); })
    Wait Until Element Is Visible    ${PROFILE_SAVE_BTN}    10s
    Click Element    ${PROFILE_SAVE_BTN}
    Sleep    2s

Verify Profile Updated Successfully
    [Documentation]    Verify that a success alert is displayed after saving profile changes
    Wait Until Element Is Visible    ${PROFILE_SUCCESS_ALERT}    10s
    ${message}=    Get Text    ${PROFILE_SUCCESS_ALERT}
    Log    Profile update success: ${message}

Verify Profile Update Error
    [Documentation]    Verify that an error message is displayed for invalid profile changes
    # Check for either a danger alert, an inline field error, or HTML5 validation failure
    ${alert_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${PROFILE_DANGER_ALERT}    5s
    ${field_error_visible}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${PROFILE_FIELD_ERROR}    5s
    ${html5_invalid}=    Execute Javascript    return !document.getElementById('field-email').validity.valid
    Should Be True    ${alert_visible} or ${field_error_visible} or ${html5_invalid}
    ...    msg=Expected a profile validation error but none was found
