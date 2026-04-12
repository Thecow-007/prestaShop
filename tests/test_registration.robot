*** Settings ***
Resource    ../pages/Common.resource
Resource    ../pages/RegisterPage.resource
Test Setup       Run Keywords    Generate Registration Data    AND    Open Home Page    AND    Go To Login    AND    Go To Register 
Test Teardown    Close Browser

*** Test Cases ***
TC-01-01 Successful Account Registration with Valid Inputs
    IF    '${TITLE}' == 'Mr'
        Click Element    ${MR_CHECKBOX}
    ELSE IF    '${TITLE}' == 'Mrs'
        Click Element    ${MRS_CHECKBOX}
    END
    Input Text      ${FIRSTNAME_FIELD}    ${FIRST_NAME}  
    Input Text      ${LASTNAME_FIELD}     ${LAST_NAME}    
    Input Text      ${EMAIL_FIELD}        ${EMAIL}
    Input Text      ${PASSWORD_FIELD}     ${TEST_PASSWORD}
    Input Text      ${BIRTHDAY_FIELD}     ${DOB}
    Select Checkbox    ${PRIVACY_CHECKBOX}
    Select Checkbox    ${TOC_CHECKBOX}
    Click Button    ${SUBMIT_BUTTON}
    Wait Until Element Is Visible    ${ACCOUNT_LINK}    10s
    Element Should Contain    ${ACCOUNT_LINK}    ${FULL_NAME}

TC-01-03 Registration Rejected for Missing Required Fields 
    IF    '${TITLE}' == 'Mr'
        Wait Until Element Is Visible    ${MR_CHECKBOX}    10s
        Click Element    ${MR_CHECKBOX}
    ELSE IF    '${TITLE}' == 'Mrs'
        Wait Until Element Is Visible    ${MRS_CHECKBOX}    10s
        Click Element    ${MRS_CHECKBOX}
    END
    Input Text      ${BIRTHDAY_FIELD}     ${DOB}
    Click Button    ${SUBMIT_BUTTON}
    # Form should not submit due to HTML5 validation - verify we're still on registration
    Sleep    2s
    Page Should Contain Element    ${FIRSTNAME_FIELD}
    Page Should Contain    Create an account