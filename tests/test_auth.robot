*** Settings ***
Resource    ../pages/Common.resource
Resource    ../pages/RegisterPage.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-02-01 Successful Login with Valid Credentials
    Open Home Page
    Go To Login
    Input Text    css=#field-email    test@gmail.com
    Input Text    css=#field-password    Shp1DLHKhe6yAPR
    Click Button    css=#submit-login
    Wait Until Page Contains    Test User    10s

TC-02-02 Login Rejected with Invalid Credentials
    Open Home Page
    Go To Login
    Input Text    css=#field-email    test@gmail.com
    Input Text    css=#field-password    WrongPassword
    Click Button    css=#submit-login
    Wait Until Page Contains    Authentication failed.    10s

TC-02-03 Successful Logout Clears Session
    Open Home Page
    Go To Login
    Input Text    css=#field-email    test@gmail.com
    Input Text    css=#field-password    Shp1DLHKhe6yAPR
    Click Button    css=#submit-login
    Wait Until Page Contains    Test User    10s
    Click Button    css=#userMenuButton
    Click Link    css=#_desktop_ps_customersignin > div > div > div > a:nth-child(8)
    Wait Until Page Contains    Sign in    10s