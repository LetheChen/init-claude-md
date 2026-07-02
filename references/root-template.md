# Root CLAUDE.md / AGENTS.md template

按此骨架填充，总行数 ≤60 行（不含代码块）。**前 ~25 行预留 Session Maintenance Protocol 块**——不要跳过。

```markdown
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

## Core rules (from Karpathy)
1. Think Before Coding — surface assumptions, push back when warranted
2. Simplicity First — minimum code that solves the problem
3. Surgical Changes — touch only what you must
4. Goal-Driven Execution — define success criteria, loop until verified

## Language
- Communication: `<zh | en | bilingual>` (matches user preference)
- Code comments: `<zh | en>`
- Commit messages: `<en | zh>` (Conventional Commits format)
- Rule files: `<zh | en | bilingual>`

## Project conventions
- Package manager: <detected>
- Test: <command>
- Typecheck/Lint: <command>
- 1-3 个项目特定坑

## Workflow
- Branch: <detected or `codex/` / `feat/`>
- Commit: Conventional Commits
- **TODO.md**：每次会话结束时检查根目录 `TODO.md`，按决策表更新

## Verification
Run `<typecheck> && <test> --changed` before stopping. Failures are required reading.

## Things to avoid
- 3-5 条本项目硬性禁止
```

## 硬约束

- 总行数 ≤60 行（不含代码块）
- **不写**目录树、架构概览、模块列表 —— 让 agent 自己 discover
- **不写**不可验证的废话（"write clean code"）
- 每条 "do not" 必须具体且可验证
- `Verification` 命令必须真的能跑（用 `bash -c '<cmd>'` 试一次）
- **Session Maintenance Protocol 块必须在顶部**，不要放底部 —— agent 自上而下读

## 如何填充占位符

1. **Package manager**：看 `package.json` lockfile / `pyproject.toml` / `Cargo.toml` / `go.mod` 等
2. **Test / Typecheck / Lint 命令**：看 `package.json` scripts / `pyproject.toml` `[tool.pytest]` / `Makefile` 目标
3. **项目特定禁止**：读 README 的 "Contributing" 段、`CONTRIBUTING.md`，扫代码里反复出现的 `// FIXME: do not do X` 注释
4. **Language 段**：按 SKILL.md 的 4 字段规则检测（README 前 50 行 vs 用户首条消息语言）

完整 Session Maintenance Protocol 决策表见 `references/session-maintenance-protocol.md`。