---
description: Atualiza o plugin SDC global e, se estiver em um projeto inicializado, atualiza também os agentes e commands do projeto.
---

Execute os passos abaixo na ordem. O Passo 1 sempre roda. O Passo 2 só roda se o projeto estiver inicializado.

## Regras — nunca viole

- **Nunca toque** em `docs/specs/` — esses arquivos pertencem ao usuário
- **Nunca sobrescreva** `CLAUDE.md` — tem contexto específico do projeto
- No Passo 2, atualize apenas `.claude/agents/` e `.claude/commands/`
- Arquivos em `.claude/` que não existem nos templates: **não toque**

---

## Passo 1 — Atualizar o plugin global (sempre)

Execute o script de instalação para atualizar `~/.claude/commands/sdc.*.md` e `~/.claude/sdc-templates/` com a versão mais recente:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Jpecamargo/sdc/main/install.sh)
```

---

## Passo 2 — Atualizar o projeto (somente se inicializado)

Verifique se `.claude/sdc.config.json` existe no diretório atual.

**Se não existir:** informe que o plugin foi atualizado e que `/sdc.init` deve ser rodado para inicializar o projeto. Encerre aqui.

**Se existir:** prossiga com os passos abaixo.

### 2a. Agentes genéricos

Para cada agente (`architect.md`, `tdd.md`, `design.md`, `docs.md`):
- Leia a versão em `~/.claude/sdc-templates/agents/`
- Sobrescreva `.claude/agents/<agente>.md`

### 2b. Agente backend

- Leia `~/.claude/sdc-templates/agents/backend.md` como estrutura de referência
- Leia `backend.framework`, `backend.database` e `backend.orm` de `.claude/sdc.config.json`
- Regenere o conteúdo completo de `.claude/agents/backend.md` para a stack registrada
- Pule se `backend.framework` for null

### 2c. Agente frontend

- Leia `~/.claude/sdc-templates/agents/frontend.md` como estrutura de referência
- Leia `frontend.framework` de `.claude/sdc.config.json`
- Regenere o conteúdo completo de `.claude/agents/frontend.md` para o framework registrado
- Pule se `frontend.framework` for null

### 2d. Commands do projeto

Para cada command (`orchestrate.md`, `clarify.md`, `commit.md`, `test.md`, `refine.md`, `pr.md`):
- Leia a versão em `~/.claude/sdc-templates/commands/`
- Sobrescreva `.claude/commands/<command>.md`

### 2e. PR Workflow

- Leia o `CLAUDE.md` do projeto
- Se **não** contiver `## PR Workflow` e `sdc.config.json` tiver `pr.enabled: false`, pergunte:
  > "Deseja ativar o PR workflow? (sim/não) — se sim, qual é a branch base? (ex: `main`)"
- Se sim: atualize `sdc.config.json` e adicione a seção ao CLAUDE.md
- Se o CLAUDE.md já contiver `## PR Workflow`: não toque

---

## Resultado

Ao final, liste:
- **Plugin global**: atualizado
- **Projeto**: atualizado (com a lista de arquivos) ou "não inicializado — rode `/sdc.init` para começar"
