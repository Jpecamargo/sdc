# SDC — Spec Driven Claude

> [Leia em Português](README.pt-BR.md)

A Claude Code plugin that brings Spec-Driven Development to any project through specialized agents and a structured workflow.

---

## Installation

**Requirements:** [Claude Code](https://claude.ai/code) installed.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Jpecamargo/sdc/main/install.sh)
```

Then open Claude Code in any project and run `/sdc.init`.

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

- **API contract** — endpoints, status codes, request/response shapes
- **Types** — TypeScript interfaces (or equivalent) for the frontend
- **DTOs/Schemas** — input validation for the backend
- **Acceptance criteria** — verifiable behaviors that define "done"
- **Business rules** — logic that isn't obvious from the contract alone

Backend and frontend read the same spec independently and arrive at the same result. No misalignment, no rewrite.

### When not to use SDD

For bugs, small visual adjustments, and minor refactors — go directly to implementation. SDD is for features that introduce new behavior.

---

## Why "SDC"?

**S**pec **D**riven **C**laude.

SDC is built specifically for Claude Code. It's not a generic AI workflow tool — it uses Claude Code's native agent system (`.claude/agents/`) and slash commands (`.claude/commands/`) to enforce the SDD process. The Claude dependency is a feature, not a limitation.

---

## How it works

SDC installs four global slash commands into Claude Code. After running `/sdc.init` in any project, you get a full set of specialized agents and skills configured for your stack.

### The workflow

```
/clarify → architect → tdd → backend ∥ frontend → /refine → /test → /commit → /pr → docs
```

| Step | Who | What happens |
|------|-----|-------------|
| `/sdc.clarify` | You + Claude | Describe the feature. Claude asks targeted questions to resolve ambiguities and evaluates if the scope fits one spec or should be split. |
| `architect` | Agent (opus) | Writes the full spec in `docs/specs/`. Presents a summary and **waits for your explicit approval** before anything is implemented. |
| `tdd` | Agent (sonnet) | Writes tests from the acceptance criteria — before the implementation exists. Tests fail until the code is written; that's expected. |
| `backend` + `frontend` | Agents (sonnet) | Implement in parallel using the approved spec as the contract. No coordination needed between them. |
| `/refine` | Inline | Code review: architecture violations, security, naming, missing error handling. |
| `/test` | Inline | Compile + lint + run tests. |
| `/commit` | Inline | Semantic commit for the phase. |
| `/pr` | Inline (haiku) | Open a pull request to the configured base branch. Skipped if PR workflow is not enabled. |
| `docs` | Agent (haiku) | Updates `CLAUDE.md` and agents to reflect structural changes. |

### PR Workflow (optional)

When enabled during `/sdc.init` or `/sdc.upgrade`, every feature starts on a new branch and ends with a pull request.

**Setup:** during init, answer yes to "PR workflow?" and provide a base branch (e.g. `main`). This adds a `## PR Workflow` section to `CLAUDE.md` that stores the base branch.

**Branch creation:** `/orchestrate` detects if you're on the base branch and prompts for a feature branch name before starting any work.

**Opening the PR:** run `/pr` when ready. It pushes the branch if needed and runs `gh pr create` against the configured base branch. You can override the base branch ad hoc:

```
/pr develop
```

**With git worktree:** the PR must be opened before merging the worktree back to root. `/pr` reminds you to remove the worktree after merge.

### For bugs and adjustments

| Situation | Flow |
|-----------|------|
| Backend bug | backend → /test → /commit |
| Frontend / UI bug | frontend → /test → /commit |
| Visual change | design → frontend → /test → /commit |
| Refactor | /refine → /test → /commit |
| Outdated docs | docs → /commit |

---

## Parallel development with Git Worktree

When the project uses git worktree, multiple features can be developed simultaneously across separate Claude Code sessions.

**The rule:** finish the spec phase before starting implementation. Once implementation starts, a new session can begin the next spec.

```
Session A:  /sdc.clarify → architect → [approval] → tdd → backend ∥ frontend → ...
                                            ↓
                               Session B can now start:
                               /sdc.clarify → architect → [approval] → tdd → ...
```

- **One spec at a time** — don't start speccing a new feature until the current one is approved
- **Parallel implementations** — once tdd begins, open a new session for the next spec
- **No file conflicts** — each implementation session is isolated via worktree

---

## Installation

See the [quick install](#installation) at the top.

---

## Plugin commands

| Command | Purpose |
|---------|---------|
| `/sdc.init` | Initialize a project: detects stack, creates `.claude/` structure and `CLAUDE.md` |
| `/sdc.clarify` | Clarify a feature, evaluate scope, propose splits if needed |
| `/sdc.upgrade` | Update agents/commands to latest templates without touching specs |
| `/sdc.help` | Full workflow reference and SDD introduction |

## What `/sdc.init` creates

```
.claude/
├── agents/
│   ├── architect.md    # opus   — specs, contracts, acceptance criteria
│   ├── tdd.md          # sonnet — tests from acceptance criteria
│   ├── backend.md      # sonnet — your backend stack
│   ├── frontend.md     # sonnet — your frontend stack (if applicable)
│   ├── design.md       # sonnet — design system specs
│   └── docs.md         # haiku  — keeps CLAUDE.md in sync
└── commands/
    ├── orchestrate.md  # routes requests to the right agent
    ├── clarify.md      # resolves ambiguities before spec
    ├── commit.md       # haiku  — semantic commits
    ├── test.md         # compile + lint + test
    ├── refine.md       # code review and violation fixes
    └── pr.md           # haiku  — open pull request (PR workflow only)

docs/specs/
└── _template.md        # spec template with all required sections
```

---

## Supported stacks

**Backend**: NestJS · Express · FastAPI · Django · Rails

**Frontend**: Next.js · React+Vite · Angular · Vue

---

## Contributing

Templates are plain markdown files. To add a new stack:

1. Create `templates/agents/backend-<stack>.md` or `templates/agents/frontend-<stack>.md`
2. Add the stack name to the detection logic in `commands/sdc.init.md`
3. Submit a PR
