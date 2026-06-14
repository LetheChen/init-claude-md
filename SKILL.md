---
name: init-claude-md
description: Generate a project-specific CLAUDE.md file (and .claude/rules/ directory) following the minimal, high-signal pattern from HumanLayer combined with Karpathy's 4 core behavioral rules. Works with both Codex (OpenAI) and Claude Code (Anthropic). Use this skill whenever the user mentions CLAUDE.md, Claude Code configuration, AI agent project rules, or wants to initialize/set up AI coding guidelines for a new or existing project. Also use when the user has a CLAUDE.md that has grown past 200 lines and needs splitting. Don't wait for explicit phrasing — trigger on any request to "set up", "create", "init", "generate", or "rebuild" a CLAUDE.md for a project.
---

# Init CLAUDE.md

Generate a project-specific CLAUDE.md (consumed by **Claude Code** — `.claude/rules/` path-scoped loading) that follows two proven patterns:

1. **Karpathy 4 rules** — behavioral guidelines that prevent common LLM coding mistakes (Think / Simplicity / Surgical / Goal-driven)
2. **HumanLayer minimal pattern** — root CLAUDE.md under 60 lines, all detailed conventions live in `.claude/rules/` with `paths:` frontmatter for path-scoped loading

## Platform compatibility

This skill runs on **both Codex and Claude Code**. The instructions below describe *what* to do, not which tool to use.

| Task | Claude Code | Codex |
|---|---|---|
| File scanning | Glob, Grep, Read | `shell_command` (rg, Get-ChildItem, ls) |
| File reading | Read | `shell_command` (cat, Get-Content) |
| File writing | Write, Edit | `apply_patch`, `shell_command` |
| Dir detection | Glob | `shell_command` (Test-Path, Get-ChildItem) |

Translate the intent below into your platform's toolset.

---

## When to use

- User says "生成 CLAUDE.md" / "init CLAUDE.md" / "set up Claude Code rules" / "为这个项目写 CLAUDE.md"
- User has a CLAUDE.md that has grown past 200 lines and asks to split or refactor it
- User mentions `.claude/rules/` or asks for path-scoped rules
- A new project is being set up and needs AI-coding guidance

## When NOT to use

- User wants to update a single specific rule (just edit the file directly)
- User is asking what CLAUDE.md is (explain instead)
- The project has no code yet (gather info first)

## Workflow

### Step 1: Scan the project (parallelize where your toolset allows)

Before writing anything, find and read these files:

- `README.md` / `README.*.md` — project purpose, quickstart
- `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml` / `pom.xml` — language, framework, scripts
- `tsconfig.json` / `jsconfig.json` — TS/JS config
- Top-level directory listing — feature folders, monorepo packages
- Existing `CLAUDE.md` / `AGENTS.md` — current state, if any
- `.eslintrc*` / `biome.json` / `.prettierrc*` — style enforcement
- `Makefile` / `justfile` — task runners
- `Dockerfile` / `docker-compose*.yml` — deployment
- `.github/workflows/` — CI conventions
- `prisma/schema.prisma` / `drizzle.config.*` / `migrations/` — DB stack
- `pnpm-workspace.yaml` / `lerna.json` / `nx.json` / `turbo.json` — monorepo detection
- `.gitignore` — check if `.claude/` is gitignored

