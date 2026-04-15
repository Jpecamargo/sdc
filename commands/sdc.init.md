---
description: Inicializa a estrutura Claude Code para o projeto atual com agentes, skills e spec template.
---

Inicialize a estrutura Claude Code para este projeto. Execute cada passo na ordem e não pule etapas.

## Passo 1 — Detectar ou coletar a stack

### 1a. Verificar se o repositório já tem código

Verifique a presença de arquivos de configuração conhecidos na raiz e nos diretórios imediatos:
`package.json`, `pyproject.toml`, `requirements.txt`, `Gemfile`, `*.csproj`, `*.sln`, `pom.xml`, `build.gradle`, `go.mod`, `composer.json`

**Se o repositório já tiver código** (ao menos um desses arquivos existir), execute a detecção automática:

Leia todos os arquivos de configuração encontrados e, se necessário, arquivos de código relevantes (ex: imports, configuração de banco, arquivos de migração, `.env.example`) para inferir:

- **Padrão arquitetural**:
  - `serverless` — um único framework lida com UI e lógica de servidor (ex: Next.js com Server Actions, SvelteKit, Nuxt, Remix)
  - `split` — backend e frontend são processos/apps separados (ex: NestJS + React, FastAPI + Vue)
  - `api-only` — apenas backend, sem frontend (ex: FastAPI, NestJS, Rails API)
- **Framework(s)**: principal(is) tecnologia(s) e linguagem
- **Banco de dados**: tipo e driver
- **ORM/ODM**: biblioteca de acesso a dados

Após a análise, apresente em **uma única mensagem** o que foi detectado com confiança e pergunte se está correto. Omita os itens não detectados — esses serão perguntados em seguida. Exemplo:

> "Detectei o seguinte no projeto:
> - Padrão: serverless (Next.js com Server Actions)
> - Framework: Next.js 14+ (TypeScript)
> - Banco: PostgreSQL
> - ORM: Prisma
>
> Está correto? Alguma correção?"

Aguarde a confirmação. Se o usuário corrigir algum item, use o valor corrigido.

Para cada item **não detectado com confiança**, pergunte separadamente, um por vez:

> "Não consegui identificar o padrão arquitetural. É serverless (ex: Next.js com Server Actions), backend + frontend separados, ou API pura sem frontend?"

> "Não consegui identificar o banco de dados. Qual você está usando?"

Após confirmar todos os itens, faça as duas perguntas de workflow, **uma de cada vez**:

> "O projeto usará worktrees para desenvolvimento paralelo de features? (sim/não)"

> "O projeto usará pull requests para integrar mudanças? (sim/não — se sim, qual é a branch base? ex: main)"

---

**Se o repositório estiver vazio** (nenhum arquivo de configuração encontrado), faça cada pergunta separadamente, aguardando a resposta antes de prosseguir:

**Pergunta 1 — Padrão arquitetural**:
> "Qual é o padrão do projeto?
> 1. Serverless — um framework lida com UI e servidor (ex: Next.js com Server Actions, SvelteKit, Nuxt)
> 2. Backend + Frontend separados (ex: NestJS + React, FastAPI + Vue)
> 3. API pura — só backend, sem frontend"

**Pergunta 2 — Framework(s)**:
- Se serverless: "Qual framework? (ex: Next.js, SvelteKit, Nuxt, Remix)"
- Se split: "Qual framework de backend? (ex: NestJS, FastAPI, Django, Express, Rails, ASP.NET Core)" e depois "Qual framework de frontend? (ex: React+Vite, Angular, Vue)"
- Se api-only: "Qual framework? (ex: FastAPI, NestJS, Django, Express, Rails, ASP.NET Core, Spring Boot)"

**Pergunta 3 — Banco de dados**:
> "Qual banco de dados você vai usar? (ex: PostgreSQL, MySQL, MongoDB, SQLite, Redis)"

**Pergunta 4 — ORM/ODM**:
> "Tem preferência por algum ORM ou ODM? (ex: Drizzle, Prisma, TypeORM, SQLAlchemy, ActiveRecord, Mongoose — ou 'nenhum' para SQL direto)"

