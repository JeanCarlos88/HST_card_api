*** Settings ***
# Define o escopo do teste: autenticação de transações usando BDD
Documentation     Autenticação de transação (BDD)
# Importa Page Object com keywords da API
Resource          resources/CardApiPageObject.resource
# Biblioteca para manipular dicionários
Library           Collections
# Biblioteca para requisições HTTP
Library           RequestsLibrary

*** Variables ***
# Nome do titular do cartão para teste
${HOLDER_NAME}    João Auth
# Tipo do cartão (credit)
${CARD_TYPE}      credit
# Data de expiração do cartão
${EXPIRY_DATE}    2026-06-30
# Variáveis de controle do teste
${card_number}    ${EMPTY}
${TOKEN}          ${EMPTY}
${AUTH_RESPONSE}  ${EMPTY}

*** Test Cases ***
# Teste principal: autenticar uma transação usando token
Autenticar transacao com token válido
    # Tags para filtrar testes
    [Tags]    BDD    Autenticacao
    # Passos BDD:
    # 1. Prepara cartão e gera token
    Dado que existe um cartão tokenizado
    # 2. Tenta autenticar uma transação
    Quando eu autenticar uma transação
    # 3. Verifica resposta e transaction_id
    Então a resposta deve indicar sucesso e retornar um transaction_id

*** Keywords ***
Dado que existe um cartão tokenizado
    ${resp}=    Emitir Novo Cartao
    ...    ${HOLDER_NAME}
    ...    ${CARD_TYPE}
    ...    ${EXPIRY_DATE}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${card}=    Parse Response JSON    ${resp}
    ${card_number}=    Get From Dictionary    ${card}    card_number
    Set Test Variable    ${card_number}    ${card_number}
    ${tokresp}=    Tokenizar Cartao    ${card_number}
    Should Be Equal As Strings    ${tokresp.status_code}    200
    ${tokjson}=    Parse Response JSON    ${tokresp}
    ${token}=    Get From Dictionary    ${tokjson}    token
    Set Test Variable    ${TOKEN}    ${token}

Quando eu autenticar uma transação
    ${resp}=    Autenticar Transacao
    ...    ${TOKEN}
    ...    50.0
    ...    Loja Teste
    Set Test Variable    ${AUTH_RESPONSE}    ${resp}

Então a resposta deve indicar sucesso e retornar um transaction_id
    Should Be Equal As Strings    ${AUTH_RESPONSE.status_code}    200
    ${json}=    Parse Response JSON    ${AUTH_RESPONSE}
    Should Be True    ${json['success']}
    Dictionary Should Contain Key    ${json}    transaction_id
