*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${LOGIN_EMAIL_FIELD}       id:field-email
${LOGIN_PASSWORD_FIELD}    id:field-password
${LOGIN_SUBMIT_BUTTON}     id:submit-login
${LOGOUT_LINK}             css:.user-info a.logout

${VALID_USER}        Test User
${VALID_EMAIL}       test@gmail.com
${VALID_PASSWORD}    Shp1DLHKhe6yAPR
${INVALID_PASSWORD}  WrongPassword

*** Keywords ***
Login With Credentials
    [Arguments]    ${email}    ${password}
    Input Text    ${LOGIN_EMAIL_FIELD}       ${email}
    Input Text    ${LOGIN_PASSWORD_FIELD}    ${password}
    Click Button    ${LOGIN_SUBMIT_BUTTON}

Logout User
    Wait Until Element Is Visible    ${LOGOUT_LINK}    10s
    Click Element    ${LOGOUT_LINK}

Verify User Is Logged In
    [Arguments]    ${username}
    Wait Until Page Contains    ${username}    10s

Verify Login Failed
    Wait Until Page Contains    Authentication failed.    10s
