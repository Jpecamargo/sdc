# SDC — Spec Driven Claude

> [Read in English](README.md)

Um plugin para Claude Code que traz o Spec-Driven Development para qualquer projeto através de agentes especializados e um fluxo de trabalho estruturado.

---

## Instalação

**Requisito:** [Claude Code](https://claude.ai/code) instalado.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Jpecamargo/sdc/main/install.sh)
```

Em seguida, abra o Claude Code em qualquer projeto e rode `/sdc.init`.

<details>
<summary>Instalar pelo código-fonte</summary>

```bash
git clone https://github.com/Jpecamargo/sdc
cd sdc
bash install.sh
```
</details>

<details>
<summary>Desinstalar</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Jpecamargo/sdc/main/uninstall.sh)
```
</details>

---

## O que é Spec-Driven Development?

Spec-Driven Development (SDD) é uma prática onde uma especificação completa é escrita e aprovada **antes** de qualquer código ser produzido.

### O problema que resolve

Quando você pede para uma IA implementar uma feature a partir de uma descrição vaga, ela gera código que parece correto mas frequentemente falha — a intenção não estava clara o suficiente. Isso é chamado de "vibe coding": o resultado é plausível, mas não correto.

Com SDD, a spec define o contrato completo antes de qualquer implementação:

- **Contrato da API** — endpoints, status codes, formatos de request/response (ou Server Actions em projetos serverless)
- **Tipos** — interfaces TypeScript (ou equivalente) para o frontend
- **DTOs/Schemas** — validação de entrada e schemas do ORM
- **Critérios de aceite** — comportamentos verificáveis que definem "pronto"
- **Regras de negócio** — lógica que não está óbvia no contrato

### Quando não usar SDD

Para bugs, pequenos ajustes visuais e refatorações simples — vá direto para a implementação. SDD é para features que introduzem comportamento novo.

---

## Por que "SDC"?

**S**pec **D**riven **C**laude.

SDC foi construído especificamente para o Claude Code. Ele usa o sistema nativo de agentes (`.claude/agents/`) e slash commands (`.claude/commands/`) para aplicar o processo SDD. A dependência do Claude é uma feature, não uma limitação.

---

## Como funciona

O SDC instala quatro slash commands globais no Claude Code. Após rodar `/sdc.init` em qualquer projeto, você tem um conjunto completo de agentes e skills configurados para a sua stack e padrão arquitetural.

### O fluxo

```
/clarify → architect → [gate: aprovação da spec] → tdd → backend ∥ frontend → refine → test → [gate: validação manual] → docs → commit → /pr
```

| Etapa | Quem | O que acontece |
|-------|------|----------------|
| `/clarify` | Você + Claude | Descreva a feature. Claude faz perguntas cirúrgicas, avalia escopo e produz um brief consolidado. |
| `architect` | Agente (opus) | Faz DRY check e avalia design patterns antes de escrever a spec completa em `docs/specs/`. Adapta o formato ao padrão arquitetural do projeto. |
| **[gate]** | **Você** | **Revise e aprove a spec. Solicite ajustes ou cancele se necessário.** |
| `tdd` | Agente (sonnet) | Escreve testes a partir dos critérios de aceite — antes da implementação existir. |
| `backend` + `frontend` | Agentes (sonnet) | Implementam em paralelo (split) ou sequencialmente (serverless/api-only) usando a spec aprovada como contrato. |
| `refine` | Inline | Code review: arquitetura, DRY, segurança, nomenclatura, tratamento de erros. Violações são corrigidas imediatamente. |
| `test` | Inline | Compilação + lint + testes. Falhas são corrigidas antes de avançar. |
| **[gate]** | **Você** | **Teste a feature manualmente. Solicite ajustes se necessário. Confirme quando estiver pronto.** |
| `docs` | Agente (haiku) | Atualiza o `CLAUDE.md` para refletir mudanças estruturais. |
| `commit` | Inline | Commit semântico. |
| `/pr` | Inline | Abre pull request para a branch base configurada. Pulado se o PR workflow não estiver ativo. |

### Para bugs e ajustes

Use `/orchestrate` para tudo que não for uma feature nova. Ele verifica quais agentes existem no projeto antes de rotear — em projetos serverless sem `backend.md`, bugs de servidor são corretamente direcionados para `frontend`.

| Situação | Fluxo |
|----------|-------|
| Bug de backend | backend → test → commit |
| Bug de frontend / UI | frontend → test → commit |
| Bug de servidor (serverless) | frontend → test → commit |
| Mudança visual | design → frontend → test → commit |
| Refatoração | refine → test → commit |
| Docs desatualizados | docs → commit |

---

## Padrões arquiteturais

O `/sdc.init` detecta ou pergunta o padrão arquitetural do projeto e gera os agentes corretos:

| Padrão | Descrição | Agentes gerados |
|--------|-----------|-----------------|
| `serverless` | Um framework lida com UI e lógica de servidor (ex: Next.js com Server Actions, SvelteKit, Nuxt) | Apenas `frontend.md` — cobre UI, Server Actions e ORM |
| `split` | Backend e frontend são processos separados (ex: NestJS + React, FastAPI + Vue) | `backend.md` + `frontend.md` |
| `api-only` | Apenas backend, sem frontend (ex: FastAPI, NestJS, Rails API) | Apenas `backend.md` |

Os agentes são gerados dinamicamente pelo Claude para qualquer tecnologia — sem lista de stacks pré-definidas.

---

## O que o `/sdc.init` cria

```
.claude/
├── sdc.config.json     # escolhas de stack e padrão arquitetural (versionado)
├── agents/
│   ├── architect.md    # opus   — spec, adaptada ao padrão do projeto
│   ├── tdd.md          # sonnet — testes a partir dos critérios de aceite
│   ├── backend.md      # sonnet — sua stack de backend (split / api-only)
│   ├── frontend.md     # sonnet — sua stack de frontend (split / serverless)
│   ├── design.md       # sonnet — especificações do design system
│   └── docs.md         # haiku  — mantém o CLAUDE.md sincronizado
└── commands/
    ├── clarify.md      # pipeline completo de features (entry point)
    ├── orchestrate.md  # roteia bugs, ajustes e refatorações
    ├── commit.md       # commits semânticos
    ├── test.md         # compilação + lint + testes
    ├── refine.md       # code review e correção de violações
    └── pr.md           # abre pull request (PR workflow)

docs/specs/
└── _template.md        # template de spec com todas as seções necessárias
```

---

## Comandos do plugin

| Comando | Função |
|---------|--------|
| `/sdc.init` | Inicializa um projeto: detecta stack e padrão, gera agentes, cria `sdc.config.json` e `CLAUDE.md` |
| `/sdc.clarify` | Clarifica uma feature, avalia o escopo, propõe divisões se necessário |
| `/sdc.upgrade` | Atualiza o plugin global e, se estiver em um projeto inicializado, regenera agentes e commands para o padrão mais recente. Migra o `sdc.config.json` de qualquer versão anterior automaticamente. |
| `/sdc.help` | Referência completa do fluxo e introdução ao SDD |

---

## Desenvolvimento paralelo com Git Worktree

Quando o projeto usa git worktree, múltiplas features podem ser desenvolvidas simultaneamente em sessões separadas do Claude Code.

**A regra:** conclua a fase de spec antes de iniciar a implementação. Uma vez que a implementação começa, uma nova sessão pode iniciar a próxima spec.

```
Sessão A:  /clarify → architect → [aprovação] → tdd → backend ∥ frontend → ...
                                       ↓
                          Sessão B pode começar:
                          /clarify → architect → [aprovação] → tdd → ...
```

---

## PR Workflow (opcional)

Quando ativado no `/sdc.init` ou `/sdc.upgrade`, cada feature começa em uma branch dedicada e termina com um pull request.

**Configuração:** durante o init, responda sim para "PR workflow?" e informe a branch base (ex: `main`).

**Override de branch base:** passe como argumento quando necessário: `/pr develop`

**Com git worktree:** abra o PR antes de unir o worktree ao root e depois remova com `git worktree remove <path>`.

---

## Contribuindo

Os templates são arquivos markdown simples em `templates/`. Para contribuir:

- **Comportamento de agentes**: edite `templates/agents/<agente>.md`
- **Lógica de commands**: edite `templates/commands/<command>.md`
- **Template de spec**: edite `templates/specs/_template.md`

Adicionar suporte a uma nova tecnologia não requer mudanças de código — os agentes são gerados dinamicamente pelo Claude com base nas escolhas do usuário.

Veja o [CHANGELOG.md](CHANGELOG.md) para o histórico completo de versões.
