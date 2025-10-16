# API de Gerenciamento de Cartões

## Descrição
Este projeto implementa uma API RESTful para simulação de um sistema de emissão de cartões, autenticação de transações e tokenização de cartões de crédito/débito. O projeto foi desenvolvido utilizando FastAPI e Python, focando em boas práticas de desenvolvimento e segurança.

## Funcionalidades

- Emissão de cartões de crédito e débito
- Tokenização de cartões
- Autenticação de transações
- Documentação automática (Swagger/OpenAPI)
- Validação de dados de entrada
- Sistema de logs para auditoria

## Requisitos

- Python 3.10 ou superior
- FastAPI
- Uvicorn
- Pydantic
- UUID

## Instalação

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITÓRIO]
cd HST_card_api
```

2. Instale as dependências:
```bash
pip install -r requirements.txt
```

## Como Executar

1. Inicie o servidor:
```bash
uvicorn app.main:app --reload
```

2. Acesse a documentação:
- Swagger UI: http://127.0.0.1:8000/docs
- ReDoc: http://127.0.0.1:8000/redoc

## Estrutura do Projeto

```
HST_card_api/
│
├── app/
│   ├── __init__.py
│   ├── main.py          # Aplicação FastAPI e endpoints
│   ├── models.py        # Modelos Pydantic
│   └── services.py      # Lógica de negócios
│
├── docs/
│   └── documentacao.md  # Documentação detalhada em português
│
└── requirements.txt     # Dependências do projeto
```

## Exemplos de Uso

### 1. Emitir um Novo Cartão

```bash
curl -X POST "http://127.0.0.1:8000/cards/issue" \
     -H "Content-Type: application/json" \
     -d '{
           "holder_name": "João Silva",
           "card_type": "credit",
           "expiry_date": "2025-12-31"
         }'
```

### 2. Tokenizar um Cartão

```bash
curl -X POST "http://127.0.0.1:8000/cards/{numero_do_cartao}/tokenize"
```

### 3. Autenticar uma Transação

```bash
curl -X POST "http://127.0.0.1:8000/transactions/authenticate" \
     -H "Content-Type: application/json" \
     -d '{
           "token": "seu_token_aqui",
           "amount": 100.00,
           "merchant": "Loja Exemplo"
         }'
```

## Ambiente de Desenvolvimento

O projeto foi desenvolvido e testado em:
- Windows 10/11
- Python 3.14
- VS Code com extensões Python

## Contribuição

Para contribuir com o projeto:

1. Fork o repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Crie um Pull Request

## Segurança

Este projeto é uma demonstração e não deve ser usado em produção sem implementar medidas adicionais de segurança, como:

- Persistência segura de dados
- Criptografia de dados sensíveis
- Autenticação e autorização
- Rate limiting
- Validações mais rigorosas

## Documentação Adicional

Para mais detalhes sobre a implementação e uso da API, consulte a [documentação completa](docs/documentacao.md).

## Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.