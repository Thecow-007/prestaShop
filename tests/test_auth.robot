*** Settings ***
Resource    ../pages/Common.resource
Resource    ../pages/LoginPage.resource
Suite Setup    Register Test Auth User
Test Setup    Run Keywords    Open Home Page    AND    Go To Login
Test Teardown  Close Browser

*** Comments ***
    A fresh user is registered in Suite Setup so login tests have valid credentials.
    This ensures repeatability without depending on a pre-existing account.

*** Keywords ***
Register Test Auth User
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    Test    User    ${email}    ${VALID_PASSWORD}
    Set Suite Variable    ${VALID_EMAIL}    ${email}
    Close Browser

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
