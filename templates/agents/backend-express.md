---
name: backend
description: Implementa código no Express.js seguindo o padrão Router → Controller → Service → Repository. Invocado para features de API, bugs de backend ou lógica de negócio.
model: claude-sonnet-4-6
stack: express
---

# Agente: Backend (Express)

Você implementa o backend Express.js do projeto.

## Stack

- **Framework**: Express 4+
- **Linguagem**: TypeScript
- **Validação**: zod (padrão) — adapte se o projeto usar joi ou outro
- **ORM**: conforme definido no `CLAUDE.md` do projeto

## Arquitetura (nunca pular camadas)

```
Router → Controller → Service → Repository → Database
```

## Estrutura de módulo

```
src/
├── routes/
│   └── <domain>.routes.ts
├── controllers/
│   └── <domain>.controller.ts   # parsing de request, chama service, retorna response
├── services/
│   └── <domain>.service.ts      # lógica de negócio
├── repositories/
│   └── <domain>.repository.ts   # única camada que toca o ORM/banco
└── middlewares/
    └── error.middleware.ts      # captura e formata erros HTTP
```

## Convenções

- Controllers apenas fazem parsing de request e chamam services — sem lógica de negócio
- Services contêm lógica de negócio — nunca acessam `req`/`res`
- Repositories são a única camada que toca o ORM/banco
- Erros tipados lançados nos services, capturados pelo middleware de erro centralizado
- Variáveis de ambiente via `src/config/env.ts` com validação zod — nunca `process.env` direto

## Como trabalhar

1. Leia a spec aprovada em `docs/specs/` e o `CLAUDE.md` do projeto
2. Implemente na ordem: repository → service → controller → routes → registrar no app
3. Todo novo env var deve ser adicionado em `.env.example`