**Edge cases:**
- **Empty project** (no code yet): stop and ask the user for language, framework, package manager, test runner. Do not fabricate.
- **Existing CLAUDE.md / .claude/rules/**: read it fully and **merge** — preserve existing rules, add only what's missing. Show the diff and confirm before writing.
- **`.gitignore` excludes `.claude/`**: warn the user that generated `.claude/rules/` files won't be tracked. Suggest removing the pattern before committing.

### Step 2: Decide the rule layout

Based on what you found, choose a layout:

**Layout A — single root file** (for small projects, <10 source files, no DB, no auth):
- Just `CLAUDE.md`, no `.claude/rules/`
- Keep under 60 lines

**Layout B — root + rules directory** (default; for everything else):
- `CLAUDE.md` — project conventions, workflow, verification (under 60 lines)
- `.claude/rules/` — one file per concern (api, db, frontend, testing, etc.)
- Each rule file declares `paths:` frontmatter so it only loads when relevant files are touched

**Layout C — monorepo** (detected via `pnpm-workspace.yaml`, `lerna.json`, `turbo.json`, or `apps/`+`packages/` dirs):
- Root `CLAUDE.md` — workspace-level conventions, global commands, shared verification
- `.claude/rules/` at root — workspace-wide rules
- Each package (`apps/*`, `packages/*`) gets its own `.claude/rules/` with **scoped `paths:`** (see `references/rules-splitter.md` for monorepo patterns)
- No duplication: put shared rules in root `.claude/rules/`, package-specific rules inside the package

If both Layout B and C could apply, prefer C if workspace file exists, B otherwise.

### Step 3: Generate the root CLAUDE.md

Read `references/root-template.md` and `references/content-rules.md` before writing. The skeleton is:

```markdown
# CLAUDE.md

Behavioral guidelines for working on this project.

## Core rules (from Karpathy)
1. Think Before Coding — surface assumptions, push back when warranted
2. Simplicity First — minimum code that solves the problem
3. Surgical Changes — touch only what you must
4. Goal-Driven Execution — define success criteria, loop until verified

## Project conventions
- [detected package manager command]
- [detected test command]
- [detected typecheck/lint command]
- [1-3 project-specific gotchas]

## Workflow
- Branch: [detected or standard pattern]
- Commit: [detected or conventional commits]
- PR: [detected or standard]

## Verification
Run `<typecheck> && <test> --changed` before stopping. Failures are required reading.

## Things to avoid
- 3-5 hard "do not" rules distilled from project reality
```

Constraints:
- Keep root file under **60 lines** (80 hard limit). If you exceed 80, split aggressively.
- **No directory tree, no codebase overview, no module list** — let the agent discover.
- Every "do not" must be specific and verifiable.
- The verification command must actually exist in the project.

### Step 4: Generate `.claude/rules/` files

Read `references/rules-splitter.md` first. Common rule files:

- `api-conventions.md` — backend endpoint patterns, error format
- `db-conventions.md` — query patterns, migration rules
- `frontend-conventions.md` — component patterns, state management
- `testing-conventions.md` — test framework, fixtures, coverage
- `styling-conventions.md` — CSS approach, design tokens
- `security-conventions.md` — auth, secrets, validation

Each file follows the template in `references/rule-file-template.md`:

```markdown
---
paths:
  - "src/api/**"
  - "src/routes/**"
---

# [Concern name]

[Brief intro of why this file exists]

## Rules
- [rule 1, specific and verifiable]
- [rule 2, specific and verifiable]
- ...
```

**For monorepo Layout C**: generate one rule file per package inside the package's `.claude/rules/` directory, with `paths:` patterns scoped to that package's subtree.

### Step 5: Self-check

Before declaring done:

- [ ] Existing CLAUDE.md / .claude/rules/ was merged, not clobbered
- [ ] `.gitignore` does not exclude `.claude/` (warned user if it does)
- [ ] Root CLAUDE.md is under 60 lines (80 hard limit)
- [ ] Root CLAUDE.md has no directory tree or codebase overview
- [ ] Every rule file has a `paths:` frontmatter (or clear "global" comment)
- [ ] No rule file exceeds 200 lines
- [ ] No "do not do X" without explaining why
- [ ] Verification command at the end of root file is actually runnable
- [ ] No copy-pasted framework defaults that don't apply
- [ ] Monorepo: root covers workspace, packages have scoped rules

### Step 6: Tell the user what to do next

Summarize what was created and what the user should do:

```
Created:
- CLAUDE.md (X lines)
- .claude/rules/api-conventions.md
- .claude/rules/db-conventions.md
- .claude/rules/frontend-conventions.md (apps/web)

Next:
1. Open each file and confirm the inferred rules match your team's reality
2. Run the verification command once manually to confirm it works
3. Commit, then watch Claude's next session — any rule that gets ignored = rewrite it
4. When root CLAUDE.md approaches 200 lines, split more aggressively

Rollback:
- Not satisfied? `git checkout CLAUDE.md .claude/` to revert, then re-run
- Single file off? Edit directly — the rules are markdown, owned by humans
```

## References

- `references/root-template.md` — the exact root CLAUDE.md skeleton to fill in
- `references/rule-file-template.md` — the per-concern rule file skeleton
- `references/content-rules.md` — what to put in and what to leave out
- `references/rules-splitter.md` — decision tree for splitting into multiple files
- `references/karpathy-rules.md` — verbatim copy of the 4 core rules for embedding
 - `examples/humanlayer-CLAUDE.md` — generated output example following the HumanLayer minimal pattern
 - `examples/karpathy-CLAUDE.md` — generated output example following the pure Karpathy rules pattern
