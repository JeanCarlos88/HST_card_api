*** Settings ***
Documentation     Teste BDD para emissão de cartão via API
Resource          resources/CardApiPageObject.resource
Library           Collections
Library           OperatingSystem
Library           RequestsLibrary
Suite Setup       Suite Setup

*** Variables ***
${HOLDER_NAME}    João Teste
${CARD_TYPE}      credit
${EXPIRY_DATE}    2025-12-31

*** Test Cases ***
Emitir um novo cartao de credito valido
    [Tags]    BDD    EmissaoCartao
    Dado que o serviço de cartões está disponível
    Quando eu emitir um novo cartão com nome    ${HOLDER_NAME}    ${CARD_TYPE}    ${EXPIRY_DATE}
    Então a resposta deve conter o nome    ${HOLDER_NAME}    ${CARD_TYPE}    200

*** Keywords ***
Suite Setup
    # Garante que a API está rodando
    Sleep    1s

Dado que o serviço de cartões está disponível
    Create Session    card_api    http://127.0.0.1:8000
    ${resp}=    GET On Session    card_api    /health
    Should Be Equal As Strings    ${resp.status_code}    200
    Dictionary Should Contain Key    ${resp.json()}    status
    Should Be Equal As Strings    ${resp.json()['status']}    healthy

Quando eu emitir um novo cartão com nome
    [Arguments]    ${holder_name}    ${card_type}    ${expiry_date}
    ${response}=    Emitir Novo Cartao    ${holder_name}    ${card_type}    ${expiry_date}
    Set Global Variable    ${EMISSAO_RESPONSE}    ${response}

Então a resposta deve conter o nome
    [Arguments]    ${holder_name}    ${card_type}    ${status}
    Should Be Equal As Strings    ${EMISSAO_RESPONSE.status_code}    ${status}
    ${json}=    To Json    ${EMISSAO_RESPONSE.content}
    Should Be Equal As Strings    ${json['holder_name']}    ${holder_name}
    Should Be Equal As Strings    ${json['card_type']}      ${card_type}
    Delete All Sessions
To Json
    [Arguments]    ${content}
    ${json}=    Evaluate    __import__('json').loads(${content})
    RETURN    ${json}
