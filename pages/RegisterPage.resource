*** Settings ***
# RegisterPage.resource — Page object for the PrestaShop customer registration form
# Covers: registration form locators and random test data generation via FakerLibrary
Library    SeleniumLibrary
Library    FakerLibrary

*** Variables ***
# Gender/title radio button locators
${MR_CHECKBOX}    css:label[for="field-id_gender-1"]
${MRS_CHECKBOX}    css:label[for="field-id_gender-2"]

# Registration form field locators
${FIRSTNAME_FIELD}    id:field-firstname
${LASTNAME_FIELD}    id:field-lastname
${EMAIL_FIELD}    id:field-email
${PASSWORD_FIELD}    id:field-password
${BIRTHDAY_FIELD}    id:field-birthday

# Consent checkbox and submit locators
${PRIVACY_CHECKBOX}    name:customer_privacy
${TOC_CHECKBOX}    name:psgdpr
${SUBMIT_BUTTON}    css:button.form-control-submit

# Form validation state locator
${WAS_VALIDATED}    css:#customer-form.was-validated

# Possible title values for random selection
@{TITLES}    Mr    Mrs    N/A

*** Keywords ***
Generate Registration Data
    [Documentation]    Generate random customer data (name, email, password, DOB) using FakerLibrary
    ...    and store all values as suite variables for use across test cases.
    ${title}=        FakerLibrary.Random Element    ${TITLES}

    # Pick a gender-appropriate first name based on the random title
    IF    '${title}' == 'Mr'
        ${first_name}=    FakerLibrary.First Name Male
    ELSE IF    '${title}' == 'Mrs'
        ${first_name}=    FakerLibrary.First Name Female
    ELSE
        ${first_name}=    FakerLibrary.First Name
    END

    ${last_name}=     FakerLibrary.Last Name
    ${full_name}=     Catenate    ${first_name}    ${last_name}
    ${email}=         FakerLibrary.Safe Email
    ${password}=      FakerLibrary.Password    length=12
    ${dob}=           FakerLibrary.Date Of Birth    minimum_age=18    maximum_age=65

    # Store all generated values as suite-level variables
    Set Suite Variable    ${TITLE}         ${title}
    Set Suite Variable    ${FIRST_NAME}    ${first_name}
    Set Suite Variable    ${LAST_NAME}     ${last_name}
    Set Suite Variable    ${FULL_NAME}     ${full_name}
    Set Suite Variable    ${EMAIL}         ${email}
    Set Suite Variable    ${PASSWORD}      ${password}
    Set Suite Variable    ${DOB}           ${dob}
