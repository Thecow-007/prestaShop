*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${LOGIN_EMAIL_FIELD}       css=#field-email
${LOGIN_PASSWORD_FIELD}    css=#field-password
${LOGIN_SUBMIT_BUTTON}     css=#submit-login
${USER_MENU_BUTTON}        css=#userMenuButton
${LOGOUT_LINK}             css=#_desktop_ps_customersignin > div > div > div > a:nth-child(8)

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
    Click Button    ${USER_MENU_BUTTON}
    Click Link      ${LOGOUT_LINK}

Verify User Is Logged In
    [Arguments]    ${username}
    Wait Until Page Contains    ${username}    10s

Verify Login Failed
    Wait Until Page Contains    Authentication failed.    10s