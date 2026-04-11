---
description: Executa compilação TypeScript/tipagem, lint e testes do projeto.
model: claude-haiku-4-5-20251001
---

Execute a sequência de validação do projeto. Leia o `CLAUDE.md` para identificar os comandos corretos de cada etapa.

## Sequência

### 1. Compilação / verificação de tipos

Identifique o comando no `CLAUDE.md`. Exemplos por stack:
- TypeScript (NestJS/Next.js/Express): `npx tsc --noEmit`
- Python (FastAPI/Django): `mypy .` ou equivalente configurado
- Ruby: `bundle exec steep check` ou equivalente

### 2. Lint

Identifique o comando no `CLAUDE.md`. Exemplos:
- JavaScript/TypeScript: `npx eslint . --ext .ts,.tsx`
- Python: `ruff check .` ou `flake8`
- Ruby: `bundle exec rubocop`

### 3. Testes

Identifique o comando no `CLAUDE.md`. Exemplos:
- Jest: `npx jest --passWithNoTests`
- Pytest: `pytest`
- RSpec: `bundle exec rspec`

Execute unitários e e2e separadamente se configurados assim.

## Comportamento

- Se qualquer etapa falhar, pare e reporte o erro com o output completo
- Não tente corrigir erros automaticamente — reporte para que o usuário decida
- Se os comandos não estiverem no `CLAUDE.md`, execute o que for padrão da stack e reporte o que foi assumido
