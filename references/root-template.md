# Root CLAUDE.md template

Use this exact skeleton, fill in placeholders, keep total under 60 lines.

```markdown
# CLAUDE.md

Behavioral guidelines for working on `<project-name>`.

## Core rules
1. **Think Before Coding** — surface assumptions, ask, push back on simpler alternatives.
2. **Simplicity First** — minimum code, no speculative features, no premature abstractions.
3. **Surgical Changes** — touch only what's required, match existing style, clean up only your own mess.
4. **Goal-Driven Execution** — turn requests into verifiable goals, loop until tests pass.

## Project conventions
- Package manager: `<pnpm | npm | yarn | bun | pip | poetry | uv | cargo | go>`
- Test: `<e.g. pnpm test>`
- Typecheck: `<e.g. pnpm run typecheck>`
- Lint: `<e.g. pnpm run lint>`
- Format: `<e.g. pnpm run format>`

## Workflow
- Branch: `<prefix>/<issue-id>-<slug>` (e.g. `feat/ENG-1234-fix-login`)
- Commit: `<type>(<scope>): <summary>` — types: feat, fix, refactor, docs, test, chore
- PR: open against `main`, link the issue, fill the PR template

## Verification
Run `<typecheck> && <test> --changed` before stopping. Failures are required reading — do not ignore them.

## Things to avoid
- Do not <project-specific ban 1>
- Do not <project-specific ban 2>
- Do not <project-specific ban 3>
```

## Hard constraints

- The whole file MUST be under 60 lines (excluding code blocks).
- NO directory tree, NO codebase overview, NO module list — let the agent discover.
- NO generic advice that isn't enforced (e.g. "write clean code").
- Every "do not" must be specific and verifiable.
- The verification command MUST actually exist in `package.json` / `Makefile` / equivalent.

## How to fill placeholders

1. **Package manager**: read `package.json` lockfile, `pyproject.toml`, `Cargo.toml`, `go.mod`, etc.
2. **Test command**: read `scripts` in `package.json`, `[tool.pytest]` in pyproject, `Makefile` targets.
3. **Typecheck**: look for `tsc`, `mypy`, `pyright`, `go vet`, `cargo check`.
4. **Lint**: look for `eslint`, `biome`, `ruff`, `flake8`, `golangci-lint`.
5. **Project-specific bans**: read the README's "Contributing" section, any existing CONTRIBUTING.md, and look for repeated patterns in the codebase (e.g. a `// FIXME: do not do X` comment).
