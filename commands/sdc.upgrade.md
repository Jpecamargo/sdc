---
description: Atualiza agentes e commands do projeto com a versão mais recente dos templates instalados.
---

Atualize os agentes e commands deste projeto com os templates em `~/.claude/sdc-templates/`.

## Regras — nunca viole

- **Nunca toque** em `docs/specs/` — esses arquivos pertencem ao usuário
- **Nunca sobrescreva** `CLAUDE.md` — tem contexto específico do projeto
- Atualize apenas `.claude/agents/` e `.claude/commands/`
- Arquivos em `.claude/` que não existem nos templates: **não toque**

## Passos

1. Liste os arquivos atuais em `.claude/agents/` e `.claude/commands/`

2. Para agentes genéricos (`architect.md`, `tdd.md`, `design.md`, `docs.md`):
   - Leia a versão em `~/.claude/sdc-templates/agents/`
   - Sobrescreva o arquivo do projeto

3. Para `backend.md` e `frontend.md`:
   - Leia o frontmatter do arquivo atual para identificar o campo `stack`
   - Use o template correspondente: `~/.claude/sdc-templates/agents/backend-<stack>.md`
   - Sobrescreva o arquivo do projeto

4. Para commands (`orchestrate.md`, `clarify.md`, `commit.md`, `test.md`, `refine.md`, `pr.md`):
   - Leia a versão em `~/.claude/sdc-templates/commands/`
   - Sobrescreva o arquivo do projeto

5. Verificar configuração de PR Workflow:
   - Leia o `CLAUDE.md` do projeto
   - Se **não** contiver a seção `## PR Workflow`: pergunte ao usuário em uma única mensagem:
     > "Deseja ativar o PR workflow? (sim/não) — se sim, qual é a branch base? (ex: `main`)"
   - Se sim: adicione a seção ao CLAUDE.md:
     ```markdown
     ## PR Workflow

     Este projeto usa pull requests para integrar mudanças.

     - **Branch base**: <branch informada>

     Fluxo: criar branch → implementar → commit → `/pr` → merge
     Com worktree: abrir o PR antes de unir ao worktree raiz.
     ```
   - Se o CLAUDE.md já contiver `## PR Workflow`: não toque — preserve a configuração existente

6. Ao final, liste:
   - **Atualizados**: arquivos que foram sobrescritos
   - **Preservados**: arquivos que não foram tocados (customizações do projeto)
