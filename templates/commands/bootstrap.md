---
description: Cria a estrutura completa do projeto, instala dependências e faz o primeiro commit. Use em projetos iniciados do zero, após /sdc.init.
---

Execute cada passo na ordem. Não avance sem concluir o atual.

## Passo 1 — Verificar pré-requisitos

1. Leia `.claude/sdc.config.json`. Se não existir, informe o usuário para rodar `/sdc.init` primeiro e encerre.
2. Verifique se já existe código de aplicação no repositório (ex: `package.json`, `src/`, `app/`, `pyproject.toml`). Se existir, informe que o bootstrap é para projetos vazios e encerre.
3. Verifique se há um repositório git (`git status`). Se não houver, execute `git init`.

## Passo 2 — Confirmar com o usuário

Leia `pattern`, `backend`, `frontend`, `database` e `orm` do config. Apresente em uma mensagem o que será criado:

> "Vou criar a estrutura do projeto com:
> - Padrão: [pattern]
> - [framework(s)]
> - Banco: [database] via [orm ou 'SQL direto']
>
> Confirma?"

Aguarde confirmação antes de continuar.

## Passo 3 — Scaffolding

Execute o scaffolding adequado para cada tecnologia. Use o diretório atual (`.`) como destino. Se o CLI perguntar por configurações interativas, prefira flags que eliminem a interação.

### serverless

**Next.js**
```bash
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --no-git
```

**SvelteKit**
```bash
npx sv create . --template minimal --types ts --no-add-ons --no-install
```

**Nuxt**
```bash
npx nuxi@latest init . --no-install --no-git-init
```

**Remix**
```bash
npx create-remix@latest . --no-install --no-git-init --template remix
```

### split — backend

**NestJS**
```bash
npx @nestjs/cli new . --package-manager npm --skip-git --strict
```

**Express (TypeScript)**
```bash
# Crie manualmente: package.json, tsconfig.json, src/index.ts
# Use as convenções do agente backend.md do projeto
```

**FastAPI**
```bash
# Crie manualmente: pyproject.toml (ou requirements.txt), app/main.py, app/__init__.py
```

**Django**
```bash
pip install django && django-admin startproject config .
```

**Rails**
```bash
rails new . --api --skip-git --database=postgresql
```

**ASP.NET Core**
```bash
dotnet new webapi -o . --no-git
```

**Spring Boot** — instrua o usuário a gerar via [start.spring.io](https://start.spring.io) e extrair aqui.

**Laravel**
```bash
composer create-project laravel/laravel . --no-interaction
```

### split — frontend (em diretório separado ou monorepo)

**React + Vite**
```bash
npm create vite@latest . -- --template react-ts
```

**Angular**
```bash
npx @angular/cli new app --directory . --skip-git --style css --routing true
```

**Vue**
```bash
npm create vue@latest . -- --typescript --router --no-git
```

Para projetos `split`, crie backend e frontend no mesmo repositório apenas se for monorepo. Caso contrário, instrua o usuário a criar repositórios separados.

## Passo 4 — Instalar dependências adicionais

Após o scaffolding, instale conforme o ORM e banco escolhidos. Use o gerenciador de pacotes do projeto (detecte pelo `package.json`, `pyproject.toml`, `Gemfile`, etc.).

### Prisma
```bash
npm install prisma @prisma/client
npx prisma init --datasource-provider <postgresql|mysql|sqlite|mongodb>
```

### Drizzle (PostgreSQL)
```bash
npm install drizzle-orm pg
npm install -D drizzle-kit @types/pg
```

### Drizzle (MySQL)
```bash
npm install drizzle-orm mysql2
npm install -D drizzle-kit
```

### TypeORM
```bash
npm install typeorm reflect-metadata
npm install <pg|mysql2|sqlite3> conforme o banco
```

### SQLAlchemy
```bash
pip install sqlalchemy alembic psycopg2-binary  # ou o driver do banco escolhido
```

### Mongoose
```bash
npm install mongoose
```

Para outros ORMs ou linguagens, instale as dependências equivalentes conforme o ecossistema.

## Passo 5 — Criar .env e .env.example

Crie `.env.example` com as variáveis necessárias para a stack (sem valores reais):

```bash
# Banco de dados
DATABASE_URL=

# Aplicação
NODE_ENV=development
PORT=3000
```

Adapte as variáveis para a stack escolhida. Se `.env` não existir, crie uma cópia de `.env.example` como `.env` para desenvolvimento local.

Verifique se `.env` está no `.gitignore`. Se não estiver, adicione.

## Passo 6 — Verificar .gitignore

Confirme que o `.gitignore` cobre os padrões necessários para a stack:
- `node_modules/`, `.env`, `dist/`, `.next/` para projetos Node
- `__pycache__/`, `.env`, `*.pyc`, `.venv/` para Python
- `bin/`, `obj/` para .NET
- `vendor/` para PHP/Laravel
- Adicione o que estiver faltando

## Passo 7 — Primeiro commit

```bash
git add .
git commit -m "chore: initial project structure

Stack: [framework(s)], [banco], [orm]
Pattern: [pattern]"
```

## Resultado

Ao final, informe:
- Estrutura criada
- Dependências instaladas
- Próximos passos sugeridos (ex: configurar DATABASE_URL no .env, rodar migrations, iniciar o servidor de desenvolvimento)
