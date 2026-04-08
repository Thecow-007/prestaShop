*** Settings ***
Resource    ../pages/Common.resource
Test Teardown    Close Browser

*** Test Cases ***
TC-04-01 Search Returns Relevant Results for Valid Keyword


TC-04-02 Search Displays No Results Message for Unmatched Query