---
description: Exibe o fluxo completo de trabalho e referência de agentes e skills.
---

Exiba as informações abaixo para o usuário. Não pergunte nada, apenas apresente.

---

## O que é Spec-Driven Development (SDD)

SDD é uma prática onde a especificação é escrita e aprovada **antes** de qualquer código ser produzido.

O problema que resolve: quando você pede para uma IA implementar uma feature com uma descrição vaga, ela gera código que parece correto mas falha porque a intenção não estava clara — o que é chamado de "vibe coding". Com uma spec aprovada, backend e frontend sabem exatamente o que construir, podem trabalhar em paralelo e o resultado é previsível.

### O que uma spec define

- **Contrato da API** — endpoints, status codes, request/response shapes
- **Tipos** — interfaces TypeScript (ou equivalente) para o frontend
- **DTOs/Schemas** — validação de entrada para o backend
- **Critérios de aceite** — comportamentos verificáveis que definem "pronto"
- **Regras de negócio** — lógica que não está óbvia no contrato

A spec é a fonte de verdade. Backend e frontend a leem independentemente e chegam ao mesmo resultado.

### Quando não usar SDD

Para bugs, ajustes visuais e refatorações pequenas o fluxo direto é mais adequado — veja a tabela de fluxo abaixo.

---

## Modelo de trabalho paralelo (Git Worktree)

### Regra fundamental

**A fase de spec deve ser concluída antes de iniciar a implementação. Uma vez que a implementação começa, uma nova spec pode ser iniciada em outra sessão.**

```
Sessão A:  clarify → architect → [aprovação] → tdd → backend ∥ frontend → ...
                                      ↓
                               Sessão B pode começar:
                               clarify → architect → [aprovação] → tdd → ...
```

### O que isso significa na prática

1. **Fase de spec (clarify → architect → aprovação)**: uma de cada vez. Não inicie a spec de uma nova feature enquanto outra ainda não foi aprovada.
2. **Fase de implementação (tdd → backend/frontend)**: ao iniciar o tdd, você está livre para abrir uma nova sessão e começar a spec da próxima feature.
3. **Implementações simultâneas**: cada spec em implementação roda em sua própria sessão isolada via worktree — sem conflitos.

### Por que essa ordem importa

A spec define contratos (API, tipos, DTOs) que backend e frontend precisam para implementar em paralelo. Iniciar a implementação sem spec aprovada gera retrabalho e divergência entre camadas.

---

## Fluxo de trabalho

### Features novas (spec-driven)

```
/clarify → architect → tdd → backend ∥ frontend → /refine → /test → /commit → docs
```

1. **/clarify** — descreva a feature em linguagem natural. Claude resolve ambiguidades, avalia escopo e propõe splits se necessário.
2. **architect** — escreve a spec completa em `docs/specs/`. Apresenta resumo e avaliação de tamanho. **Aguarda aprovação explícita do usuário antes de qualquer implementação.**
3. **tdd** — escreve testes orientados aos critérios de aceite (antes da implementação existir).
4. **backend + frontend** — implementam em paralelo com base nos contratos da spec aprovada.
5. **/refine** — code review e correção de violações arquiteturais.
6. **/test** — compilação + lint + testes.
7. **/commit** — commit semântico da fase.
8. **docs** — atualiza CLAUDE.md e agentes.

### Bugs e ajustes (fluxo direto)

| Situação | Fluxo |
|----------|-------|
| Bug backend | backend → /test → /commit |
| Bug frontend / UI | frontend → /test → /commit |
| Bug em ambas as camadas | backend → frontend → /test → /commit |
| Mudança visual | design → frontend → /test → /commit |
| Refatoração | /refine → /test → /commit |
| Docs desatualizados | docs → /commit |

---

## Agentes

| Agente | Modelo | Responsabilidade |
|--------|--------|-----------------|
| architect | opus | Spec completa: contratos de API, tipos, DTOs, critérios de aceite, schema de banco. Aguarda aprovação antes de implementar. |
| tdd | sonnet | Testes unitários e e2e baseados nos critérios de aceite. Escreve antes da implementação. |
| backend | sonnet | Implementação do servidor (stack definida no CLAUDE.md do projeto) |
| frontend | sonnet | Implementação da UI (stack definida no CLAUDE.md do projeto) |
| design | sonnet | Especificação visual: tokens, componentes canônicos, paleta, guidelines |
| docs | haiku | Mantém CLAUDE.md e agentes sincronizados com o código real |

---

## Skills (slash commands)

| Skill | Quando usar |
|-------|------------|
| /clarify | Antes de qualquer feature nova — resolve ambiguidades e avalia escopo |
| /orchestrate | Classifica a solicitação e roteia para o agente correto |
| /refine | Após implementação — code review e correção de violações |
| /test | Valida compilação + lint + testes |
| /commit | Cria commit semântico da fase atual |

---

## Governança: antes de criar agente ou skill

Responda as três perguntas obrigatórias:

**1. Subagente ou skill?**
| Subagente | Skill |
|-----------|-------|
| Tarefa longa, muitos arquivos | Tarefa curta e focada |
| Isolamento de contexto útil | Beneficia do contexto da conversa |
| Pode rodar em paralelo | Roda sequencialmente, inline |

**2. A skill precisa de subagentes internos?**
- Sim → partes independentes que ganham com paralelismo
- Não → Claude já tem contexto, tarefa focada

**3. Qual modelo?**
| Modelo | Quando |
|--------|--------|
| haiku | Mecânico: commits, lint, markdown sem julgamento |
| sonnet | Implementação, code review, planejamento moderado |
| opus | Decisões arquiteturais, trade-offs complexos |

---

## Comandos do plugin

| Comando | Função |
|---------|--------|
| /sdc.init | Inicializa novo projeto com toda a estrutura .claude/ |
| /sdc.clarify | Resolve ambiguidades de uma feature antes da spec |
| /sdc.upgrade | Atualiza agentes e commands sem tocar em specs ou CLAUDE.md |
| /sdc.help | Este menu |
