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

`/clarify` is the single entry point for new features. It orchestrates the full pipeline automatically — the only moments it stops are the two gates that require your input.

```
/clarify → architect → [gate: spec approval] → tdd → backend ∥ frontend → refine → test → [gate: manual validation] → docs → commit → /pr
```

| Step | Who | What happens |
|------|-----|-------------|
| `/clarify` | You + Claude | Describe the feature. Claude asks targeted questions, evaluates scope, and produces a consolidated brief. |
| `architect` | Agent (opus) | Checks for reusable code (DRY) and applicable design patterns before writing the full spec in `docs/specs/`. |
| **[gate]** | **You** | **Review and approve the spec. Request changes or cancel if needed.** |
| `tdd` | Agent (sonnet) | Writes tests from the acceptance criteria — before the implementation exists. |
| `backend` + `frontend` | Agents (sonnet) | Implement in parallel using the approved spec as the contract. |
| refine | Inline | Code review: architecture, DRY, security, naming, error handling. Violations are fixed immediately. |
| test | Inline | Compile + lint + run tests. Failures are fixed before moving on. |
| **[gate]** | **You** | **Test the feature manually. Request adjustments if needed. Confirm when ready.** |
| `docs` | Agent (haiku) | Updates `CLAUDE.md` to reflect structural changes. |
| commit | Inline | Semantic commit. |
| `/pr` | Inline (haiku) | Opens a pull request to the configured base branch. Skipped if PR workflow is not enabled. |

### For bugs and adjustments

Use `/orchestrate` for anything that isn't a new feature.

| Situation | Flow |
|-----------|------|
| Backend bug | backend → test → commit |
| Frontend / UI bug | frontend → test → commit |
| Visual change | design → frontend → test → commit |
| Refactor | refine → test → commit |
| Outdated docs | docs → commit |

If PR workflow is active, `/pr` is added after commit in all flows.

### PR Workflow (optional)

When enabled during `/sdc.init` or `/sdc.upgrade`, every feature starts on a dedicated branch and ends with a pull request.

**Setup:** during init, answer yes to "PR workflow?" and provide a base branch (e.g. `main`). This adds a `## PR Workflow` section to `CLAUDE.md`.

**Branch creation:** `/clarify` and `/orchestrate` detect if you're on the base branch and prompt for a feature branch name before starting any work.

**Base branch override:** pass it as an argument when needed:

```
/pr develop
```

**With git worktree:** the PR is opened before merging the worktree back to root. After merge, remove the worktree with `git worktree remove <path>`.

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
│   ├── architect.md    # opus   — DRY check, design patterns, spec writing
│   ├── tdd.md          # sonnet — tests from acceptance criteria
│   ├── backend.md      # sonnet — your backend stack
│   ├── frontend.md     # sonnet — your frontend stack (if applicable)
│   ├── design.md       # sonnet — design system specs
│   └── docs.md         # haiku  — keeps CLAUDE.md in sync
└── commands/
    ├── clarify.md      # full feature pipeline (entry point for new features)
    ├── orchestrate.md  # routes bugs, adjustments and refactors
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
