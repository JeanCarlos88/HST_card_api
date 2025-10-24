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

1. Certifique-se que a API está rodando (passo anterior)

2. Execute todos os testes:
```bash
cd tests/robot
robot -L TRACE .
```

3. Execute testes específicos por tags:
```bash
# Executar apenas testes de emissão
robot -L TRACE -i EmissaoCartao .

# Executar apenas testes de tokenização
robot -L TRACE -i Tokenizacao .

# Executar apenas testes de autenticação
robot -L TRACE -i Autenticacao .

# Executar apenas testes de health check
robot -L TRACE -i Health .
```

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
│   └── services.py      # Lógica de negócios
│
├── tests/
│   └── robot/           # Testes automatizados com Robot Framework
│       ├── resources/
│       │   └── CardApiPageObject.resource  # Page Object da API
│       ├── autenticacao_bdd.robot          # Teste de autenticação
│       ├── emissao_cartao_bdd.robot       # Teste de emissão
│       ├── health_bdd.robot               # Teste de health check
│       ├── tokenizacao_bdd.robot          # Teste de tokenização
│       └── requirements.txt               # Dependências dos testes
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