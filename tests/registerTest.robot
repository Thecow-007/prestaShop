*** Settings ***
Resource    ../pages/RegisterPage.resource

*** Test Cases ***
Successful Account Registration
    Open Home Page
    Go To Registration Page
    Fill Registration Form    John    Smith    john${random}@mail.com    Test1234!
    Fill Optional Details     01/01/2000
    Submit Registration
    Validate Account Created