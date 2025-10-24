*** Settings ***
# Define o escopo do teste: tokenização de cartão usando padrão BDD
Documentation     Tokenização de cartão (BDD)
# Importa o Page Object com as keywords de interação com a API
Resource          resources/CardApiPageObject.resource
# Importa biblioteca para manipular dicionários (ex: Dictionary Should Contain Key)
Library           Collections
# Importa biblioteca para fazer requisições HTTP
Library           RequestsLibrary

*** Variables ***
# Nome do titular do cartão para o teste
${HOLDER_NAME}    João Token
# Tipo do cartão (debit/credit)
${CARD_TYPE}      debit
# Data de expiração do cartão
${EXPIRY_DATE}    2026-06-30
# Variáveis de controle do teste
${CARD_NUMBER}    ${EMPTY}
${TOKEN_RESPONSE}    ${EMPTY}
${TOKEN}    ${EMPTY}

*** Test Cases ***
# Teste principal: tokenização de cartão
Tokenizar um cartao existente
    # Tags para agrupar e filtrar testes
    [Tags]    BDD    Tokenizacao
    # Passos do BDD:
    # 1. Prepara o cartão
    Dado que existe um cartão válido
    # 2. Executa a tokenização
    Quando eu tokenizar o cartão
    # 3. Verifica o resultado
    Então a resposta deve conter um token e status 200

*** Keywords ***
# Primeiro passo: cria um cartão para tokenizar depois
Dado que existe um cartão válido
    # Emite um novo cartão usando o Page Object
    ${resp}=    Emitir Novo Cartao
    ...    ${HOLDER_NAME}
    ...    ${CARD_TYPE}
    ...    ${EXPIRY_DATE}
    # Verifica se a emissão funcionou (status 200)
    Should Be Equal As Strings    ${resp.status_code}    200
    # Extrai dados do cartão da resposta JSON
    ${card}=    Parse Response JSON    ${resp}
    ${card_number}=    Get From Dictionary    ${card}    card_number
    # Guarda número do cartão para usar depois
    Set Test Variable    ${CARD_NUMBER}    ${card_number}

# Segundo passo: tokeniza o cartão criado
Quando eu tokenizar o cartão
    # Chama endpoint de tokenização com número do cartão
    ${resp}=    Tokenizar Cartao    ${CARD_NUMBER}
    # Guarda resposta para verificar depois
    Set Test Variable    ${TOKEN_RESPONSE}    ${resp}

# Terceiro passo: verifica se tokenização funcionou
Então a resposta deve conter um token e status 200
    # Verifica status HTTP 200
    Should Be Equal As Strings    ${TOKEN_RESPONSE.status_code}    200
    # Extrai e valida dados da resposta
    ${json}=    Parse Response JSON    ${TOKEN_RESPONSE}
    Dictionary Should Contain Key    ${json}    token
    # Guarda token para possível uso futuro
    ${token}=    Set Test Variable    ${TOKEN}    ${json['token']}