**Pergunta 5 — Git Worktree**:
> "O projeto usará worktrees para desenvolvimento paralelo de features? (sim/não)"

**Pergunta 6 — PR Workflow**:
> "O projeto usará pull requests para integrar mudanças? (sim/não — se sim, qual é a branch base? ex: main)"

## Passo 2 — Criar estrutura de diretórios

Crie os diretórios se não existirem:
- `.claude/agents/`
- `.claude/commands/`
- `docs/specs/`

## Passo 3 — Criar sdc.config.json

Crie `.claude/sdc.config.json` com as escolhas coletadas:

```json
{
  "_version": "3",
  "pattern": "<serverless | split | api-only>",
  "backend": "<framework de backend ou null>",
  "frontend": "<framework de frontend ou null>",
  "database": "<banco de dados>",
  "orm": "<orm ou null>",
  "worktree": <true|false>,
  "pr": {
    "enabled": <true|false>,
    "baseBranch": "<branch base ou null>"
  }
}
```

Exemplos por padrão:
- **serverless** (Next.js): `{ "_version": "3", "pattern": "serverless", "backend": null, "frontend": "Next.js", "database": "PostgreSQL", "orm": "Prisma" }`
- **split** (NestJS + React): `{ "_version": "3", "pattern": "split", "backend": "NestJS", "frontend": "React+Vite", "database": "PostgreSQL", "orm": "Drizzle" }`
- **api-only** (FastAPI): `{ "_version": "3", "pattern": "api-only", "backend": "FastAPI", "frontend": null, "database": "PostgreSQL", "orm": "SQLAlchemy" }`

## Passo 4 — Copiar agentes genéricos

Leia cada arquivo em `~/.claude/sdc-templates/agents/` e escreva em `.claude/agents/`:
- `architect.md` → `.claude/agents/architect.md`
- `tdd.md` → `.claude/agents/tdd.md`
- `design.md` → `.claude/agents/design.md`
- `docs.md` → `.claude/agents/docs.md`

## Passo 5 — Gerar agentes de stack

Gere os agentes conforme o padrão arquitetural registrado no `sdc.config.json`:

| pattern | Agentes a gerar |
|---------|-----------------|
| `serverless` | apenas `frontend.md` (cobre UI e lógica de servidor) |
| `split` | `backend.md` e `frontend.md` |
| `api-only` | apenas `backend.md` |

### backend.md

Gere quando `pattern` for `split` ou `api-only`.

Leia `~/.claude/sdc-templates/agents/backend.md` como referência de estrutura e seções esperadas.

**Gere o conteúdo completo** de `.claude/agents/backend.md` para o framework escolhido. O arquivo deve:

- Ter frontmatter com `name: backend`, `description` específica da stack, `model: claude-sonnet-4-6`
- Descrever a stack com versões recomendadas (framework, linguagem, banco, orm, biblioteca de validação)
- Definir a direção de dependência idiomática do framework
- Mostrar a estrutura de diretórios/módulos convencional
- Listar convenções de código: imports, tipos, tratamento de erros, variáveis de ambiente
- Descrever a ordem de implementação idiomática para uma feature nova
- Incluir regras absolutas

### frontend.md

Gere quando `pattern` for `split` ou `serverless`.

Leia `~/.claude/sdc-templates/agents/frontend.md` como referência de estrutura.

**Gere o conteúdo completo** de `.claude/agents/frontend.md`. O arquivo deve:

- Ter frontmatter com `name: frontend`, `description` específica, `model: claude-sonnet-4-6`
- Para **serverless**: cobrir tanto a UI quanto a lógica de servidor (Server Actions, route handlers, acesso ao banco via ORM) — é o único agente de implementação do projeto
- Para **split**: cobrir apenas a camada de UI e integração com a API do backend
- Descrever framework, versão, bibliotecas de estilo e data fetching
- Mostrar estrutura de diretórios e padrões de código do framework
- Cobrir boas práticas de paginação, autenticação e tipagem
- Incluir regras absolutas

## Passo 6 — Copiar commands

Leia cada arquivo em `~/.claude/sdc-templates/commands/` e escreva em `.claude/commands/`:
- `orchestrate.md`
- `clarify.md`
- `commit.md`
- `test.md`
- `refine.md`
- `pr.md`

