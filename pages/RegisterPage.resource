*** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary

*** Variables ***
${MR_CHECKBOX}    css:label[for="field-id_gender-1"]
${MRS_CHECKBOX}    css:label[for="field-id_gender-2"]
${FIRSTNAME_FIELD}    id:field-firstname
${LASTNAME_FIELD}    id:field-lastname
${EMAIL_FIELD}    id:field-email
${PASSWORD_FIELD}    id:field-password
${BIRTHDAY_FIELD}    id:field-birthday
${PRIVACY_CHECKBOX}    name:customer_privacy
${TOC_CHECKBOX}    name:psgdpr
${SUBMIT_BUTTON}    css:button.form-control-submit
${WAS_VALIDATED}    css:#customer-form.was-validated
@{TITLES}    Mr    Mrs    N/A

*** Keywords ***
Generate Registration Data
    ${title}=        FakerLibrary.Random Element    ${TITLES}

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

    Set Suite Variable    ${TITLE}         ${title}
    Set Suite Variable    ${FIRST_NAME}    ${first_name}
    Set Suite Variable    ${LAST_NAME}     ${last_name}
    Set Suite Variable    ${FULL_NAME}     ${full_name}
    Set Suite Variable    ${EMAIL}         ${email}
    Set Suite Variable    ${PASSWORD}      ${password}
    Set Suite Variable    ${DOB}           ${dob}
