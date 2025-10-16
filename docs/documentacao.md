# Documentação da API de Gerenciamento de Cartões

## Visão Geral
Esta API foi desenvolvida para simular um sistema de emissão de cartões, tokenização e autenticação de transações. A API oferece funcionalidades básicas para gerenciamento de cartões de crédito e débito em um ambiente de teste.

## Endpoints Disponíveis

### 1. Emissão de Cartão
**Endpoint:** `POST /cards/issue`

**Descrição:** Cria um novo cartão com os dados do titular.

**Corpo da Requisição:**
```json
{
    "holder_name": "Nome do Titular",
    "card_type": "credit",  // ou "debit"
    "expiry_date": "2025-12-31"
}
```

**Resposta:**
```json
{
    "holder_name": "Nome do Titular",
    "card_type": "credit",
    "expiry_date": "2025-12-31",
    "card_number": "1234567890123456",
    "cvv": "123",
    "token": null
}
```

### 2. Tokenização de Cartão
**Endpoint:** `POST /cards/{card_number}/tokenize`

**Descrição:** Gera um token único para um cartão específico.

**Parâmetros:**
- `card_number`: Número do cartão a ser tokenizado (na URL)

**Resposta:**
```json
{
    "token": "7f8e9d1c2b3a4..."
}
```

### 3. Autenticação de Transação
**Endpoint:** `POST /transactions/authenticate`

**Descrição:** Valida uma transação utilizando o token do cartão.

**Corpo da Requisição:**
```json
{
    "token": "7f8e9d1c2b3a4...",
    "amount": 100.50,
    "merchant": "Nome da Loja"
}
```

**Resposta:**
```json
{
    "success": true,
    "message": "Transação realizada com sucesso",
    "transaction_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

### 4. Verificação de Saúde
**Endpoint:** `GET /health`

**Descrição:** Verifica o status da API.

**Resposta:**
```json
{
    "status": "healthy",
    "timestamp": "2025-10-16T10:00:00.000Z"
}
```

## Validações e Regras de Negócio

### Cartões
- O nome do titular deve ter entre 2 e 100 caracteres
- O tipo de cartão deve ser "credit" ou "debit"
- A data de validade deve ser uma data futura
- O número do cartão é gerado automaticamente com 16 dígitos
- O CVV é gerado automaticamente com 3 dígitos

### Transações
- O valor da transação deve ser maior que zero
- O nome do estabelecimento deve ter entre 2 e 100 caracteres
- O token deve ser válido e estar associado a um cartão existente
- O cartão não pode estar expirado no momento da transação

## Considerações de Segurança
1. Todos os dados são armazenados em memória (apenas para fins de demonstração)
2. Os tokens são gerados usando UUID e hash SHA-256
3. A API inclui logs para auditoria de operações
4. CORS está configurado para aceitar requisições de qualquer origem (em ambiente de produção, isso deve ser restrito)

## Limitações Atuais
1. Sem persistência de dados (reiniciar a API apaga todos os dados)
2. Sem autenticação de usuários
3. Sem criptografia de dados sensíveis
4. Algoritmo simplificado de geração de números de cartão
5. Sem limite de requisições

## Recomendações para Produção
1. Implementar banco de dados para persistência
2. Adicionar autenticação e autorização
3. Implementar criptografia para dados sensíveis
4. Usar algoritmos seguros para geração de números de cartão
5. Implementar rate limiting
6. Restringir CORS para origens específicas
7. Adicionar mais validações de segurança