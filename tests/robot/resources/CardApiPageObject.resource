*** Settings ***
Library           RequestsLibrary

*** Variables ***
${BASE_URL}       http://127.0.0.1:8000
${ISSUE_ENDPOINT}    /cards/issue

*** Keywords ***
Emitir Novo Cartao
    [Arguments]    ${holder_name}    ${card_type}    ${expiry_date}
    Create Session    card_api    ${BASE_URL}
    ${body}=    Create Dictionary    holder_name=${holder_name}    card_type=${card_type}    expiry_date=${expiry_date}
    ${response}=    POST On Session    card_api    ${ISSUE_ENDPOINT}    json=${body}
    [Return]    ${response}
