*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${CF_Authorization}    eyJhbGciOiJSUzI1NiIsImtpZCI6Ijk1YWI1MTQ4N2M3MDg4M2Y3OWE3MTI1ZTA0YzFjNGMyZmZkZjI4ODdiNzg1NWVkMjI4MmViYjYwMGViYjI4YTUifQ.eyJhdWQiOlsiZmM2ZGNkNmQwOGQzODVkNTAzZTlkNWQzMTc4MjA0MDczNmI1MDI0YWI4ZDc5YjRmM2NkODUwMmM0ZDYzZjhhNiJdLCJlbWFpbCI6Im9obHkwMDAxQGFsZ29ucXVpbmxpdmUuY29tIiwiZXhwIjoxNzc2NDkxMTAwLCJpYXQiOjE3NzM4NjMxMDAsIm5iZiI6MTc3Mzg2MzEwMCwiaXNzIjoiaHR0cHM6Ly90aGVjb3cwMDcuY2xvdWRmbGFyZWFjY2Vzcy5jb20iLCJ0eXBlIjoiYXBwIiwiaWRlbnRpdHlfbm9uY2UiOiJ4cEYwM3RGRTlPcTdNdlZCIiwic3ViIjoiNDVjNzEyOTAtMDc0Ni01MmI3LTg5ZmMtODkyZTRiNWNjMGE5IiwiY291bnRyeSI6IkNBIiwicG9saWN5X2lkIjoiM2M3NDczYTUtNjNiOS00MDZkLTlhNTQtMjE3YmM1MmM3MGM4In0.T2bUL8A2nYKqxzG25lzAiU--SAuGkO4BmqwWM1gjLkNADzN7fb6efvyhizi-omRgXjXsmKwZHWSLag6NI1CQVGBh5z-zNQAPHVdgx3iFcXuGLTDaGel3a2RNpQ8JgzkO1Hmezrve5PYrL7_pb5Viw0k2uQc9_EuFmjjNIe8hTfrDXv5TI_aFELcwB2CzhKEfnZQFyRxmN_SY_rJaQqqMfCUoRwRijRrCrjVYZIOkf4jcYUKDJIaaa_bPqxkdkYK-I-xU-b0J7dn6UwwEvZm9pmBpWs1PU-Qjj50sLidG_JGSi7ZLJjYjWbZE4X5HZ6C1nyTwiCdY4SX6a37s1Sgn5w
${DOMAIN}              prestashop.danielbierman.ca
${URL}                 https://${DOMAIN}/

# Navigation
${SIGN_IN_BUTTON}               css:.login
${CREATE_ACCOUNT_LINK}          css:a[data-link-action="display-register-form"]

# Form Fields
${FIRST_NAME_FIELD}             id:field-firstname
${LAST_NAME_FIELD}              id:field-lastname
${EMAIL_FIELD}                  id:field-email
${PASSWORD_FIELD}               id:field-password

# Optional Fields
${GENDER_MR}                    id:field-id_gender-1
${BIRTHDATE_FIELD}              id:field-birthday
${TERMS_CHECKBOX}               name:psgdpr
${PRIVACY_CHECKBOX}             name:customer_privacy

# Submit
${SAVE_BUTTON}                  css:button[type="submit"]

# Validation
${ACCOUNT_NAME}                 css:.account
${ACCOUNT_PAGE_INDICATOR}       css:.page-header h1


*** Keywords ***
Inject Cloudflare Cookie
    # Removing the domain argument lets Selenium auto-assign it to the current page
    SeleniumLibrary.Add Cookie    CF_Authorization    ${CF_Authorization}    path=/

Open Home Page
    # 1. Setup Chrome Options (Keeping your existing logic)
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${args}=    Create List    --disable-blink-features=AutomationControlled    --start-maximized
    FOR    ${arg}    IN    @{args}
        Call Method    ${chrome_options}    add_argument    ${arg}
    END

    # 2. Open browser (Establish the connection)
    Open Browser    ${URL}    chrome    options=${chrome_options}
    
    # 3. Inject the cookie WITHOUT the domain (to avoid that mismatch error)
    # We add a delay to ensure the browser has fully registered the domain
    Sleep    2s
    SeleniumLibrary.Add Cookie    CF_Authorization    ${CF_Authorization}    path=/
    
    # 4. HARD REFRESH: Instead of Go To, use Javascript to force a reload
    Execute Javascript    window.location.reload(true)
    
    # 5. Wait to see if the .login button appears (PrestaShop) 
    # instead of the Cloudflare wall
    Wait Until Page Does Not Contain    Cloudflare Access    10s

Go To Registration Page
    Wait Until Element Is Visible    ${SIGN_IN_BUTTON}    10s
    Click Element    ${SIGN_IN_BUTTON}
    Wait Until Element Is Visible    ${CREATE_ACCOUNT_LINK}    5s
    Click Element    ${CREATE_ACCOUNT_LINK}

Fill Registration Form
    [Arguments]    ${first}    ${last}    ${email}    ${password}
    Input Text    ${FIRST_NAME_FIELD}    ${first}
    Input Text    ${LAST_NAME_FIELD}     ${last}
    Input Text    ${EMAIL_FIELD}         ${email}
    Input Text    ${PASSWORD_FIELD}      ${password}

Fill Optional Details
    [Arguments]    ${birthdate}
    Click Element    ${GENDER_MR}
    Input Text       ${BIRTHDATE_FIELD}    ${birthdate}
    Select Checkbox  ${TERMS_CHECKBOX}
    Select Checkbox  ${PRIVACY_CHECKBOX}

Submit Registration
    Click Button    ${SAVE_BUTTON}

Validate Account Created
    Wait Until Element Is Visible    ${ACCOUNT_NAME}    10s
    Element Should Be Visible        ${ACCOUNT_PAGE_INDICATOR}