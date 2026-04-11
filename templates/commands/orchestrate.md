---
description: Classifica a solicitação e define qual agente ou skill acionar.
---

Classifique a solicitação e defina o fluxo. Execute sem pedir confirmação a menos que a solicitação seja ambígua.

## Fluxo spec-driven (features não-triviais)

```
/clarify → architect → tdd → backend ∥ frontend → /refine → /test → /commit → docs
```

Use este fluxo quando a feature cria novos endpoints, novas telas ou módulos inexistentes.

**Spec já aprovada?** Pule clarify e architect — direto para tdd.

**O architect sempre aguarda aprovação explícita do usuário antes de avançar para tdd.** Não pule esse gate.

**Regra de paralelismo:** a fase de spec (clarify → architect → aprovação) deve ser concluída antes de iniciar a implementação. Uma vez que o tdd começa, o usuário está livre para iniciar a spec da próxima feature em outra sessão. Nunca inicie a implementação sem spec aprovada.

## Fluxo direto (bugs, ajustes, refatorações)

| Solicitação | Fluxo |
|-------------|-------|
| Bug backend | backend → /test → /commit |
| Bug frontend / UI | frontend → /test → /commit |
| Bug em ambas as camadas | backend → frontend → /test → /commit |
| Mudança visual / design system | design → [aguarda aprovação] → frontend → /test → /commit |
| Refatoração | /refine → /test → /commit |
| Documentação desatualizada | docs → /commit |
| Dúvida de arquitetura | architect |

## Regras de execução

- Leia os arquivos relevantes antes de classificar um bug — nunca assuma a causa
- backend + frontend podem rodar em paralelo quando o contrato da spec está aprovado
- Inclua no prompt de cada agente: caminho da spec, arquivos já alterados, decisões tomadas
- Se a solicitação for simples (bug óbvio, ajuste visual), execute diretamente

## Git Worktree

Antes de invocar qualquer agente após o architect, verifique se o `CLAUDE.md` contém a seção `## Git Worktree`.

**Se sim:** use `isolation: "worktree"` em todos os agentes invocados a partir do tdd — sem exceção. Isso inclui tdd, backend e frontend.

```
# tdd
Agent(subagent_type="tdd", isolation="worktree", prompt="...")

# backend e frontend em paralelo
Agent(subagent_type="backend", isolation="worktree", prompt="...")
Agent(subagent_type="frontend", isolation="worktree", prompt="...")
```

**Se não:** invoque os agentes normalmente, sem `isolation`.

Esta verificação é obrigatória e deve ser feita antes de cada invocação pós-architect. Não assuma — leia o `CLAUDE.md`.

## Governança: antes de criar novo agente ou skill

**1. Subagente ou skill?**
- Subagente → tarefa longa, muitos arquivos, isolamento útil, pode rodar em paralelo
- Skill → tarefa curta, beneficia do contexto da conversa, roda inline

**2. A skill precisa de subagentes internos?**
- Sim → partes independentes que ganham com paralelismo
- Não → Claude já tem contexto, tarefa focada

**3. Qual modelo?**
- haiku → mecânico (commits, lint, markdown sem julgamento)
- sonnet → implementação, code review, planejamento moderado
- opus → decisões arquiteturais, trade-offs complexos
