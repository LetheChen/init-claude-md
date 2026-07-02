# Rules splitter — Layout A/B/C 决策树

## 三种布局概览

| Layout | 适用 | 文件 |
|---|---|---|
| **A** 单文件 | <10 源文件，无 DB，无 auth，单一关注点 | 仅 `CLAUDE.md` / `AGENTS.md` |
| **B** 根 + 规则目录 | 默认选择 | `CLAUDE.md` / `AGENTS.md` + `.claude/rules/*.md` |
| **C** Monorepo | 顶层有 `apps/` `packages/` `services/` 多个子包 | 根文件 + 每个子包一份 `AGENTS.md` 或 `.claude/rules/*.md` |

## 决策树

```
是否有清晰技术栈？
├── 否 → 问用户，不要生成
└── 是
    │
    是否 monorepo（顶层有 apps/ packages/ services/ modules/）？
    ├── 是 → Layout C（monorepo）
    └── 否
        │
        源代码文件 <10 且无 DB、无 auth？
        ├── 是 → Layout A（仅根文件）
        └── 否
            │
            是否单一关注点（脚本 / CLI / 小服务）？
            ├── 是 → 1-2 个 rule 文件 + 根文件
            └── 否 → Layout B（根文件 + 完整 .claude/rules/）
```

## Layout C — Monorepo 详细规则

### 检测

- 顶层存在 `apps/` `packages/` `services/` `modules/` 中**至少 1 个**
- 上述目录里**至少 2 个**子项目（每个有自己的 `package.json` / `pyproject.toml` / `go.mod`）
- 根目录有 workspace 配置文件（`pnpm-workspace.yaml` / `lerna.json` / `turbo.json` / npm/yarn/pnpm/bun workspaces in `package.json`）

### 文件结构

```
<monorepo-root>/
├── AGENTS.md / CLAUDE.md        # workspace 级，<60 行
├── apps/
│   ├── web/
│   │   └── AGENTS.md            # 子包级，<60 行，关注 web 特定
│   └── api/
│       └── AGENTS.md            # 子包级，<60 行，关注 api 特定
├── packages/
│   ├── ui/                      # 可选：放组件库
│   └── shared-types/            # 可选：放类型共享
└── pnpm-workspace.yaml          # 现有 workspace 配置
```

### workspace 级 AGENTS.md 模板要点

- 顶部带 Session Maintenance Protocol 块
- `## Project conventions` 段：workspace 级别的命令（`pnpm -r build`、`turbo run test`）
- `## Things to avoid`：workspace 级别的（不要跨子包直接 import、用 workspace 协议）
- **不**写每个子包的细节 — 那些在子包的 AGENTS.md 里

### 子包级 AGENTS.md 模板要点

- 顶部带 Session Maintenance Protocol 块
- `paths:` frontmatter 限定在子包路径（`apps/web/**` / `apps/web/*`）
- `## Project conventions`：子包自己的命令（`pnpm --filter web dev`）
- `## Things to avoid`：子包特定（不要直接 `fetch`，用统一的 `apiClient`）

完整例子见 `examples/monorepo-root-CLAUDE.md` 和 `examples/monorepo-package-AGENTS.md`。

## Layout B — 默认规则文件清单（全栈 Web 应用）

| 文件 | `paths:` | 何时跳过 |
|---|---|---|
| `api-conventions.md` | `src/api/**`, `src/routes/**`, `app/api/**` | 无后端 / 纯前端 |
| `db-conventions.md` | `src/db/**`, `prisma/**`, `drizzle/**`, `migrations/**` | 无 DB |
| `frontend-conventions.md` | `src/components/**`, `src/pages/**`, `app/**/page.tsx` | 无前端 |
| `testing-conventions.md` | `**/*.test.*`, `**/*.spec.*`, `tests/**` | 无测试 |
| `styling-conventions.md` | `**/*.css`, `**/*.scss`, `tailwind.config.*` | 无 CSS |
| `auth-conventions.md` | `src/auth/**`, `src/middleware/auth*` | 无 auth |
| `deployment-conventions.md` | `Dockerfile*`, `docker-compose*`, `.github/workflows/**`, `k8s/**` | 无部署配置 |

## 检测矩阵

### TypeScript / JavaScript
- `package.json` 存在 → 看 `dependencies`, `devDependencies`, `scripts`
- React: `react`, `next`, `remix`, `gatsby` 在 deps
- Vue: `vue`, `nuxt` 在 deps
- Svelte: `svelte`, `sveltekit` 在 deps
- Node backend: `express`, `fastify`, `koa`, `hapi`, `nestjs` 在 deps
- ORM: `prisma`, `drizzle-orm`, `typeorm`, `sequelize`, `knex` 在 deps
- Testing: `jest`, `vitest`, `mocha`, `playwright`, `cypress` 在 devDeps

### Python
- `pyproject.toml` 或 `requirements.txt` → 检查 `fastapi`, `django`, `flask`, `starlette`
- ORM: `sqlalchemy`, `django-orm`, `tortoise-orm`
- Testing: `pytest`, `unittest`
- Typecheck: `mypy`, `pyright`, `ruff`

### Go
- `go.mod` → 看 module path
- Web: `gin`, `echo`, `fiber`, `chi`
- ORM: `gorm`, `sqlx`, `ent`
- Testing: 标准 `testing` 包

### Rust
- `Cargo.toml` → 看 `[dependencies]`
- Web: `actix-web`, `axum`, `rocket`
- ORM: `diesel`, `sea-orm`, `sqlx`
- Testing: 内置 + `mockall`, `wiremock`

## Frontmatter `paths:` 模式

挑匹配项目结构的 pattern：

- **Monorepo**：
  ```yaml
  paths:
    - "apps/web/**"
    - "packages/ui/**"
  ```
- **Next.js App Router**：
  ```yaml
  paths:
    - "app/**/page.tsx"
    - "app/**/layout.tsx"
  ```
- **Django**：
  ```yaml
  paths:
    - "<app_name>/models.py"
    - "<app_name>/views.py"
  ```
- **Go clean architecture**：
  ```yaml
  paths:
    - "internal/**"
    - "pkg/**"
  ```

## 用户回退

如果用户说"文件太多了"或"我只要一份 CLAUDE.md"：

- 如果所有 rule 内容总和 <100 行 → 合并到根
- 否则建议在根文件用 section（`## API`, `## DB`），告诉用户接近 200 行时再拆