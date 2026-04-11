---
description: Cria um commit semântico com as mudanças da fase atual.
model: claude-haiku-4-5-20251001
---

Crie um commit git com as mudanças atuais. Execute os passos na ordem.

## Passos

1. `git status` — liste arquivos modificados e não rastreados
2. `git diff HEAD` — revise as mudanças para redigir a mensagem
3. Adicione os arquivos relevantes ao stage (evite `git add -A` para não incluir arquivos sensíveis)
4. Crie o commit

## Formato da mensagem

```
<tipo>(<escopo opcional>): <descrição em minúsculas>

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Tipos:**
- `feat` — nova funcionalidade
- `fix` — correção de bug
- `refactor` — refatoração sem mudança de comportamento
- `test` — adição ou correção de testes
- `docs` — documentação
- `chore` — tarefas de manutenção (deps, config)
- `spec` — spec de feature em docs/specs/

## Regras

- Nunca commitar arquivos `.env` ou com credenciais
- Se houver arquivos gerados (migrations, build) verificar se devem ser incluídos conforme o `CLAUDE.md` do projeto
- Mensagem em português ou inglês conforme o padrão já usado no repositório (verifique `git log --oneline -5`)
