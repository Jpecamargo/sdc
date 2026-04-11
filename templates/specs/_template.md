# [Nome da Feature]

**Data:** YYYY-MM-DD
**Status:** `rascunho` | `aprovada` | `implementando` | `concluída`

---

## Contexto

> Por que essa feature existe? Qual problema ou necessidade ela resolve?

---

## Comportamento esperado

> Fluxos do ponto de vista do usuário. Linguagem simples, sem termos técnicos.

### Fluxo principal

1. ...

### Fluxos alternativos

- ...

---

## Telas / componentes envolvidos

| Caminho | Ação | Descrição |
|---------|------|-----------|
| `/exemplo/pagina` | criar | ... |

---

## Contrato da API

> Definido pelo architect. Fonte de verdade para backend e frontend trabalharem em paralelo.

### Endpoints

```
POST   /api/<domain>        → 201 { id, ... }
GET    /api/<domain>        → 200 [{ ... }] | { data: [...], meta: { ... } }
GET    /api/<domain>/:id    → 200 { ... } | 404
PATCH  /api/<domain>/:id    → 200 { ... } | 404
DELETE /api/<domain>/:id    → 204 | 404
```

### Request bodies

```typescript
// POST /api/<domain>
{ field: string; optionalField?: string }

// PATCH /api/<domain>/:id
{ field?: string }
```

### Response shapes

```typescript
// GET /api/<domain>/:id
{
  id: string;
  field: string;
  createdAt: string;
  updatedAt: string;
}
```

### Erros esperados

| Status | Situação |
|--------|----------|
| 400 | Validação de DTO falhou |
| 404 | Recurso não encontrado |
| 409 | Conflito (ex: nome duplicado) |

---

## Tipos (frontend)

> Copiar para `src/types/<domain>.ts` na fase de implementação.

```typescript
export interface <Domain> {
  id: string;
  field: string;
  createdAt: string;
  updatedAt: string;
}

export interface Create<Domain>Input {
  field: string;
  optionalField?: string;
}
```

---

## DTOs / Schemas (backend)

> Copiar para o módulo correspondente na fase de implementação.

```typescript
// create-<domain>.dto.ts (NestJS/Express com class-validator)
export class Create<Domain>Dto {
  @IsString() @IsNotEmpty()
  field!: string;

  @IsString() @IsOptional()
  optionalField?: string;
}
```

---

## Schema de banco

> Campos e tipos da nova entidade. Sem código de migration — apenas a definição.

| Coluna | Tipo | Restrições |
|--------|------|------------|
| id | UUID | PK, default random |
| field | text | NOT NULL |
| created_at | timestamptz | NOT NULL, default now |
| updated_at | timestamptz | NOT NULL, default now |

---

## Regras de negócio

- ...

---

## Critérios de aceite

> Um item por comportamento verificável. Base para os testes TDD.

- [ ] ...
- [ ] ...

---

## Fluxo de trabalho

> Sequência de execução para esta feature.

```
1. architect  — spec (este arquivo)                           → /commit spec
2. tdd        — testes por critério de aceite                 → /commit tests
3. backend    — implementação (contratos da spec)             ┐
   frontend   — implementação (contratos da spec)             ┘ em paralelo → /commit
4. /refine    — code review e correção de violações
5. /test      — compilação + lint + testes                    → /commit
6. docs       — atualização de CLAUDE.md e agentes            → /commit
```

Ajuste os passos se a feature for só backend, só frontend, não precisar de tdd, etc.

---

## Fora de escopo

- ...
