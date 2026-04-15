# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## O que é este repositório

SDC (Spec Driven Claude) é um plugin para o Claude Code que instala um conjunto de slash commands globais e templates de agentes para aplicar Spec-Driven Development (SDD) em qualquer projeto.

O repositório não tem código de aplicação — é composto exclusivamente por arquivos Markdown (commands, templates de agentes, template de spec) e scripts shell de instalação/desinstalação.

---

## Instalação e desinstalação

```bash
# Instalar (copia arquivos para ~/.claude/)
bash install.sh

# Desinstalar (remove ~/.claude/commands/sdc.* e ~/.claude/sdc-templates/)
bash uninstall.sh
```

O `install.sh` detecta se está sendo executado localmente (com `commands/` e `templates/` presentes) ou remotamente via `curl`, e adapta o comportamento.

---

## Estrutura do repositório

```
commands/          # Slash commands globais instalados em ~/.claude/commands/
  sdc.init.md      # Inicializa projeto: coleta stack, gera agentes, cria sdc.config.json
  sdc.clarify.md   # Resolve ambiguidades de feature antes da spec
  sdc.upgrade.md   # Atualiza agentes/commands a partir do sdc.config.json
  sdc.help.md      # Exibe fluxo completo e referência de agentes/skills

templates/
  agents/          # Templates de agentes copiados/usados como referência pelo sdc.init
    architect.md   # opus   — specs, contratos, critérios de aceite
    tdd.md         # sonnet — testes a partir dos critérios de aceite
    design.md      # sonnet — especificação visual
    docs.md        # haiku  — mantém CLAUDE.md sincronizado
    backend.md     # sonnet — estrutura base; Claude gera a versão específica no init
    frontend.md    # sonnet — estrutura base; Claude gera a versão específica no init
  commands/        # Templates de skills copiados para .claude/commands/ no projeto
    orchestrate.md # Roteia bugs/ajustes/refatorações para o agente correto
    clarify.md     # Inline version do clarify para uso dentro do projeto
    commit.md      # Commit semântico
    test.md        # Compilação + lint + testes
    refine.md      # Code review e correção de violações
    pr.md          # Abre pull request
  specs/
    _template.md   # Template de spec com todas as seções obrigatórias
```

---

## Como o install.sh funciona

1. Copia `commands/sdc.*.md` → `~/.claude/commands/`
2. Copia os templates de agentes (`architect`, `tdd`, `design`, `docs`, `backend`, `frontend`) → `~/.claude/sdc-templates/agents/`
3. Copia os templates de commands → `~/.claude/sdc-templates/commands/`
4. Copia o template de spec → `~/.claude/sdc-templates/specs/`

O `sdc.init.md` (executado no projeto alvo) lê de `~/.claude/sdc-templates/`, gera os agentes de stack dinamicamente e escreve em `.claude/` do projeto.

---

## Como os agentes de stack são gerados

`backend.md` e `frontend.md` não são copiados de um template pré-pronto — são **gerados pelo Claude** no `sdc.init` com base nas escolhas do usuário (framework, banco, ORM). Os templates `backend.md` e `frontend.md` em `templates/agents/` servem apenas como referência de estrutura e seções esperadas.

As escolhas ficam persistidas em `.claude/sdc.config.json` no projeto alvo. O `sdc.upgrade` usa esse config para regenerar os agentes de stack quando necessário.

---

## Convenções dos arquivos Markdown

---

## Convenções dos arquivos Markdown

Todos os agentes têm frontmatter obrigatório:

```yaml
---
name: <nome>
description: <descrição usada pelo Claude Code para selecionar o agente>
model: claude-opus-4-6 | claude-sonnet-4-6 | claude-haiku-4-5-20251001
---
```

Os commands (skills) têm apenas `description` no frontmatter.

Os agentes de stack (`backend.md`, `frontend.md`) não têm campo `stack` no frontmatter — as escolhas ficam em `.claude/sdc.config.json`, que é a fonte de verdade para o `sdc.upgrade`.

---

## Fluxo SDD (referência)

```
/sdc.clarify → architect → [aprovação] → tdd → backend ∥ frontend → /refine → /test → /commit → docs
```

Specs ficam em `docs/specs/YYYY-MM-DD-<nome>.md` no projeto alvo. O template está em `templates/specs/_template.md`.
