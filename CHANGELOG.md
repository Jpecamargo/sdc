# Changelog

## [Unreleased]

## [3.2.0] — 2026-04-15

### Adicionado
- `settings.json` gerado automaticamente pelo `sdc.init` com `permissions.allow` pré-configuradas para operações comuns de desenvolvimento (file tools, git, package managers de todas as stacks, utilitários de shell) e `permissions.deny` para operações destrutivas (`sudo`, `rm -rf /`, `chown`, etc.). Elimina prompts repetitivos sem precisar de `--dangerously-skip-permissions`.
- Gate de remoção de arquivos no `/refine`: durante a revisão, arquivos identificados para remoção são coletados mas não apagados. Ao final, Claude apresenta a lista completa e aguarda uma única confirmação — o usuário pode excluir itens específicos antes de aprovar.

## [3.1.0] — 2026-04-15

### Adicionado
- Comando `/bootstrap`: scaffolding via CLI nativo do framework escolhido (Next.js, NestJS, FastAPI, Django, Rails, ASP.NET Core, Laravel, React+Vite, Angular, Vue, SvelteKit, Nuxt, Remix), instalação de dependências adicionais (ORM, drivers), criação de `.env.example`, validação do `.gitignore` e primeiro commit semântico. Disponível em todos os projetos inicializados; seguro para rodar apenas em repos ainda sem código.

## [3.0.0] — 2026-04-15

### Adicionado
- Campo `_version` no `sdc.config.json` para rastrear o formato do config e permitir migrações determinísticas em versões futuras
- Campo `pattern` no `sdc.config.json`: `serverless | split | api-only` — elimina a ambiguidade do formato anterior
- `sdc.upgrade` migra automaticamente configs de versões anteriores ao novo formato, com confirmação do usuário antes de continuar
- `architect.md` adapta o formato da spec ao padrão arquitetural: REST+DTOs para `split`, Server Actions+ORM para `serverless`, sem seções de UI para `api-only`
- `orchestrate.md` verifica quais agentes existem no projeto antes de rotear — sem `backend.md`, bugs de servidor vão para `frontend`
- `sdc.init` detecta o padrão arquitetural automaticamente em repos existentes, ou pergunta no fluxo de repo vazio
- `sdc.init` tenta inferir a descrição do projeto a partir de `package.json` ou `README.md`

### Alterado
- `sdc.config.json` migrou de estrutura aninhada (`backend.framework`, `frontend.framework`) para estrutura plana com `pattern`
- Agente `frontend.md` em projetos `serverless` agora cobre explicitamente lógica de servidor (Server Actions, route handlers, ORM) além da UI
- `sdc.upgrade` agora atualiza o plugin global (via `install.sh`) antes de atualizar o projeto

## [2.0.0] — 2026-04-15

### Adicionado
- `sdc.config.json` criado no `.claude/` do projeto para persistir as escolhas de stack — base para o `sdc.upgrade` funcionar sem templates pré-construídos
- Agentes `backend.md` e `frontend.md` gerados dinamicamente pelo Claude com base nas escolhas do usuário, com nível de especificidade equivalente aos templates anteriores
- Suporte a qualquer stack — sem restrição às tecnologias pré-definidas
- Detecção automática de stack em repos com código existente; perguntas sequenciais para repos vazios
- Para itens não detectados automaticamente, perguntas individuais ao usuário

### Removido
- Templates de stack pré-construídos (`backend-nestjs.md`, `backend-express.md`, `backend-fastapi.md`, `backend-django.md`, `backend-rails.md`, `frontend-nextjs.md`, `frontend-react-vite.md`, `frontend-angular.md`, `frontend-vue.md`)

### Alterado
- `sdc.upgrade` passou a regenerar `backend.md` e `frontend.md` a partir do `sdc.config.json` ao invés de copiar templates fixos

## [1.1.0] — 2026-04-14

### Adicionado
- PR workflow: comando `/pr` e seção `## PR Workflow` no `CLAUDE.md` do projeto
- Pipeline automático pós-spec com gate de validação manual antes da implementação

## [1.0.0] — 2026-04-14

### Adicionado
- Quatro slash commands globais: `/sdc.init`, `/sdc.clarify`, `/sdc.upgrade`, `/sdc.help`
- Agentes genéricos: `architect` (opus), `tdd` (sonnet), `design` (sonnet), `docs` (haiku)
- Templates de stack pré-construídos para NestJS, Express, FastAPI, Django, Rails, Next.js, React+Vite, Angular, Vue
- Template de spec em `docs/specs/_template.md`
- `install.sh` e `uninstall.sh`
- Suporte a git worktree para desenvolvimento paralelo de features
