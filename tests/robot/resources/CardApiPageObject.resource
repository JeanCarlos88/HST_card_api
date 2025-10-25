*** Settings ***
Library           RequestsLibrary
Library           String

*** Variables ***
${BASE_URL}       http://127.0.0.1:8000
${ISSUE_ENDPOINT}    /cards/issue
${DELETE_ENDPOINT}   /cards/{card_number}
${TOKENIZE_ENDPOINT}    /cards/{card_number}/tokenize
${AUTH_ENDPOINT}    /transactions/authenticate
${HEALTH_ENDPOINT}    /health

*** Keywords ***
Create API Session
    Create Session    card_api    ${BASE_URL}

Emitir Novo Cartao
    [Arguments]    ${holder_name}    ${card_type}    ${expiry_date}
    Create API Session
    ${body}=    Create Dictionary
    ...    holder_name=${holder_name}
    ...    card_type=${card_type}
    ...    expiry_date=${expiry_date}
    ${response}=    POST On Session
    ...    card_api
    ...    ${ISSUE_ENDPOINT}
    ...    json=${body}
    RETURN    ${response}

Tokenizar Cartao
    [Arguments]    ${card_number}
    Create API Session
    ${endpoint}=    Set Variable    ${TOKENIZE_ENDPOINT}
    ${endpoint}=    Replace String    ${endpoint}    {card_number}    ${card_number}
    ${response}=    POST On Session
    ...    card_api
    ...    ${endpoint}
    RETURN    ${response}

Autenticar Transacao
    [Arguments]    ${token}    ${amount}    ${merchant}
    Create API Session
    ${body}=    Create Dictionary
    ...    token=${token}
    ...    amount=${amount}
    ...    merchant=${merchant}
    ${response}=    POST On Session
    ...    card_api
    ...    ${AUTH_ENDPOINT}
    ...    json=${body}
    RETURN    ${response}

Health Check
    Create API Session
    ${response}=    GET On Session
    ...    card_api
    ...    ${HEALTH_ENDPOINT}
    RETURN    ${response}

Parse Response JSON
    [Arguments]    ${response}
    ${text}=    Set Variable    ${response.text}
    ${json}=    Evaluate    __import__('json').loads('''${text}''')
    RETURN    ${json}

Excluir Cartao
    [Arguments]    ${card_number}
    Create API Session
    ${endpoint}=    Set Variable    ${DELETE_ENDPOINT}
    ${endpoint}=    Replace String    ${endpoint}    {card_number}    ${card_number}
    ${response}=    DELETE On Session
    ...    card_api
    ...    ${endpoint}
    RETURN    ${response}
