# AGENTS.md (workspace root)

## Session Maintenance Protocol

**开始时**：读 `TODO.md`，复述当前 🔴 和 🟡 段；扫一遍子包 `AGENTS.md`，标出冲突。

**结束前**：1) 跑 workspace 级 `pnpm -r typecheck` 确认无回归；2) 更新 `TODO.md`；3) **子包规则**有变化时同时更新 `<子包>/AGENTS.md`。

**触发条件**：跨子包改动 · 改了 workspace 工具配置 · 用户纠正了跨包约定

## Project conventions
- Workspace 包管理：`pnpm -r`；所有命令从根目录跑
- Typecheck：`pnpm -r typecheck`
- Test：`pnpm -r test --changed`
- 构建：`turbo run build`（按依赖顺序）

## Workflow
- Branch: `codex/<scope>-<slug>`（scope 是 `infra` / `web` / `api` / `shared`）
- Commit: Conventional Commits
- 跨子包改动 → 单独一个 commit 标 `feat(workspace):`，子包内改动标 `<type>(<子包>):`

## Language
- Communication: `zh`
- Code comments: `zh`
- Commit messages: `en`（Conventional Commits 必须英文）
- Rule files: `bilingual`

## Things to avoid
- 不要跨子包直接 import（必须经 `packages/shared-types`）
- 不要把 `package.json` 的 `dependencies` 写在 workspace root（写在子包）
- 不要在子包 AGENTS.md 里写 workspace 级别的规则（那是本文件的事）
- 不要跳过 root 的 verification 后只跑单个子包的

## Verification
`pnpm install && pnpm -r typecheck && pnpm -r test --changed` — 全过才停。