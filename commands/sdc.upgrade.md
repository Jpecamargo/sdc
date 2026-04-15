---
description: Atualiza o plugin SDC global e, se estiver em um projeto inicializado, atualiza também os agentes e commands do projeto.
---

Execute os passos na ordem. Não avance para o próximo passo sem concluir o atual.

## Regras — nunca viole

- **Nunca toque** em `docs/specs/` — esses arquivos pertencem ao usuário
- **Nunca sobrescreva** `CLAUDE.md` — tem contexto específico do projeto
- Atualize apenas `.claude/agents/` e `.claude/commands/`
- Arquivos em `.claude/` que não existem nos templates: **não toque**

---

## Passo 1 — Atualizar o plugin global (sempre)

Execute o script de instalação para atualizar `~/.claude/commands/sdc.*.md` e `~/.claude/sdc-templates/`:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Jpecamargo/sdc/main/install.sh)
```

---

## Passo 2 — Verificar se é um projeto inicializado

Verifique se `.claude/sdc.config.json` existe.

**Se não existir:** informe que o plugin foi atualizado e que `/sdc.init` deve ser rodado para inicializar o projeto. **Encerre aqui — não execute os passos seguintes.**

**Se existir:** continue para o Passo 3.

---

## Passo 3 — Migrar o sdc.config.json (obrigatório)

Leia `.claude/sdc.config.json` e identifique a versão:

### Config v1 (sem `_version`, campo `backend` é um objeto)

```json
{ "backend": { "framework": "...", "database": "...", "orm": "..." }, "frontend": { "framework": "..." } }
```

Transforme para o formato atual:

1. Infira o `pattern`:
   - `backend.framework` é null e `frontend.framework` existe → `serverless`
   - Ambos existem → `split`
   - `frontend.framework` é null e `backend.framework` existe → `api-only`
2. Escreva o novo `.claude/sdc.config.json`:

```json
{
  "_version": "3",
  "pattern": "<inferido>",
  "backend": "<backend.framework>",
  "frontend": "<frontend.framework>",
  "database": "<backend.database>",
  "orm": "<backend.orm>",
  "worktree": <valor existente>,
  "pr": <valor existente>
}
```

3. Mostre o config migrado ao usuário e pergunte se o `pattern` inferido está correto. Aguarde confirmação antes de continuar.

### Config v2 (tem `pattern`, sem `_version`)

Adicione `"_version": "3"` e salve. Informe o usuário.

### Config v3 (tem `_version: "3"`)

Nenhuma migração necessária. Continue.

**Após concluir este passo**, leia o `pattern` do config já migrado e use-o nos passos seguintes.

---

## Passo 4 — Atualizar agentes genéricos

Para cada agente, leia de `~/.claude/sdc-templates/agents/` e sobrescreva em `.claude/agents/`:
- `architect.md`
- `tdd.md`
- `design.md`
- `docs.md`

---

## Passo 5 — Regenerar agentes de stack

Use o `pattern` do config migrado (Passo 3).

**Se `pattern` for `split` ou `api-only`** — regenere `backend.md`:
- Leia `~/.claude/sdc-templates/agents/backend.md` como referência de estrutura
- Leia `backend`, `database` e `orm` do config
- Gere o conteúdo completo de `.claude/agents/backend.md` para a stack registrada

**Se `pattern` for `split` ou `serverless`** — regenere `frontend.md`:
- Leia `~/.claude/sdc-templates/agents/frontend.md` como referência de estrutura
- Leia `frontend` e `pattern` do config
- `serverless`: cubra UI e lógica de servidor (Server Actions, ORM)
- `split`: cubra apenas a camada de UI
- Gere o conteúdo completo de `.claude/agents/frontend.md`

---

## Passo 6 — Atualizar commands do projeto

Para cada command, leia de `~/.claude/sdc-templates/commands/` e sobrescreva em `.claude/commands/`:
- `orchestrate.md`
- `clarify.md`
- `commit.md`
- `test.md`
- `refine.md`
- `pr.md`

---

## Passo 7 — Verificar PR Workflow

- Leia o `CLAUDE.md` do projeto
- Se **não** contiver `## PR Workflow` e o config tiver `pr.enabled: false`, pergunte:
  > "Deseja ativar o PR workflow? (sim/não) — se sim, qual é a branch base?"
- Se sim: atualize o config e adicione a seção ao CLAUDE.md
- Se o CLAUDE.md já contiver `## PR Workflow`: não toque

---

## Resultado

Ao final, exiba:
- **Plugin global**: atualizado
- **Config**: versão anterior → v3 (ou "já estava na v3")
- **Arquivos atualizados**: lista completa
