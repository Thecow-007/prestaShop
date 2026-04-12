*** Settings ***
# LoginPage.resource — Page object for the PrestaShop login page
# Covers: login form submission, logout, and login state verification
Library    SeleniumLibrary

*** Variables ***
# Login form locators
${LOGIN_EMAIL_FIELD}       id:field-email
${LOGIN_PASSWORD_FIELD}    id:field-password
${LOGIN_SUBMIT_BUTTON}     id:submit-login
${LOGOUT_LINK}             css:.user-info a.logout

# Default test credentials (VALID_EMAIL is overridden per suite via Suite Setup)
${VALID_USER}        Test User
${VALID_EMAIL}       test@gmail.com
${VALID_PASSWORD}    Shp1DLHKhe6yAPR
${INVALID_PASSWORD}  WrongPassword

*** Keywords ***
Login With Credentials
    [Documentation]    Submit the login form with the given email and password
    [Arguments]    ${email}    ${password}
    Input Text    ${LOGIN_EMAIL_FIELD}       ${email}
    Input Text    ${LOGIN_PASSWORD_FIELD}    ${password}
    Click Button    ${LOGIN_SUBMIT_BUTTON}

Logout User
    [Documentation]    Click the logout link in the site header
    Wait Until Element Is Visible    ${LOGOUT_LINK}    10s
    Click Element    ${LOGOUT_LINK}

Verify User Is Logged In
    [Documentation]    Assert that the page displays the logged-in user's name
    [Arguments]    ${username}
    Wait Until Page Contains    ${username}    10s

Verify Login Failed
    [Documentation]    Assert that the authentication failure message is displayed
    Wait Until Page Contains    Authentication failed.    10s
