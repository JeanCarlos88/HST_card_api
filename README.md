# API de Gerenciamento de Cartões

## Descrição
Este projeto implementa uma API RESTful para simulação de um sistema de emissão de cartões, autenticação de transações e tokenização de cartões de crédito/débito. O projeto foi desenvolvido utilizando FastAPI e Python, focando em boas práticas de desenvolvimento e segurança.

## Funcionalidades

- Emissão de cartões de crédito e débito
- Tokenização de cartões
- Autenticação de transações
- Exclusão de cartões
- Edição de dados do cartão
- Autenticação JWT para endpoints
- Documentação automática (Swagger/OpenAPI)
- Validação de dados de entrada
- Sistema de logs para auditoria

## Requisitos

- Python 3.10 ou superior
- FastAPI
- Uvicorn
- Pydantic
- UUID
- python-jose[cryptography]
- passlib[bcrypt]
- python-multipart

## Instalação

1. Clone o repositório:
```bash
git clone https://github.com/JeanCarlos88/HST_card_api.git
cd HST_card_api
```

2. Instale as dependências do projeto:
```bash
pip install -r requirements.txt
```

3. Instale as dependências dos testes (opcional):
```bash
cd tests/robot
pip install -r requirements.txt
cd ../..
```

## Como Executar

### API

1. Inicie o servidor:
```bash
uvicorn app.main:app --reload
```

2. Acesse a documentação:
- Swagger UI: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
- ReDoc: [http://127.0.0.1:8000/redoc](http://127.0.0.1:8000/redoc)

### Testes Automatizados

1. Certifique-se que a API está rodando:
```bash
# Em um terminal separado
uvicorn app.main:app
```

2. Em outro terminal, navegue até a pasta de testes:
```bash
cd tests/robot
```

3. Execute os testes:

a) Para executar todos os testes com log detalhado:
```bash
robot -d results -L TRACE .
```

b) Para executar testes específicos por tags:
```bash
# Testes de emissão de cartão
robot -d results -L TRACE -i EmissaoCartao .

# Testes de tokenização
robot -d results -L TRACE -i Tokenizacao .

# Testes de autenticação
robot -d results -L TRACE -i Autenticacao .

# Testes de health check
robot -d results -L TRACE -i Health .

# Testes de exclusão de cartão
robot -d results -L TRACE -i ExclusaoCartao .
```

c) Para executar um arquivo específico:
```bash
# Exemplo: executar apenas os testes de autenticação
robot -d results -L TRACE autenticacao_bdd.robot
```

Opções do comando robot:
- `-d results`: Coloca relatórios na pasta 'results'
- `-L TRACE`: Nível de log detalhado
- `-i TAG`: Executa apenas testes com a tag especificada
- `-v VARIAVEL:VALOR`: Define uma variável
- `-t "Nome do Teste"`: Executa um teste específico pelo nome

Os resultados dos testes serão gerados em:
- `log.html`: Log detalhado da execução
- `report.html`: Relatório resumido dos testes
- `output.xml`: Dados brutos para integração contínua

## Estrutura do Projeto

```
HST_card_api/
│
├── app/
│   ├── __init__.py
│   ├── main.py          # Aplicação FastAPI e endpoints
│   ├── models.py        # Modelos Pydantic
│   ├── services.py      # Lógica de negócios
│   └── auth.py         # Autenticação JWT
│
├── tests/
│   └── robot/           # Testes automatizados com Robot Framework
│       ├── resources/
│       │   └── CardApiPageObject.resource  # Page Object da API
│       ├── autenticacao_bdd.robot          # Teste de autenticação
│       ├── emissao_cartao_bdd.robot       # Teste de emissão
│       ├── health_bdd.robot               # Teste de health check
│       ├── tokenizacao_bdd.robot          # Teste de tokenização
│       ├── exclusao_cartao_bdd.robot     # Teste de exclusão
│       └── requirements.txt               # Dependências dos testes
│
├── docs/
│   └── documentacao.md  # Documentação detalhada em português
│
└── requirements.txt     # Dependências do projeto
```

## Exemplos de Uso

### 0. Obter Token de Acesso (JWT)

```bash
curl -X POST "http://127.0.0.1:8000/token" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "username=admin&password=adminpass"
```

Guarde o token recebido para usar nas próximas requisições.

### 1. Emitir um Novo Cartão

```bash
curl -X POST "http://127.0.0.1:8000/cards/issue" \
     -H "Authorization: Bearer {seu_token_jwt}" \
     -H "Content-Type: application/json" \
     -d '{
           "holder_name": "João Silva",
           "card_type": "credit",
           "expiry_date": "2025-12-31"
         }'
```

### 2. Tokenizar um Cartão

```bash
curl -X POST "http://127.0.0.1:8000/cards/{numero_do_cartao}/tokenize" \
     -H "Authorization: Bearer {seu_token_jwt}"
```

### 3. Autenticar uma Transação

```bash
curl -X POST "http://127.0.0.1:8000/transactions/authenticate" \
     -H "Authorization: Bearer {seu_token_jwt}" \
     -H "Content-Type: application/json" \
     -d '{
           "token": "seu_token_cartao",
           "amount": 100.00,
           "merchant": "Loja Exemplo"
         }'
```

### 4. Excluir um Cartão

```bash
curl -X DELETE "http://127.0.0.1:8000/cards/{numero_do_cartao}" \
     -H "Authorization: Bearer {seu_token_jwt}"
```

### 5. Atualizar Dados do Cartão

```bash
curl -X PATCH "http://127.0.0.1:8000/cards/{numero_do_cartao}" \
     -H "Authorization: Bearer {seu_token_jwt}" \
     -H "Content-Type: application/json" \
     -d '{
           "holder_name": "Novo Nome",
           "expiry_date": "2026-12-31"
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