## Passo 7 — Copiar spec template

Leia `~/.claude/sdc-templates/specs/_template.md` e escreva em `docs/specs/_template.md`.

## Passo 8 — Gerar CLAUDE.md

**Se já existir um `CLAUDE.md` na raiz:** não sobrescreva. Informe o usuário que deve adaptá-lo manualmente.

**Se não existir:** gere um `CLAUDE.md` com as seções abaixo. Use o nome do diretório atual como nome do projeto. Substitua os placeholders com a stack real escolhida.

Para a descrição do projeto: tente inferir a partir do campo `description` do `package.json`, do `README.md` ou de outros arquivos presentes. Se não encontrar, deixe o placeholder para o usuário preencher.

```markdown
# <Nome do Projeto>

<Descrição inferida do projeto, ou "substitua este placeholder">

---

## Stack

- **Backend**: <framework e linguagem escolhidos>
- **Frontend**: <framework escolhido ou "N/A">
- **Banco de dados**: <banco escolhido>
- **ORM**: <orm escolhido ou "N/A">

---

## Comandos Principais

<Liste os comandos de desenvolvimento da stack escolhida:
- Servidor de desenvolvimento
- Execução de testes
- Build/compilação
Adapte para o gerenciador de pacotes e scripts reais do projeto.>

---

## Arquitetura

<Descreva a direção de dependência da stack escolhida — a mesma documentada no agente backend.md gerado.>

---

## Estrutura de Pastas

<Esboço da estrutura principal do projeto — adapte conforme o projeto crescer>

---

## Fluxo spec-driven

```
/clarify → architect → tdd → backend ∥ frontend → /refine → /test → /commit → docs
```

Features triviais (bugs, ajustes): direto para backend/frontend → /test → /commit.

Specs ficam em `docs/specs/YYYY-MM-DD-<nome>.md`. Template: `docs/specs/_template.md`.

---

## Agentes

| Agente | Modelo | Uso |
|--------|--------|-----|
| architect | opus | Spec completa: contratos, tipos, DTOs, critérios de aceite |
| tdd | sonnet | Testes baseados nos critérios de aceite da spec |
| backend | sonnet | Implementação do servidor |
| frontend | sonnet | Implementação da UI |
| design | sonnet | Especificação visual |
| docs | haiku | Atualização de documentação |

## Skills

| Skill | Uso |
|-------|-----|
| /clarify | Resolve ambiguidades antes da spec |
| /orchestrate | Roteia solicitação para o agente correto |
| /refine | Code review e correção de violações |
| /test | Compilação + lint + testes |
| /commit | Commit semântico |
```

Se o projeto usar **PR workflow**, adicione ao CLAUDE.md:

```markdown
## PR Workflow

Este projeto usa pull requests para integrar mudanças.

- **Branch base**: <branch informada pelo usuário>

Fluxo: criar branch → implementar → commit → `/pr` → merge
Com worktree: abrir o PR antes de unir ao worktree raiz.
```

Se o projeto usar **git worktree**, adicione ao CLAUDE.md:

```markdown
## Git Worktree

Este projeto usa worktrees para desenvolvimento paralelo de features.

Ao invocar agentes via Agent tool em paralelo, use `isolation: "worktree"`:

```typescript
// backend e frontend da mesma feature em paralelo
Agent(subagent_type="backend", isolation="worktree", prompt="...")
Agent(subagent_type="frontend", isolation="worktree", prompt="...")
```

Use `isolation: "worktree"` sempre que dois agentes puderem modificar arquivos ao mesmo tempo.
Não use quando apenas um agente roda por vez — o worktree tem custo de setup desnecessário.
```

## Passo 9 — Confirmar

Liste todos os arquivos criados. Exiba:

> "Projeto inicializado. Próximos passos:
> 1. Revise e adapte o `CLAUDE.md` com detalhes específicos do projeto (módulos existentes, env vars, convenções reais).
> 2. Para iniciar uma feature, use `/clarify` para descrever o que quer construir."

Se PR workflow foi ativado, acrescente:
> "3. Ao finalizar uma feature, use `/pr` para abrir o pull request para `<branch-base>`."
