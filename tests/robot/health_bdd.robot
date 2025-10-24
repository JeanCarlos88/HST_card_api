*** Settings ***
# Define o escopo do teste: verificação de health da API
Documentation     Health check da API (BDD)
# Importa Page Object com keywords da API
Resource          resources/CardApiPageObject.resource
# Biblioteca para requisições HTTP
Library           RequestsLibrary
# Biblioteca para manipular dicionários
Library           Collections

*** Variables ***
# Variável para armazenar resposta do health check
${HEALTH_RESPONSE}    ${EMPTY}

*** Test Cases ***
# Teste principal: verifica se a API está online e respondendo
Verificar health da API
    # Tags para filtrar testes
    [Tags]    BDD    Health
    # 1. Verifica disponibilidade da API
    Dado que a API está disponível
    # 2. Valida resposta do health check
    Então o endpoint de health retorna status 200 e chave status

*** Keywords ***
# Verifica se API está respondendo via health check
Dado que a API está disponível
    # Chama endpoint /health via Page Object
    ${resp}=    Health Check
    # Verifica status 200
    Should Be Equal As Strings    ${resp.status_code}    200
    # Guarda resposta para validação posterior
    Set Test Variable    ${HEALTH_RESPONSE}    ${resp}

# Valida detalhes da resposta do health check
Então o endpoint de health retorna status 200 e chave status
    # Extrai JSON da resposta
    ${json}=    Parse Response JSON    ${HEALTH_RESPONSE}
    # Verifica presença da chave 'status'
    Dictionary Should Contain Key    ${json}    status
