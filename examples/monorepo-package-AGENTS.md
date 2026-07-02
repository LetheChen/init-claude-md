# AGENTS.md (apps/web)

## Session Maintenance Protocol

**开始时**：读 `TODO.md` 和 `../../AGENTS.md`（workspace 规则）；冲突以 workspace 为准。

**结束前**：跑 `pnpm --filter web typecheck && pnpm --filter web test`；更新本包和根 `TODO.md`。

**触发条件**：改了 `apps/web/**` 下的任何文件 · 改了 web 包依赖

## Project conventions
- 包内开发：`pnpm --filter web dev`
- 包内测试：`pnpm --filter web test`
- API 调用：统一走 `packages/api-client`，**不要**直接 `fetch`
- 状态管理：Zustand（不要再引 Redux）

## Things to avoid
- 不要在 web 包内直接 `import` 自 `apps/api/**`（必须经 `packages/shared-types`）
- 不要在 web 包的 `package.json` 加 `next`、`react`（这些由 workspace 锁版本）
- 不要在 web 包里写 Node 后端代码（API 端去 `apps/api/`）
- 不要用 `localStorage` 存 token（用 httpOnly cookie）

## Verification
`pnpm --filter web typecheck && pnpm --filter web test` — 失败必读。