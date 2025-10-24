*** Settings ***
# Define o escopo do teste: emissão de cartões usando BDD
Documentation     Emissão de cartão (BDD)
# Importa Page Object com keywords da API
Resource          resources/CardApiPageObject.resource
# Biblioteca para manipular dicionários
Library           Collections
# Biblioteca para operações do SO
Library           OperatingSystem
# Biblioteca para requisições HTTP
Library           RequestsLibrary
# Configura setup da suíte (pequena espera para API iniciar)
Suite Setup       Suite Setup

*** Variables ***
# Nome do titular do cartão para teste
${HOLDER_NAME}    João Teste
# Tipo do cartão (credit)
${CARD_TYPE}      credit
# Data de expiração do cartão
${EXPIRY_DATE}    2025-12-31
# Variáveis usadas para guardar status e resposta da emissão
${EMISSAO_STATUS}    ${EMPTY}
${EMISSAO_JSON}      ${EMPTY}

*** Test Cases ***
# Teste principal: emite um novo cartão de crédito
Emitir um novo cartao de credito valido
    # Tags para filtrar testes
    [Tags]    BDD    EmissaoCartao
    # 1. Verifica se o serviço está online
    Dado que o serviço de cartões está disponível
    # 2. Tenta emitir um novo cartão
    Quando eu emitir um novo cartão com nome
    ...    ${HOLDER_NAME}
    ...    ${CARD_TYPE}
    ...    ${EXPIRY_DATE}
    # 3. Valida os dados do cartão emitido
    Então a resposta deve conter o nome
    ...    ${HOLDER_NAME}
    ...    ${CARD_TYPE}
    ...    200

*** Keywords ***
# Aguarda 1s para garantir que a API iniciou
Suite Setup
    Sleep    1s

# Verifica se API está online via health check
Dado que o serviço de cartões está disponível
    # Cria sessão HTTP na URL base
    Create Session    card_api    http://127.0.0.1:8000
    # Testa endpoint /health
    ${resp}=    GET On Session
    ...    card_api
    ...    /health
    # Verifica código 200
    Should Be Equal As Strings    ${resp.status_code}    200
    # Verifica chave 'status' e valor 'healthy'
    Dictionary Should Contain Key    ${resp.json()}    status
    Should Be Equal As Strings    ${resp.json()['status']}    healthy

# Emite um novo cartão usando argumentos
Quando eu emitir um novo cartão com nome
    [Arguments]    ${holder_name}    ${card_type}    ${expiry_date}
    # Chama endpoint de emissão via Page Object
    ${response}=    Emitir Novo Cartao
    ...    ${holder_name}
    ...    ${card_type}
    ...    ${expiry_date}
    # Guarda status code e JSON para validação
    Set Test Variable    ${EMISSAO_STATUS}    ${response.status_code}
    ${json}=    Parse Response JSON    ${response}
    Set Test Variable    ${EMISSAO_JSON}    ${json}

# Valida dados do cartão emitido
Então a resposta deve conter o nome
    [Arguments]    ${holder_name}    ${card_type}    ${status}
    # Verifica status code esperado
    Should Be Equal As Strings    ${EMISSAO_STATUS}    ${status}
    # Valida dados do cartão no JSON
    ${json}=    Set Variable    ${EMISSAO_JSON}
    Should Be Equal As Strings    ${json['holder_name']}    ${holder_name}
    Should Be Equal As Strings    ${json['card_type']}    ${card_type}
    # Limpa sessões HTTP
    Delete All Sessions

 
