*** Settings ***
# test_profile.robot — Automation tests for customer profile management (FR-11)
# Test cases: TC-11-01, TC-11-02, TC-11-03
# Authors: Robert Ohly (041092144), Daniel Bierman (041106553), Michael Dagher (041088202), Nicholas Jacques (041110677)
Resource    ../pages/Common.resource
Resource    ../pages/ProfilePage.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-11-01 Update Personal Information Successfully
    [Documentation]    Verify that a logged-in user can update their personal information
    ...    (first name) and see a success confirmation message.
    [Tags]    medium    profile    FR-11
    # Step 1: Register a fresh test account
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    Test    User    ${email}    ${TEST_PASSWORD}
    # Step 2: Navigate to the profile / identity page
    Go To Profile Page
    # Step 3: Update the first name to a new value
    Update First Name    UpdatedName
    # Step 4: Enter current password (required by PrestaShop to save changes)
    Enter Current Password    ${TEST_PASSWORD}
    # Step 5: Save the profile changes
    Save Profile
    # Step 6: Verify the success message is displayed
    Verify Profile Updated Successfully

TC-11-02 Profile Update Rejected for Invalid Email
    [Documentation]    Verify that updating the profile with an invalid email address
    ...    is rejected and an appropriate error message is displayed.
    [Tags]    medium    profile    FR-11
    # Step 1: Register a fresh test account
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    Test    User    ${email}    ${TEST_PASSWORD}
    # Step 2: Navigate to the profile / identity page
    Go To Profile Page
    # Step 3: Enter an invalid email address
    Update Email    not-a-valid-email
    # Step 4: Enter current password (required to attempt save)
    Enter Current Password    ${TEST_PASSWORD}
    # Step 5: Try to save
    Save Profile
    # Step 6: Verify an error message is displayed
    Verify Profile Update Error

TC-11-03 Password Change Requires Current Password
    [Documentation]    Verify that changing the password is rejected when
    ...    the wrong current password is provided.
    [Tags]    medium    profile    FR-11
    # Step 1: Register a fresh test account
    Open Home Page
    ${email}=    Generate Unique Email
    Register New Customer    Test    User    ${email}    ${TEST_PASSWORD}
    # Step 2: Navigate to the profile / identity page
    Go To Profile Page
    # Step 3: Enter a new password
    Enter New Password    NewStr0ng@Pass!99
    # Step 4: Enter an incorrect current password
    Enter Current Password    WrongPassword123!
    # Step 5: Try to save
    Save Profile
    # Step 6: Verify the change is rejected
    Verify Profile Update Error
