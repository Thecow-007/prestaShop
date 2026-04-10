*** Settings ***
# Common.resource — Shared browser setup, Cloudflare bypass, login/registration helpers
# Used by all test files as the base resource for environment configuration
Library    SeleniumLibrary
Library    Collections
Variables    ../load_env.py

*** Variables ***
# CF_CLIENT_ID and CF_CLIENT_SECRET are loaded from .env via load_env.py
${DOMAIN}              prestashop.danielbierman.ca
${URL}                 https://${DOMAIN}/
${BROWSER}             chrome
${HEADLESS}            true

# Header navigation locators
${SIGN_IN_BUTTON}           css:.user-info a[href*="login"]
${ACCOUNT_LINK}             css:.user-info a.account

# Login form locators
${LOGIN_SUBMIT_BTN}         id:submit-login

# Registration form locators
${CREATE_ACCOUNT_LINK}      css:a[data-link-action="display-register-form"]
${REG_PRIVACY_CHECKBOX}     name:customer_privacy
${REG_TERMS_CHECKBOX}       name:psgdpr
${REG_SUBMIT}               css:button.form-control-submit

# Shared form field locators (login, registration, and identity pages share IDs)
${FIELD_FIRST_NAME}         id:field-firstname
${FIELD_LAST_NAME}          id:field-lastname
${FIELD_EMAIL}              id:field-email
${FIELD_PASSWORD}           id:field-password

# Default test account credentials
${TEST_PASSWORD}            Str0ngP@ss!2026xQ

*** Keywords ***
Open Home Page
    [Documentation]    Launch Chrome, inject Cloudflare service token headers via CDP, and load the PrestaShop home page
    # Setup Chrome options to avoid automation detection
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${args}=    Create List    --disable-blink-features=AutomationControlled    --start-maximized
    IF    '${HEADLESS}' == 'true'
        Append To List    ${args}    --headless=new
    END
    FOR    ${arg}    IN    @{args}
        Call Method    ${chrome_options}    add_argument    ${arg}
    END
    # Open to blank page first so we can set headers before hitting Cloudflare
    Open Browser    about:blank    ${BROWSER}    options=${chrome_options}
    Set Window Size    1920    1080
    # Inject Cloudflare Service Token headers via Chrome DevTools Protocol
    ${seleniumlib}=    Get Library Instance    SeleniumLibrary
    ${driver}=    Set Variable    ${seleniumlib.driver}
    ${empty_dict}=    Evaluate    {}
    Call Method    ${driver}    execute_cdp_cmd    Network.enable    ${empty_dict}
    ${headers_dict}=    Create Dictionary    CF-Access-Client-Id=${CF_CLIENT_ID}    CF-Access-Client-Secret=${CF_CLIENT_SECRET}
    ${cmd_args}=    Create Dictionary    headers=${headers_dict}
    Call Method    ${driver}    execute_cdp_cmd    Network.setExtraHTTPHeaders    ${cmd_args}
    # Navigate to the site — service token headers are already attached to all requests
    Go To    ${URL}
    Wait Until Page Does Not Contain    Cloudflare Access    15s

Go To Login
    Wait Until Page Contains    Sign in    10s
    Click Link    css=#_desktop_ps_customersignin > div > div > a
    Wait Until Element Is Visible    css:h1    10s

Go To Register
    Wait Until Page Contains    Create your account    10s
    Click Link    css=#content > div > div > div > a
    Wait Until Element Is Visible    css=#content    10s  

Go To In-Stock Product
    [Documentation]    Navigate to the Hummingbird Printed Sweater (product ID 2)
    Go To    ${URL}index.php?id_product=2&controller=product
    Wait Until Element Is Visible    css:h1    10s

Go To Out-Of-Stock Product
    [Documentation]    Navigate to a product whose Add to Cart button is disabled (product ID 19, Customizable Mug)
    Go To    ${URL}index.php?id_product=19&controller=product
    Wait Until Element Is Visible    css:h1    10s

Navigate To Login Page
    [Documentation]    Click the Sign In link in the site header to reach the login page
    Wait Until Element Is Visible    ${SIGN_IN_BUTTON}    10s
    Click Element    ${SIGN_IN_BUTTON}
    Wait Until Element Is Visible    ${FIELD_EMAIL}    10s

Login As Customer
    [Documentation]    Log in with the given customer email and password
    [Arguments]    ${email}    ${password}
    Navigate To Login Page
    Input Text    ${FIELD_EMAIL}    ${email}
    Input Text    ${FIELD_PASSWORD}    ${password}
    Click Element    ${LOGIN_SUBMIT_BTN}
    Wait Until Element Is Visible    ${ACCOUNT_LINK}    10s

Register New Customer
    [Documentation]    Create a new customer account via the registration form
    [Arguments]    ${first_name}    ${last_name}    ${email}    ${password}
    Navigate To Login Page
    Wait Until Element Is Visible    ${CREATE_ACCOUNT_LINK}    5s
    Click Element    ${CREATE_ACCOUNT_LINK}
    # Fill in the registration form fields
    Wait Until Element Is Visible    ${FIELD_FIRST_NAME}    10s
    Input Text    ${FIELD_FIRST_NAME}    ${first_name}
    Input Text    ${FIELD_LAST_NAME}     ${last_name}
    Input Text    ${FIELD_EMAIL}          ${email}
    Input Text    ${FIELD_PASSWORD}       ${password}
    # Accept required consent checkboxes (GDPR and privacy)
    Select Checkbox    ${REG_PRIVACY_CHECKBOX}
    Select Checkbox    ${REG_TERMS_CHECKBOX}
    Click Element    ${REG_SUBMIT}
    # Verify the account was created by checking for the account link
    Wait Until Element Is Visible    ${ACCOUNT_LINK}    10s

Generate Unique Email
    [Documentation]    Return a unique email address using a millisecond timestamp
    ${timestamp}=    Evaluate    str(int(__import__('time').time() * 1000))
    ${email}=    Set Variable    testuser${timestamp}@test.com
    RETURN    ${email}

Logout
    [Documentation]    Log out the current user and verify the sign-in button reappears
    Go To    ${URL}index.php?mylogout=
    Wait Until Element Is Visible    ${SIGN_IN_BUTTON}    10s
