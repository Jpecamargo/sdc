---
description: Inicializa a estrutura Claude Code para o projeto atual com agentes, skills e spec template.
---

Inicialize a estrutura Claude Code para este projeto. Execute cada passo na ordem e não pule etapas.

## Passo 1 — Detectar ou coletar a stack

### 1a. Verificar se o repositório já tem código

Verifique a presença de arquivos de configuração conhecidos na raiz e nos diretórios imediatos:
`package.json`, `pyproject.toml`, `requirements.txt`, `Gemfile`, `*.csproj`, `*.sln`, `pom.xml`, `build.gradle`, `go.mod`, `composer.json`

**Se o repositório já tiver código** (ao menos um desses arquivos existir), execute a detecção automática:

Leia todos os arquivos de configuração encontrados e, se necessário, arquivos de código relevantes (ex: imports, configuração de banco, arquivos de migração, `.env.example`) para inferir:

- **Backend**: framework principal e linguagem (ex: NestJS/TypeScript, FastAPI/Python, ASP.NET Core/C#)
- **Frontend**: framework de UI, se houver (ex: Next.js, Vue, Angular)
- **Banco de dados**: tipo e driver (ex: PostgreSQL via pg, MongoDB via mongoose)
- **ORM/ODM**: biblioteca de acesso a dados (ex: Drizzle, Prisma, SQLAlchemy, ActiveRecord)

Após a análise, apresente em **uma única mensagem** o que foi detectado com confiança e pergunte se está correto. Omita da mensagem os itens não detectados — esses serão perguntados em seguida. Exemplo:

> "Detectei o seguinte no projeto:
> - Backend: NestJS (TypeScript)
> - Frontend: Next.js
> - Banco: PostgreSQL
> - ORM: Drizzle
>
> Está correto? Alguma correção?"

Aguarde a confirmação. Se o usuário corrigir algum item, use o valor corrigido.

Em seguida, para cada item que **não foi possível detectar com confiança**, pergunte separadamente, um por vez, antes de prosseguir. Exemplo:

> "Não consegui identificar o banco de dados. Qual você está usando?"

> "Não consegui identificar o ORM. Tem alguma preferência, ou prefere SQL direto?"

Após confirmar ou coletar todos os itens, faça as duas perguntas de workflow, **uma de cada vez**:

> "O projeto usará worktrees para desenvolvimento paralelo de features? (sim/não)"

> "O projeto usará pull requests para integrar mudanças? (sim/não — se sim, qual é a branch base? ex: main)"

---

**Se o repositório estiver vazio** (nenhum arquivo de configuração encontrado), faça cada pergunta separadamente, aguardando a resposta antes de prosseguir:

**Pergunta 1 — Backend**:
> "Qual tecnologia/framework você quer usar no backend? (ex: NestJS, FastAPI, Django, Express, Rails, ASP.NET Core, Spring Boot, Laravel — ou 'nenhum' se for só frontend)"

**Pergunta 2 — Frontend**:
> "Qual tecnologia/framework você quer usar no frontend? (ex: Next.js, React+Vite, Angular, Vue, Svelte — ou 'nenhum' se for só API)"

**Pergunta 3 — Banco de dados**:
> "Qual banco de dados você vai usar? (ex: PostgreSQL, MySQL, MongoDB, SQLite, Redis)"

**Pergunta 4 — ORM/ODM**:
> "Tem preferência por algum ORM ou ODM? (ex: Drizzle, Prisma, TypeORM, SQLAlchemy, ActiveRecord, Mongoose — ou 'nenhum' para SQL direto)"

**Pergunta 5 — Git Worktree**:
> "O projeto usará worktrees para desenvolvimento paralelo de features? (sim/não)"

**Pergunta 6 — PR Workflow**:
> "O projeto usará pull requests para integrar mudanças? (sim/não — se sim, qual é a branch base? ex: main)"

## Passo 2 — Criar estrutura de diretórios

Crie os diretórios se não existirem:
- `.claude/agents/`
- `.claude/commands/`
- `docs/specs/`

## Passo 3 — Criar sdc.config.json

Crie `.claude/sdc.config.json` com as escolhas coletadas:

```json
{
  "backend": {
    "framework": "<framework escolhido ou null>",
    "database": "<banco escolhido>",
    "orm": "<orm escolhido ou null>"
  },
  "frontend": {
    "framework": "<framework escolhido ou null>"
  },
  "worktree": <true|false>,
  "pr": {
    "enabled": <true|false>,
    "baseBranch": "<branch base ou null>"
  }
}
```

## Passo 4 — Copiar agentes genéricos

Leia cada arquivo em `~/.claude/sdc-templates/agents/` e escreva em `.claude/agents/`:
- `architect.md` → `.claude/agents/architect.md`
- `tdd.md` → `.claude/agents/tdd.md`
- `design.md` → `.claude/agents/design.md`
- `docs.md` → `.claude/agents/docs.md`

## Passo 5 — Gerar agentes de stack

### backend.md

Leia `~/.claude/sdc-templates/agents/backend.md` como estrutura de referência para as seções esperadas.

Com base nas escolhas do usuário (framework, banco, orm), **gere o conteúdo completo** de `.claude/agents/backend.md`. O arquivo deve:

- Ter frontmatter com `name: backend`, `description` específica da stack escolhida, `model: claude-sonnet-4-6`
- Descrever a stack com versões recomendadas (framework, linguagem, banco, orm, biblioteca de validação)
- Definir a direção de dependência idiomática do framework (ex: Controller → Service → Repository para NestJS; View → Serializer → Model para Django; Controllers → Services para ASP.NET Core)
- Mostrar a estrutura de diretórios/módulos convencional do framework
- Listar convenções de código relevantes: imports, tipos, enums, tratamento de erros, variáveis de ambiente
- Descrever a ordem de implementação idiomática para uma feature nova
- Incluir regras absolutas (o que nunca fazer nesta stack)

O nível de especificidade e detalhe deve ser equivalente ao de um template especializado para a stack — não genérico.

Pule este passo se backend = nenhum.

### frontend.md

Com base na tecnologia de frontend escolhida, **gere o conteúdo completo** de `.claude/agents/frontend.md`. O arquivo deve:

- Ter frontmatter com `name: frontend`, `description` específica, `model: claude-sonnet-4-6`
- Descrever framework, versão, bibliotecas de estilo e data fetching recomendadas para a stack
- Definir a estrutura de diretórios convencional
- Mostrar padrões de código do framework (componentes, state management, roteamento, hooks/composables/signals etc.)
- Cobrir boas práticas de listagens paginadas, autenticação e tipagem para a stack
- Incluir regras absolutas

Pule este passo se frontend = nenhum.

## Passo 6 — Copiar commands

Leia cada arquivo em `~/.claude/sdc-templates/commands/` e escreva em `.claude/commands/`:
- `orchestrate.md`
- `clarify.md`
- `commit.md`
- `test.md`
- `refine.md`
- `pr.md`

## Passo 7 — Copiar spec template

Leia `~/.claude/sdc-templates/specs/_template.md` e escreva em `docs/specs/_template.md`.

## Passo 8 — Gerar CLAUDE.md

**Se já existir um `CLAUDE.md` na raiz:** não sobrescreva. Informe o usuário que deve adaptá-lo manualmente.

**Se não existir:** gere um `CLAUDE.md` com as seções abaixo. Use o nome do diretório atual como nome do projeto. Substitua os placeholders com a stack real escolhida.

```markdown
# <Nome do Projeto>

<Descrição breve do projeto — substitua este placeholder>

---

## Stack

- **Backend**: <framework e linguagem escolhidos>
- **Frontend**: <framework escolhido ou "N/A">
- **Banco de dados**: <banco escolhido>
- **ORM**: <orm escolhido ou "N/A">

---

## Comandos Principais

<Liste os comandos de desenvolvimento da stack escolhida:
- Servidor de desenvolvimento
- Execução de testes
- Build/compilação
Adapte para o gerenciador de pacotes e scripts reais do projeto.>

---

## Arquitetura

<Descreva a direção de dependência da stack escolhida — a mesma documentada no agente backend.md gerado.>

---

## Estrutura de Pastas

<Esboço da estrutura principal do projeto — adapte conforme o projeto crescer>

---

## Fluxo spec-driven

```
/clarify → architect → tdd → backend ∥ frontend → /refine → /test → /commit → docs
```

Features triviais (bugs, ajustes): direto para backend/frontend → /test → /commit.

Specs ficam em `docs/specs/YYYY-MM-DD-<nome>.md`. Template: `docs/specs/_template.md`.

---

## Agentes

| Agente | Modelo | Uso |
|--------|--------|-----|
| architect | opus | Spec completa: contratos, tipos, DTOs, critérios de aceite |
| tdd | sonnet | Testes baseados nos critérios de aceite da spec |
| backend | sonnet | Implementação do servidor |
| frontend | sonnet | Implementação da UI |
| design | sonnet | Especificação visual |
| docs | haiku | Atualização de documentação |

## Skills

| Skill | Uso |
|-------|-----|
| /clarify | Resolve ambiguidades antes da spec |
| /orchestrate | Roteia solicitação para o agente correto |
| /refine | Code review e correção de violações |
| /test | Compilação + lint + testes |
| /commit | Commit semântico |
```

Se o projeto usar **PR workflow**, adicione ao CLAUDE.md:

```markdown
## PR Workflow

Este projeto usa pull requests para integrar mudanças.

- **Branch base**: <branch informada pelo usuário>

Fluxo: criar branch → implementar → commit → `/pr` → merge
Com worktree: abrir o PR antes de unir ao worktree raiz.
```

Se o projeto usar **git worktree**, adicione ao CLAUDE.md:

```markdown
## Git Worktree

Este projeto usa worktrees para desenvolvimento paralelo de features.

Ao invocar agentes via Agent tool em paralelo, use `isolation: "worktree"`:

```typescript
// backend e frontend da mesma feature em paralelo
Agent(subagent_type="backend", isolation="worktree", prompt="...")
Agent(subagent_type="frontend", isolation="worktree", prompt="...")
```

Use `isolation: "worktree"` sempre que dois agentes puderem modificar arquivos ao mesmo tempo.
Não use quando apenas um agente roda por vez — o worktree tem custo de setup desnecessário.
```

## Passo 9 — Confirmar

Liste todos os arquivos criados. Exiba:

> "Projeto inicializado. Próximos passos:
> 1. Revise e adapte o `CLAUDE.md` com detalhes específicos do projeto (módulos existentes, env vars, convenções reais).
> 2. Para iniciar uma feature, use `/clarify` para descrever o que quer construir."

Se PR workflow foi ativado, acrescente:
> "3. Ao finalizar uma feature, use `/pr` para abrir o pull request para `<branch-base>`."
