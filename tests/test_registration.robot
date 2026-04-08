*** Settings ***
Resource    ../pages/Common.resource
Resource    ../pages/RegisterPage.resource
Test Setup       Generate Registration Data
Test Teardown    Close Browser

*** Test Cases ***
TC-01-01 Successful Account Registration with Valid Inputs
    Open Home Page
    Go To Login
    Go To Register
    IF    '${TITLE}' == 'Mr'
        Click Element    ${MR_CHECKBOX}
    ELSE IF    '${TITLE}' == 'Mrs'
        Click Element    ${MRS_CHECKBOX}
    END
    Input Text      ${FIRSTNAME_FIELD}    ${FIRST_NAME}  
    Input Text      ${LASTNAME_FIELD}     ${LAST_NAME}    
    Input Text      ${EMAIL_FIELD}        ${EMAIL}
    Input Text      ${PASSWORD_FIELD}     ${PASSWORD}
    Input Text      ${BIRTHDAY_FIELD}     ${DOB}
    Select Checkbox    ${PRIVACY_CHECKBOX}
    Select Checkbox    ${TOC_CHECKBOX}
    Click Button    ${SUBMIT_BUTTON}
    Wait Until Page Contains    ${FULL_NAME}    10s

TC-01-03 Registration Rejected for Missing Required Fields 
    Open Home Page
    Go To Login
    Go To Register
    IF    '${TITLE}' == 'Mr'
        Wait Until Element Is Visible    ${MR_CHECKBOX}    10s
        Click Element    ${MR_CHECKBOX}
    ELSE IF    '${TITLE}' == 'Mrs'
        Wait Until Element Is Visible    ${MRS_CHECKBOX}    10s
        Click Element    ${MRS_CHECKBOX}
    END
    Input Text      ${BIRTHDAY_FIELD}     ${DOB}
    Click Button    ${SUBMIT_BUTTON}
    Wait Until Page Contains Element    ${WAS_VALIDATED}    10s