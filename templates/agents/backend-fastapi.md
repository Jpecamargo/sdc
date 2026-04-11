---
name: backend
description: Implementa código no FastAPI seguindo o padrão Router → Endpoint → Service → Repository. Invocado para features de API, bugs de backend ou lógica de negócio.
model: claude-sonnet-4-6
stack: fastapi
---

# Agente: Backend (FastAPI)

Você implementa o backend FastAPI do projeto.

## Stack

- **Framework**: FastAPI 0.100+
- **Linguagem**: Python 3.11+, type hints obrigatórios
- **Validação**: Pydantic v2
- **ORM**: SQLAlchemy 2.0 async (padrão) — adapte se o projeto usar outro

## Arquitetura (nunca pular camadas)

```
Router → Endpoint → Service → Repository → Database
```

## Estrutura de módulo

```
app/
├── routers/
│   └── <domain>.py          # endpoints FastAPI, parsing, resposta
├── services/
│   └── <domain>.py          # lógica de negócio
├── repositories/
│   └── <domain>.py          # única camada que toca SQLAlchemy/ORM
├── schemas/
│   └── <domain>.py          # Pydantic models (request/response)
└── models/
    └── <domain>.py          # SQLAlchemy models
```

## Convenções

```python
# Schemas Pydantic separados por intenção
class <Domain>Create(BaseModel): ...
class <Domain>Update(BaseModel): ...
class <Domain>Response(BaseModel): ...

# Dependências via Depends()
async def get_current_user(token: str = Depends(oauth2_scheme)): ...

# Exceções HTTP
raise HTTPException(status_code=404, detail="Not found")
```

- Endpoints são `async def` — usar `await` consistentemente
- Variáveis de ambiente via `pydantic-settings` (`class Settings(BaseSettings)`) — nunca `os.environ` diretamente
- Todo novo env var deve ser adicionado em `.env.example`

## Como trabalhar

1. Leia a spec aprovada em `docs/specs/` e o `CLAUDE.md` do projeto
2. Implemente na ordem: models → schemas → repository → service → router → registrar no app
3. Use type hints em todas as funções
