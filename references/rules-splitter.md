# Rules splitter — when to split, how to split

## Decision tree

```
Has the project a clear tech stack (language + framework)?
├── No → ask the user, don't generate
└── Yes
    │
    Is the project < 10 source files?
    ├── Yes → single root CLAUDE.md, no .claude/rules/
    └── No
        │
        Is there a single concern (e.g. script, CLI tool, small server)?
        ├── Yes → 1-2 rule files max
        └── No → full .claude/rules/ layout
```

## Default rule files to generate (full-stack web app)

| File | `paths:` | When to skip |
|---|---|---|
| `api-conventions.md` | `src/api/**`, `src/routes/**`, `app/api/**` | No backend / pure frontend |
| `db-conventions.md` | `src/db/**`, `prisma/**`, `drizzle/**`, `migrations/**` | No DB |
| `frontend-conventions.md` | `src/components/**`, `src/pages/**`, `app/**/page.tsx` | No frontend |
| `testing-conventions.md` | `**/*.test.*`, `**/*.spec.*`, `tests/**` | No tests |
| `styling-conventions.md` | `**/*.css`, `**/*.scss`, `tailwind.config.*` | No CSS |
| `auth-conventions.md` | `src/auth/**`, `src/middleware/auth*` | No auth |
| `deployment-conventions.md` | `Dockerfile*`, `docker-compose*`, `.github/workflows/**`, `k8s/**` | No deployment config |

## Detection patterns

### TypeScript / JavaScript
- `package.json` present → look at `dependencies`, `devDependencies`, `scripts`
- React: `react`, `next`, `remix`, `gatsby` in deps
- Vue: `vue`, `nuxt` in deps
- Svelte: `svelte`, `sveltekit` in deps
- Node backend: `express`, `fastify`, `koa`, `hapi`, `nestjs` in deps
- ORM: `prisma`, `drizzle-orm`, `typeorm`, `sequelize`, `knex` in deps
- Testing: `jest`, `vitest`, `mocha`, `playwright`, `cypress` in devDeps

### Python
- `pyproject.toml` or `requirements.txt` → check for `fastapi`, `django`, `flask`, `starlette`
- ORM: `sqlalchemy`, `django-orm`, `tortoise-orm`
- Testing: `pytest`, `unittest`
- Typecheck: `mypy`, `pyright`, `ruff`

### Go
- `go.mod` → check module path for hints
- Web: `gin`, `echo`, `fiber`, `chi`
- ORM: `gorm`, `sqlx`, `ent`
- Testing: standard `testing` package

### Rust
- `Cargo.toml` → check `[dependencies]`
- Web: `actix-web`, `axum`, `rocket`
- ORM: `diesel`, `sea-orm`, `sqlx`
- Testing: built-in + `mockall`, `wiremock`

## Frontmatter `paths:` patterns

Pick the right pattern for the project:

- **Monorepo with `apps/` and `packages/`**:
  ```yaml
  paths:
    - "apps/web/**"
    - "packages/ui/**"
  ```
- **Next.js App Router**:
  ```yaml
  paths:
    - "app/**/page.tsx"
    - "app/**/layout.tsx"
  ```
- **Django**:
  ```yaml
  paths:
    - "<app_name>/models.py"
    - "<app_name>/views.py"
  ```
- **Go clean architecture**:
  ```yaml
  paths:
    - "internal/**"
    - "pkg/**"
  ```

## Monorepo handling

For monorepos, generate one root CLAUDE.md (workspace-level) AND one rule file per package. The package-level rule file uses the package's `paths:` scope.

Example for `apps/web/.claude/rules/frontend.md`:
```yaml
---
paths:
  - "**/*.tsx"
  - "**/*.ts"
  - "!**/*.test.ts"
---

# Frontend (apps/web)
...
```

## When the user pushes back

If the user says "this is too many files" or "I just want one CLAUDE.md":

- Collapse all rule files into root if total content is < 100 lines
- Otherwise, suggest using sections (`## API`, `## DB`) in root and note that they'll need to split when root passes 200 lines
