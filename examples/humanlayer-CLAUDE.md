# CLAUDE.md

## Session Maintenance Protocol

**开始时**：读 `TODO.md`，复述当前 🔴 和 🟡 段，确认本次会话要推进哪几项。

**结束前**（最后一条用户消息之后、停止前必做）：

1. **回看本次会话实际做了什么** —— 改动的文件、发现的问题、用户新增的约束
2. **更新 `TODO.md`**（决策表见 `references/session-maintenance-protocol.md`）：
   - 完成了某项 → 移到 ✅ 段，加 `(YYYY-MM-DD)`
   - 新发现的问题 → 加到 🟡（P1/P2）或 🟢（P3+），附源链接
   - 放弃某项 → 移到 ✅ 段，备注 `已放弃：<原因>`
3. **更新本文件的规则** —— 如果本次会话暴露了新的项目级约定：
   - 用户反复纠正的行为 → 加到 `## Things to avoid` 段
   - 反复跑错的命令 → 更新 `## Verification` 段
   - 隐含约定 → 加到 `## Project conventions` 段
4. **刷新日期戳** `> 最后更新：YYYY-MM-DD`（即使其他都没变）

**触发条件**（满足任一即必须更新 TODO.md）：≥1 个源文件被改 · 用户新增了约束 · 会话 > 10 分钟

## Project conventions
- All database access goes through `/src/db/queries/`, never raw SQL inline.
- Use `pnpm run typecheck` after every change.
- Never modify migration files after they have been committed.

## Linear workflow
- Fetch issues: `linear get-issue ENG-XXXX`
- Update status: `linear update-status ENG-XXXX "in dev"`
- Close finished issues: `linear update-status ENG-XXXX "done"`

## Git workflow
- Branch naming: `eng/<issue-id>-<short-description>` (e.g. `eng-1234-fix-login-redirect`).
- Commit format: `<type>(scope): summary` (e.g. `feat(auth): add session timeout`).
- Always rebase before merge: `git fetch origin && git rebase origin/main`.

## Language
- Communication: `en`
- Code comments: `en`
- Commit messages: `en` (Conventional Commits)
- Rule files: `en`

## Verification
Run `pnpm run typecheck && pnpm test --changed` before stopping. Failures are required reading — do not ignore them.

## Things to avoid
- Do not add dependencies without justification.
- Do not refactor unrelated code in a fix.
- Do not commit secrets, `.env` files, or large binaries.
- Do not skip pre-commit hooks (`--no-verify` is banned).
- Do not export symbols that are not consumed externally.