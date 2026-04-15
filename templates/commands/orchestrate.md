---
description: Classifica bugs, ajustes e refatorações e define qual agente acionar. Para features novas, use /clarify.
---

Classifique a solicitação e defina o fluxo. Execute sem pedir confirmação a menos que a solicitação seja ambígua.

> **Features novas:** use `/clarify`. O `orchestrate` cobre apenas bugs, ajustes e refatorações.

## Antes de rotear — verificar agentes disponíveis

Leia os arquivos em `.claude/agents/` para saber quais agentes existem neste projeto. Use apenas agentes disponíveis ao montar o fluxo:

- Se não houver `backend.md`: bugs de servidor, banco ou lógica de negócio vão para `frontend`
- Adapte a tabela de fluxo abaixo conforme os agentes presentes

## PR Workflow

Verifique se o `CLAUDE.md` contém `## PR Workflow`.

**Se sim:**
1. `git branch --show-current`
2. Leia a branch base do `CLAUDE.md`
3. Se estiver na branch base: peça ao usuário o nome da branch e execute `git checkout -b <nome>`
4. Se já estiver em branch de feature: continue

## Fluxo por tipo de solicitação

| Solicitação | Fluxo |
|-------------|-------|
| Bug backend | backend → /test → /commit |
| Bug frontend / UI | frontend → /test → /commit |
| Bug em ambas as camadas | backend → frontend → /test → /commit |
| Mudança visual / design system | design → [aguarda aprovação] → frontend → /test → /commit |
| Refatoração | /refine → /test → /commit |
| Documentação desatualizada | docs → /commit |
| Dúvida de arquitetura | architect |

Se PR workflow estiver ativo: adicione `/pr` após o commit.

## Regras de execução

- Leia os arquivos relevantes antes de classificar — nunca assuma a causa
- backend + frontend podem rodar em paralelo quando o contrato já está definido
- Inclua no prompt de cada agente: arquivos relevantes, comportamento esperado, comportamento atual

## Git Worktree

Antes de invocar qualquer agente, verifique se o `CLAUDE.md` contém `## Git Worktree`.

**Se sim:** use `isolation: "worktree"` em todos os agentes invocados.

**Se não:** invoque normalmente.

## Governança: subagente ou inline?

- **Subagente** → tarefa longa, muitos arquivos, pode rodar em paralelo
- **Inline** → tarefa curta, beneficia do contexto da conversa

Modelo por complexidade:
- haiku → mecânico (commits, lint, markdown)
- sonnet → implementação, code review
- opus → decisões arquiteturais, trade-offs complexos
