# CLAUDE.md

Minimal, high-signal project rules. Keep this file under 60 lines.
Detailed conventions live in `.claude/rules/` and load on-demand via path frontmatter.

## Project conventions
- All database access goes through /src/db/queries/, never raw SQL inline.
- Use `pnpm run typecheck` after every change.
- Never modify migration files after they've been committed.

## Linear workflow
- Fetch issues: `linear get-issue ENG-XXXX`
- Update status: `linear update-status ENG-XXXX "in dev"`
- Close finished issues: `linear update-status ENG-XXXX "done"`

## Git workflow
- Branch naming: `eng/<issue-id>-<short-description>` (e.g. `eng-1234-fix-login-redirect`).
- Commit format: `<type>(scope): summary` (e.g. `feat(auth): add session timeout`).
- Always rebase before merge: `git fetch origin && git rebase origin/main`.

## Verification
Run `pnpm run typecheck && pnpm test --changed` before stopping.
Failures are required reading — do not ignore them.

## Things to avoid
- Do not add dependencies without justification.
- Do not refactor unrelated code in a fix.
- Do not commit secrets, `.env` files, or large binaries.
- Do not skip pre-commit hooks (`--no-verify` is banned).
- Do not export symbols that aren't consumed externally.
