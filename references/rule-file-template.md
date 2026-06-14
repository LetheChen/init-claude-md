# Rule file template (.claude/rules/*.md)

One file per concern. Loaded automatically when the agent touches a file matching `paths:`.

## Skeleton

```markdown
---
paths:
  - "src/api/**"
  - "src/routes/**"
---

# <Concern name>

<Brief one-line context of why this file exists.>

## Rules
- <Specific, verifiable rule 1>
- <Specific, verifiable rule 2>
- <Specific, verifiable rule 3>
- ...

## Examples (optional)
- Good: `<one-line code snippet>`
- Bad: `<one-line code snippet>`

## Anti-patterns
- <What not to do, with the failure mode>
```

## Frontmatter field reference

### `paths` (array of glob patterns, optional)
- Glob is relative to repo root.
- Standard glob syntax: `*`, `**`, `?`, `[abc]`.
- If omitted, the rule loads for every file (treat as global rule, prefer to put those in root).
- Multiple patterns are OR'd: matching ANY of them loads the rule.
- Pattern examples:
  - `src/api/**` — every file under src/api
  - `**/*.test.ts` — every test file
  - `src/db/migrations/**` — only migrations
  - `*.{json,yaml,yml}` — root config files

### `description` (optional, not all clients support)
- Free text describing the rule. Some clients surface it in tooltips.

## What goes in a rule file

- Concrete, runnable rules (e.g. "Always wrap `db.query` in a try/catch")
- Project-specific gotchas (e.g. "Our ORM is in `src/db/`, raw SQL is banned")
- Code style requirements that differ from the linter defaults
- Critical anti-patterns with the failure they cause

## What does NOT go in a rule file

- Generic style (covered by ESLint/Prettier)
- LLM behavioral guidelines (those go in root)
- Directory trees / module overviews
- Untestable wishes like "write clean code"

## Size

- Aim for 30-80 lines per file.
- If approaching 200 lines, split further (e.g. `api-conventions.md` → `api-routing.md` + `api-errors.md`).

## Naming

- Lowercase, hyphen-separated: `api-conventions.md`, `db-conventions.md`, `testing-conventions.md`
- File name should describe the concern, not the location.
- Avoid: `rules.md`, `misc.md`, `notes.md`
