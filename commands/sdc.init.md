---
description: Inicializa a estrutura Claude Code para o projeto atual com agentes, skills e spec template.
---

Inicialize a estrutura Claude Code para este projeto. Execute cada passo na ordem e não pule etapas.

## Passo 1 — Detectar stack existente

Leia os arquivos de configuração do projeto para inferir a stack:

- `package.json` → se existir, leia `dependencies` e `devDependencies`:
  - `@nestjs/core` → backend: **nestjs**
  - `express` (sem NestJS) → backend: **express**
  - `next` → frontend: **nextjs**
  - `@angular/core` → frontend: **angular**
  - `vue` → frontend: **vue**
  - `vite` + `react` (sem next/angular/vue) → frontend: **react-vite**
- `pyproject.toml` ou `requirements.txt` → se existir:
  - `fastapi` → backend: **fastapi**
  - `django` → backend: **django**
- `Gemfile` → backend: **rails**

## Passo 2 — Confirmar com o usuário

Apresente o que foi detectado e faça as perguntas em uma única mensagem:

1. **Backend**: NestJS / Express / FastAPI / Django / Rails / nenhum _(detectado: X)_
2. **Frontend**: Next.js / React+Vite / Angular / Vue / nenhum _(detectado: X)_
3. **Git worktree**: o projeto usará worktrees para desenvolvimento paralelo de features? (sim/não)

Aguarde as respostas antes de prosseguir.

## Passo 3 — Criar estrutura de diretórios

Crie os diretórios se não existirem:
- `.claude/agents/`
- `.claude/commands/`
- `docs/specs/`

## Passo 4 — Copiar agentes

Leia cada arquivo em `~/.claude/sdc-templates/agents/` e escreva em `.claude/agents/`:

**Agentes genéricos** (copie sem modificação):
- `architect.md` → `.claude/agents/architect.md`
- `tdd.md` → `.claude/agents/tdd.md`
- `design.md` → `.claude/agents/design.md`
- `docs.md` → `.claude/agents/docs.md`

**Agentes de stack** (use o slug escolhido no passo 2):
- `backend-<slug>.md` → `.claude/agents/backend.md` (pule se backend = nenhum)
- `frontend-<slug>.md` → `.claude/agents/frontend.md` (pule se frontend = nenhum)

Slugs: `nestjs`, `express`, `fastapi`, `django`, `rails`, `nextjs`, `react-vite`, `angular`, `vue`

## Passo 5 — Copiar commands

Leia cada arquivo em `~/.claude/sdc-templates/commands/` e escreva em `.claude/commands/`:
- `orchestrate.md`
- `clarify.md`
- `commit.md`
- `test.md`
- `refine.md`

## Passo 6 — Copiar spec template

Leia `~/.claude/sdc-templates/specs/_template.md` e escreva em `docs/specs/_template.md`.

## Passo 7 — Gerar CLAUDE.md

**Se já existir um `CLAUDE.md` na raiz:** não sobrescreva. Informe o usuário que deve adaptá-lo manualmente.

**Se não existir:** gere um `CLAUDE.md` com as seções abaixo. Use o nome do diretório atual como nome do projeto.

```markdown
# <Nome do Projeto>

<Descrição breve do projeto — substitua este placeholder>

---

## Stack

- **Backend**: <stack escolhida ou "N/A">
- **Frontend**: <stack escolhida ou "N/A">

---

## Comandos Principais

<Liste os comandos de desenvolvimento da stack escolhida. Exemplos:
- NestJS: `npm run start:dev`, `npm run test`, `npm run build`
- FastAPI: `uvicorn main:app --reload`, `pytest`
- Rails: `rails server`, `rails test`
- Next.js: `npm run dev`, `npm run build`
Adapte para o gerenciador de pacotes e scripts reais do projeto.>

---

## Arquitetura

<Descreva a direção de dependência da stack. Exemplos:
- NestJS/Express: Controller → Service → Repository → Database
- Django: View → Serializer → Model
- Rails: Controller → Service → Model
- React/Next.js: Page → Hook → API>

---

## Estrutura de Pastas

<Esboço da estrutura principal do projeto — adapte conforme o projeto crescer>

---

## Convenções de Código

<Convenções da stack escolhida — adapte conforme o projeto>

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

## Passo 8 — Confirmar

Liste todos os arquivos criados. Exiba:

> "Projeto inicializado. Próximos passos:
> 1. Revise e adapte o `CLAUDE.md` com detalhes específicos do projeto (módulos existentes, env vars, convenções reais).
> 2. Para iniciar uma feature, use `/clarify` para descrever o que quer construir."
