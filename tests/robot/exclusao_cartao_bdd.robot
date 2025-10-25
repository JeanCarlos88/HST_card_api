*** Settings ***
# Define o escopo do teste: exclusão de cartão usando BDD
Documentation     Exclusão de cartão (BDD)
# Importa Page Object com keywords da API
Resource          resources/CardApiPageObject.resource
# Biblioteca para manipular dicionários
Library           Collections
# Biblioteca para requisições HTTP
Library           RequestsLibrary

*** Variables ***
# Nome do titular do cartão para teste
${HOLDER_NAME}    João Exclusao
# Tipo do cartão (credit)
${CARD_TYPE}      credit
# Data de expiração do cartão
${EXPIRY_DATE}    2026-06-30
# Variáveis para controle do teste
${CARD_NUMBER}    ${EMPTY}
${DELETE_RESPONSE}    ${EMPTY}

*** Test Cases ***
# Teste principal: excluir um cartão existente
Excluir cartao existente
    # Tags para filtrar testes
    [Tags]    BDD    ExclusaoCartao
    # Passos BDD:
    # 1. Prepara cartão para exclusão
    Dado que existe um cartão para excluir
    # 2. Tenta excluir o cartão
    Quando eu excluir o cartão
    # 3. Verifica resposta e tenta acessar cartão excluído
    Então a resposta deve indicar sucesso e o cartão não deve mais existir

*** Keywords ***
# Primeiro passo: cria um cartão para excluir depois
Dado que existe um cartão para excluir
    # Emite um novo cartão usando o Page Object
    ${resp}=    Emitir Novo Cartao
    ...    ${HOLDER_NAME}
    ...    ${CARD_TYPE}
    ...    ${EXPIRY_DATE}
    # Verifica se a emissão funcionou (status 200)
    Should Be Equal As Strings    ${resp.status_code}    200
    # Extrai e guarda número do cartão
    ${card}=    Parse Response JSON    ${resp}
    ${card_number}=    Get From Dictionary    ${card}    card_number
    Set Test Variable    ${CARD_NUMBER}    ${card_number}

# Segundo passo: exclui o cartão
Quando eu excluir o cartão
    # Chama endpoint de exclusão com número do cartão
    ${resp}=    Excluir Cartao    ${CARD_NUMBER}
    # Guarda resposta para verificações
    Set Test Variable    ${DELETE_RESPONSE}    ${resp}

# Terceiro passo: verifica exclusão
Então a resposta deve indicar sucesso e o cartão não deve mais existir
    # Verifica status 200 na exclusão
    Should Be Equal As Strings    ${DELETE_RESPONSE.status_code}    200
    # Extrai mensagem do JSON
    ${json}=    Parse Response JSON    ${DELETE_RESPONSE}
    Should Be Equal As Strings    ${json['message']}    Card deleted successfully
    
    # Tenta excluir novamente - deve retornar 404
    ${resp}=    Excluir Cartao    ${CARD_NUMBER}
    Should Be Equal As Strings    ${resp.status_code}    404