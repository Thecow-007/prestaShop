*** Settings ***
# test_registration.robot — Automation tests for customer account registration (FR-01)
# Test cases: TC-01-01, TC-01-03
# FR-01: Customer registration
# Authors: Robert Ohly (041092144), Daniel Bierman (041106553), Michael Dagher (041088202), Nicholas Jacques (041110677)
Resource    ../pages/Common.resource
Resource    ../pages/RegisterPage.resource
Test Setup       Run Keywords    Generate Registration Data    AND    Open Home Page    AND    Go To Login    AND    Go To Register
Test Teardown    Close Browser

*** Test Cases ***
TC-01-01 Successful Account Registration with Valid Inputs
    [Documentation]    Verify that a new customer can register with valid randomly-generated
    ...    data (name, email, password, DOB) and is redirected to their account page.
    [Tags]    high    registration    FR-01
    # Step 1: Select the gender title if applicable
    IF    '${TITLE}' == 'Mr'
        Click Element    ${MR_CHECKBOX}
    ELSE IF    '${TITLE}' == 'Mrs'
        Click Element    ${MRS_CHECKBOX}
    END
    # Step 2: Fill in all registration form fields with generated data
    Input Text      ${FIRSTNAME_FIELD}    ${FIRST_NAME}
    Input Text      ${LASTNAME_FIELD}     ${LAST_NAME}
    Input Text      ${EMAIL_FIELD}        ${EMAIL}
    Input Text      ${PASSWORD_FIELD}     ${TEST_PASSWORD}
    Input Text      ${BIRTHDAY_FIELD}     ${DOB}
    # Step 3: Accept consent checkboxes and submit the form
    Select Checkbox    ${PRIVACY_CHECKBOX}
    Select Checkbox    ${TOC_CHECKBOX}
    Click Button    ${SUBMIT_BUTTON}
    # Step 4: Verify the account was created by checking the account link shows the full name
    Wait Until Element Is Visible    ${ACCOUNT_LINK}    10s
    Element Should Contain    ${ACCOUNT_LINK}    ${FULL_NAME}

TC-01-03 Registration Rejected for Missing Required Fields
    [Documentation]    Verify that submitting the registration form with required fields
    ...    left empty is rejected by HTML5 validation and the form remains on the page.
    [Tags]    high    registration    FR-01
    # Step 1: Select the gender title if applicable
    IF    '${TITLE}' == 'Mr'
        Wait Until Element Is Visible    ${MR_CHECKBOX}    10s
        Click Element    ${MR_CHECKBOX}
    ELSE IF    '${TITLE}' == 'Mrs'
        Wait Until Element Is Visible    ${MRS_CHECKBOX}    10s
        Click Element    ${MRS_CHECKBOX}
    END
    # Step 2: Only fill in the optional birthday field, leaving required fields empty
    Input Text      ${BIRTHDAY_FIELD}     ${DOB}
    Click Button    ${SUBMIT_BUTTON}
    # Step 3: Verify the form did not submit — we should still be on the registration page
    Sleep    2s
    Page Should Contain Element    ${FIRSTNAME_FIELD}
    Page Should Contain    Create an account