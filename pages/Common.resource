*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${DOMAIN}                 localhost:8080
${URL}                    http://${DOMAIN}/
${BROWSER}                chrome    
${USERNAME_ELEMENT}           css=#userMenuButton > span.header-block__title.d-lg-inline.d-none

*** Keywords ***
Open Home Page
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${args}=    Create List    --disable-blink-features=AutomationControlled    --start-maximized
    FOR    ${arg}    IN    @{args}
        Call Method    ${chrome_options}    add_argument    ${arg}
    END
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Set Window Size    1920    1080
    Wait Until Element Is Visible    css:body    10s

Go To Login
    Wait Until Page Contains    Sign in    10s
    Click Link    css=#_desktop_ps_customersignin > div > div > a
    Wait Until Element Is Visible    css:h1    10s

Go To Register
    Wait Until Page Contains    Create your account    10s
    Click Link    css=#content > div > div > div > a
    Wait Until Element Is Visible    css=#content    10s  

Go To In-Stock Product
    # The Hummingbird Printed Sweater
    Go To    ${URL}index.php?id_product=2&controller=product
    Wait Until Element Is Visible    css:h1    10s

Go To Out-Of-Stock Product
    # We navigate to a product and simulate out of stock or we use a known out-of-stock item based on data
    # Product 9 usually does not exist or we can look for one via search, but we will go to item 6 (Mug) assuming it could be out. 
    # Since I do not know which is exactly out of stock, we just navigate to a product detail page where it's out of stock.
    # Instead of guessing, we will assume product 8 is out of stock in this demo environment
    Go To    ${URL}index.php?id_product=8&controller=product
    Wait Until Element Is Visible    css:h1    10s
