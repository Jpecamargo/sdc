---
description: Atualiza agentes e commands do projeto com a versão mais recente dos templates instalados.
---

Atualize os agentes e commands deste projeto.

## Regras — nunca viole

- **Nunca toque** em `docs/specs/` — esses arquivos pertencem ao usuário
- **Nunca sobrescreva** `CLAUDE.md` — tem contexto específico do projeto
- Atualize apenas `.claude/agents/` e `.claude/commands/`
- Arquivos em `.claude/` que não existem nos templates: **não toque**

## Passos

1. Leia `.claude/sdc.config.json`. Se não existir, informe o usuário e pare — o upgrade requer o config gerado pelo `/sdc.init`.

2. Para agentes genéricos (`architect.md`, `tdd.md`, `design.md`, `docs.md`):
   - Leia a versão em `~/.claude/sdc-templates/agents/`
   - Sobrescreva o arquivo do projeto

3. Para `backend.md`:
   - Leia `~/.claude/sdc-templates/agents/backend.md` como estrutura de referência para as seções esperadas
   - Leia `backend.framework`, `backend.database` e `backend.orm` de `.claude/sdc.config.json`
   - **Regenere o conteúdo completo** de `.claude/agents/backend.md` para a stack registrada, com o mesmo nível de especificidade de um template especializado
   - Pule se `backend.framework` for null

4. Para `frontend.md`:
   - Leia `~/.claude/sdc-templates/agents/frontend.md` como estrutura de referência
   - Leia `frontend.framework` de `.claude/sdc.config.json`
   - **Regenere o conteúdo completo** de `.claude/agents/frontend.md` para o framework registrado
   - Pule se `frontend.framework` for null

5. Para commands (`orchestrate.md`, `clarify.md`, `commit.md`, `test.md`, `refine.md`, `pr.md`):
   - Leia a versão em `~/.claude/sdc-templates/commands/`
   - Sobrescreva o arquivo do projeto

6. Verificar configuração de PR Workflow:
   - Leia o `CLAUDE.md` do projeto
   - Se **não** contiver a seção `## PR Workflow` e `sdc.config.json` tiver `pr.enabled: false`: pergunte ao usuário em uma única mensagem:
     > "Deseja ativar o PR workflow? (sim/não) — se sim, qual é a branch base? (ex: `main`)"
   - Se sim: atualize `sdc.config.json` e adicione a seção ao CLAUDE.md
   - Se o CLAUDE.md já contiver `## PR Workflow`: não toque

7. Ao final, liste:
   - **Atualizados**: arquivos que foram sobrescritos ou regenerados
   - **Preservados**: arquivos que não foram tocados
