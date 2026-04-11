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

- **Contrato da API** — endpoints, status codes, formatos de request/response
- **Tipos** — interfaces TypeScript (ou equivalente) para o frontend
- **DTOs/Schemas** — validação de entrada para o backend
- **Critérios de aceite** — comportamentos verificáveis que definem "pronto"
- **Regras de negócio** — lógica que não está óbvia no contrato

Backend e frontend leem a mesma spec de forma independente e chegam ao mesmo resultado. Sem desalinhamento, sem retrabalho.

### Quando não usar SDD

Para bugs, pequenos ajustes visuais e refatorações simples — vá direto para a implementação. SDD é para features que introduzem comportamento novo.

---

## Por que "SDC"?

**S**pec **D**riven **C**laude.

SDC foi construído especificamente para o Claude Code. Não é uma ferramenta genérica de workflow com IA — ele usa o sistema nativo de agentes do Claude Code (`.claude/agents/`) e slash commands (`.claude/commands/`) para aplicar o processo SDD. A dependência do Claude é uma feature, não uma limitação.

---

## Como funciona

O SDC instala quatro slash commands globais no Claude Code. Após rodar `/sdc.init` em qualquer projeto, você tem um conjunto completo de agentes e skills configurados para a sua stack.

### O fluxo

```
/clarify → architect → tdd → backend ∥ frontend → /refine → /test → /commit → docs
```

| Etapa | Quem | O que acontece |
|-------|------|----------------|
| `/sdc.clarify` | Você + Claude | Descreva a feature. Claude faz perguntas cirúrgicas para resolver ambiguidades e avalia se o escopo cabe em uma spec ou deve ser dividido. |
| `architect` | Agente (opus) | Escreve a spec completa em `docs/specs/`. Apresenta um resumo e **aguarda aprovação explícita** antes de qualquer implementação. |
| `tdd` | Agente (sonnet) | Escreve testes a partir dos critérios de aceite — antes da implementação existir. Os testes falham até o código ser escrito; isso é esperado. |
| `backend` + `frontend` | Agentes (sonnet) | Implementam em paralelo usando a spec aprovada como contrato. Nenhuma coordenação necessária entre eles. |
| `/refine` | Inline | Code review: violações de arquitetura, segurança, nomenclatura, tratamento de erros. |
| `/test` | Inline | Compilação + lint + testes. |
| `/commit` | Inline | Commit semântico da fase. |
| `docs` | Agente (haiku) | Atualiza `CLAUDE.md` e agentes para refletir mudanças estruturais. |

### Para bugs e ajustes

| Situação | Fluxo |
|----------|-------|
| Bug de backend | backend → /test → /commit |
| Bug de frontend / UI | frontend → /test → /commit |
| Mudança visual | design → frontend → /test → /commit |
| Refatoração | /refine → /test → /commit |
| Docs desatualizados | docs → /commit |

---

## Desenvolvimento paralelo com Git Worktree

Quando o projeto usa git worktree, múltiplas features podem ser desenvolvidas simultaneamente em sessões separadas do Claude Code.

**A regra:** conclua a fase de spec antes de iniciar a implementação. Uma vez que a implementação começa, uma nova sessão pode iniciar a próxima spec.

```
Sessão A:  /sdc.clarify → architect → [aprovação] → tdd → backend ∥ frontend → ...
                                            ↓
                               Sessão B pode começar:
                               /sdc.clarify → architect → [aprovação] → tdd → ...
```

- **Uma spec por vez** — não inicie a spec de uma nova feature antes da atual ser aprovada
- **Implementações paralelas** — assim que o tdd começa, abra uma nova sessão para a próxima spec
- **Sem conflitos de arquivo** — cada sessão de implementação é isolada via worktree

---

## Instalação

Veja a [instalação rápida](#instalação) no topo.

---

## Comandos do plugin

| Comando | Função |
|---------|--------|
| `/sdc.init` | Inicializa um projeto: detecta a stack, cria a estrutura `.claude/` e o `CLAUDE.md` |
| `/sdc.clarify` | Clarifica uma feature, avalia o escopo, propõe divisões se necessário |
| `/sdc.upgrade` | Atualiza agentes e commands para os templates mais recentes sem tocar em specs |
| `/sdc.help` | Referência completa do fluxo e introdução ao SDD |

## O que o `/sdc.init` cria

```
.claude/
├── agents/
│   ├── architect.md    # opus   — specs, contratos, critérios de aceite
│   ├── tdd.md          # sonnet — testes a partir dos critérios de aceite
│   ├── backend.md      # sonnet — sua stack de backend
│   ├── frontend.md     # sonnet — sua stack de frontend (se aplicável)
│   ├── design.md       # sonnet — especificações do design system
│   └── docs.md         # haiku  — mantém o CLAUDE.md sincronizado
└── commands/
    ├── orchestrate.md  # roteia solicitações para o agente correto
    ├── clarify.md      # resolve ambiguidades antes da spec
    ├── commit.md       # commits semânticos
    ├── test.md         # compilação + lint + testes
    └── refine.md       # code review e correção de violações

docs/specs/
└── _template.md        # template de spec com todas as seções necessárias
```

---

## Stacks suportadas

**Backend**: NestJS · Express · FastAPI · Django · Rails

**Frontend**: Next.js · React+Vite · Angular · Vue

---

## Contribuindo

Os templates são arquivos markdown simples. Para adicionar uma nova stack:

1. Crie `templates/agents/backend-<stack>.md` ou `templates/agents/frontend-<stack>.md`
2. Adicione o nome da stack na lógica de detecção em `commands/sdc.init.md`
3. Abra um PR
