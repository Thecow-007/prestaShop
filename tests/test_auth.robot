*** Settings ***
# test_auth.robot — Automation tests for login and logout functionality (FR-02)
# Test cases: TC-02-01, TC-02-02, TC-02-03
# FR-02: Customer authentication (login/logout)
# Authors: Robert Ohly (041092144), Daniel Bierman (041106553), Michael Dagher (041088202), Nicholas Jacques (041110677)
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
    [Documentation]    Suite-level setup: register a fresh account and store its email for login tests
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    Test    User    ${email}    ${VALID_PASSWORD}
    Set Suite Variable    ${VALID_EMAIL}    ${email}
    Close Browser

*** Test Cases ***
TC-02-01 Successful Login with Valid Credentials
    [Documentation]    Verify that a registered user can log in with valid email and password.
    [Tags]    high    auth    FR-02
    # Step 1: Log in with the credentials created in Suite Setup
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    # Step 2: Verify the user's name appears, confirming a successful login
    Verify User Is Logged In  ${VALID_USER}

TC-02-02 Login Rejected with Invalid Credentials
    [Documentation]    Verify that login is rejected when an incorrect password is provided.
    [Tags]    high    auth    FR-02
    # Step 1: Attempt to log in with the wrong password
    Login With Credentials    ${VALID_EMAIL}    ${INVALID_PASSWORD}
    # Step 2: Verify the authentication failure message is shown
    Verify Login Failed

TC-02-03 Successful Logout Clears Session
    [Documentation]    Verify that a logged-in user can log out and the session is cleared.
    [Tags]    high    auth    FR-02
    # Step 1: Log in with valid credentials
    Login With Credentials    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Verify User Is Logged In  ${VALID_USER}
    # Step 2: Log out and verify the Sign In link reappears
    Logout User
    Wait Until Page Contains  Sign in    10s
