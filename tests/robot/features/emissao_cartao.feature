# language: pt
Funcionalidade: Emissão de Cartão
  Como um usuário da API
  Quero emitir um novo cartão
  Para que eu possa utilizá-lo em transações

  Cenário: Emitir um novo cartão de crédito válido
    Dado que o serviço de cartões está disponível
    Quando eu emitir um novo cartão com nome "João Teste", tipo "credit" e validade "2025-12-31"
    Então a resposta deve conter o nome "João Teste", tipo "credit" e status 200