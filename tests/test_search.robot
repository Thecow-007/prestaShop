*** Settings ***
Resource    ../pages/Common.resource
Resource    ../pages/SearchPage.resource
Test Setup    Open Home Page
Test Teardown    Close Browser

*** Test Cases ***
TC-04-01 Search Returns Relevant Results for Valid Keyword
    Input Search    shirt
    Verify Search Match    shirt
    Verify Product Count    1

TC-04-02 Search Displays No Results Message for Unmatched Query
    Input Search    qwerty1234
    Verify No Search Match    qwerty1234