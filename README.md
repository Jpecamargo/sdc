# SDC — Spec Driven Claude

> [Leia em Português](README.pt-BR.md)

A Claude Code plugin that brings Spec-Driven Development to any project through specialized agents and a structured workflow.

---

## Installation

**Requirements:** [Claude Code](https://claude.ai/code) installed.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Jpecamargo/sdc/main/install.sh)
```

Then open Claude Code in any project and run `/sdc.init`. For new projects started from scratch, follow with `/bootstrap`.

<details>
<summary>Install from source</summary>

```bash
git clone https://github.com/Jpecamargo/sdc
cd sdc
bash install.sh
```
</details>

<details>
<summary>Uninstall</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Jpecamargo/sdc/main/uninstall.sh)
```
</details>

---

## What is Spec-Driven Development?

Spec-Driven Development (SDD) is a practice where a complete specification is written and approved **before** any code is produced.

### The problem it solves

When you ask an AI to implement a feature from a vague description, it generates code that looks right but often fails — the intent wasn't clear enough. This is called "vibe coding": the output is plausible but not correct.

With SDD, the spec defines the full contract upfront:

- **API contract** — endpoints, status codes, request/response shapes (or Server Actions for serverless projects)
- **Types** — TypeScript interfaces (or equivalent) for the frontend
- **DTOs/Schemas** — input validation and ORM schemas
- **Acceptance criteria** — verifiable behaviors that define "done"
- **Business rules** — logic that isn't obvious from the contract alone

### When not to use SDD

For bugs, small visual adjustments, and minor refactors — go directly to implementation. SDD is for features that introduce new behavior.

---

## Why "SDC"?

**S**pec **D**riven **C**laude.

SDC is built specifically for Claude Code. It uses Claude Code's native agent system (`.claude/agents/`) and slash commands (`.claude/commands/`) to enforce the SDD process. The Claude dependency is a feature, not a limitation.

---

## How it works

SDC installs four global slash commands into Claude Code. After running `/sdc.init` in any project, you get a full set of specialized agents and skills tailored to your stack and architectural pattern.

### The workflow

```
/clarify → architect → [gate: spec approval] → tdd → backend ∥ frontend → refine → test → [gate: manual validation] → docs → commit → /pr
```

| Step | Who | What happens |
|------|-----|-------------|
| `/clarify` | You + Claude | Describe the feature. Claude asks targeted questions, evaluates scope, and produces a consolidated brief. |
| `architect` | Agent (opus) | Checks for reusable code and applicable design patterns before writing the full spec in `docs/specs/`. Adapts spec format to the project's architectural pattern. |
| **[gate]** | **You** | **Review and approve the spec. Request changes or cancel if needed.** |
| `tdd` | Agent (sonnet) | Writes tests from the acceptance criteria — before the implementation exists. |
| `backend` + `frontend` | Agents (sonnet) | Implement in parallel (split projects) or sequentially (serverless/api-only) using the approved spec as the contract. |
| `refine` | Inline | Code review: architecture, DRY, security, naming, error handling. Violations are fixed immediately. |
| `test` | Inline | Compile + lint + run tests. Failures are fixed before moving on. |
| **[gate]** | **You** | **Test the feature manually. Request adjustments if needed. Confirm when ready.** |
| `docs` | Agent (haiku) | Updates `CLAUDE.md` to reflect structural changes. |
| `commit` | Inline | Semantic commit. |
| `/pr` | Inline | Opens a pull request to the configured base branch. Skipped if PR workflow is not enabled. |

### For bugs and adjustments

Use `/orchestrate` for anything that isn't a new feature. It reads which agents exist in the project before routing — so serverless projects with no `backend.md` correctly route server-side bugs to `frontend`.

| Situation | Flow |
|-----------|------|
| Backend bug | backend → test → commit |
| Frontend / UI bug | frontend → test → commit |
| Server-side bug (serverless) | frontend → test → commit |
| Visual change | design → frontend → test → commit |
| Refactor | refine → test → commit |
| Outdated docs | docs → commit |

---

## Architectural patterns

`/sdc.init` detects or asks about your project's architectural pattern and generates the right agents accordingly:

| Pattern | Description | Agents generated |
|---------|-------------|-----------------|
| `serverless` | One framework handles both UI and server logic (e.g. Next.js with Server Actions, SvelteKit, Nuxt) | `frontend.md` only — covers UI, Server Actions, and ORM |
| `split` | Separate backend and frontend processes (e.g. NestJS + React, FastAPI + Vue) | `backend.md` + `frontend.md` |
| `api-only` | Backend only, no UI (e.g. FastAPI, NestJS, Rails API) | `backend.md` only |

Agents are generated dynamically by Claude for any technology — no predefined stack list.

---

## What `/sdc.init` creates

```
.claude/
├── sdc.config.json     # stack choices and architectural pattern (versioned)
├── agents/
│   ├── architect.md    # opus   — spec writing, adapted to the project's pattern
│   ├── tdd.md          # sonnet — tests from acceptance criteria
│   ├── backend.md      # sonnet — your backend stack (split / api-only only)
│   ├── frontend.md     # sonnet — your frontend stack (split / serverless only)
│   ├── design.md       # sonnet — design system specs
│   └── docs.md         # haiku  — keeps CLAUDE.md in sync
└── commands/
    ├── bootstrap.md    # scaffold project, install deps, first commit (empty repos)
    ├── clarify.md      # full feature pipeline (entry point for new features)
    ├── orchestrate.md  # routes bugs, adjustments and refactors
    ├── commit.md       # semantic commits
    ├── test.md         # compile + lint + test
    ├── refine.md       # code review and violation fixes
    └── pr.md           # open pull request (PR workflow only)

docs/specs/
└── _template.md        # spec template with all required sections
```

---

## Plugin commands

| Command | Purpose |
|---------|---------|
| `/sdc.init` | Initialize a project: detects stack and pattern, generates agents, creates `sdc.config.json` and `CLAUDE.md` |
| `/sdc.clarify` | Clarify a feature, evaluate scope, propose splits if needed |
| `/sdc.upgrade` | Update the global plugin and, if in an initialized project, regenerate agents and commands to the latest standard. Migrates `sdc.config.json` from any previous version automatically. |
| `/sdc.help` | Full workflow reference and SDD introduction |

## Project commands

These are copied into `.claude/commands/` by `/sdc.init` and available inside every initialized project:

| Command | Purpose |
|---------|---------|
| `/bootstrap` | Scaffold the project using the framework's native CLI, install additional dependencies (ORM, drivers), configure `.env.example`, validate `.gitignore`, and create the first commit. Use once, in empty repos, right after `/sdc.init`. |
| `/clarify` | Entry point for new features — runs the full spec-driven pipeline |
| `/orchestrate` | Routes bugs, adjustments, and refactors to the right agent |
| `/refine` | Code review and violation fixes |
| `/test` | Compile + lint + run tests |
| `/commit` | Semantic commit |
| `/pr` | Open a pull request (PR workflow only) |

---

## Parallel development with Git Worktree

When the project uses git worktree, multiple features can be developed simultaneously across separate Claude Code sessions.

**The rule:** finish the spec phase before starting implementation. Once implementation starts, a new session can begin the next spec.

```
Session A:  /clarify → architect → [approval] → tdd → backend ∥ frontend → ...
                                       ↓
                          Session B can now start:
                          /clarify → architect → [approval] → tdd → ...
```

---

## PR Workflow (optional)

When enabled during `/sdc.init` or `/sdc.upgrade`, every feature starts on a dedicated branch and ends with a pull request.

**Setup:** during init, answer yes to "PR workflow?" and provide a base branch (e.g. `main`).

**Base branch override:** pass it as an argument when needed: `/pr develop`

**With git worktree:** open the PR before merging the worktree back to root, then remove it with `git worktree remove <path>`.

---

## Contributing

Templates are plain markdown files in `templates/`. To contribute:

- **New agent behavior**: edit `templates/agents/<agent>.md`
- **New command logic**: edit `templates/commands/<command>.md`
- **Spec template**: edit `templates/specs/_template.md`

Adding support for a new technology requires no code changes — agents are generated dynamically by Claude based on the user's stack choices.

See [CHANGELOG.md](CHANGELOG.md) for the full version history.
