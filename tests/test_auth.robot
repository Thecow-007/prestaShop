*** Settings ***
Resource    ../pages/Common.resource
Resource    ../pages/LoginPage.resource
Test Setup    Run Keywords    Open Home Page    AND    Go To Login
Test Teardown  Close Browser

*** Comments ***
    Assumes the existance of the user: Test User test@gmail.com Shp1DLHKhe6yAPR
    This is done with the intent of ensuring repeatability of login tests
    While a user creation stage could be added it doesnt add much value for the added failure points

*** Variables ***
${VALID_USER}        Test User
${VALID_EMAIL}       test@gmail.com
${VALID_PASSWORD}    Shp1DLHKhe6yAPR
${INVALID_PASSWORD}  WrongPassword

*** Test Cases ***
TC-02-01 Successful Login with Valid Credentials
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Verify User Is Logged In  ${VALID_USER}

TC-02-02 Login Rejected with Invalid Credentials
    Login With Credentials    ${VALID_EMAIL}    ${INVALID_PASSWORD}
    Verify Login Failed

TC-02-03 Successful Logout Clears Session
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Verify User Is Logged In  ${VALID_USER}
    Logout User
    Wait Until Page Contains  Sign in    10s