# AGENTS.md

## Session Maintenance Protocol

**开始时**：读 `TODO.md`，复述当前 🔴 和 🟡 段；扫 `references/` 是否与 `SKILL.md` 描述一致。

**结束前**（最后一条用户消息之后、停止前必做）：

1. **回看本次会话实际做了什么** —— 改动的文件、发现的问题、用户新增的约束
2. **更新 `TODO.md`**（决策表见 `references/session-maintenance-protocol.md`）
3. **更新本文件的规则** —— 本次会话暴露的新约定加到对应段
4. **刷新日期戳** `> 最后更新：YYYY-MM-DD`

**触发条件**：≥1 个仓库文件被改 · 用户新增约束 · 会话 > 10 分钟

## Core rules (from Karpathy)
1. Think Before Coding — surface assumptions, push back when warranted
2. Simplicity First — minimum code that solves the problem
3. Surgical Changes — touch only what you must
4. Goal-Driven Execution — define success criteria, loop until verified

## Language
- Communication: `zh`（用户偏好）
- Code comments: `zh`
- Commit messages: `en`（Conventional Commits 必须英文）
- Rule files: `zh`

## Project conventions
- 纯 Markdown skill：没有代码 / 包管理器 / 测试运行器
- 编辑 `SKILL.md` 时必须同步更新 `references/` 和 `examples/`（决策表、模板、检测矩阵三者锁步）
- 所有文件统一用 **UTF-8 no BOM**（PowerShell `Set-Content -Encoding UTF8` 默认带 BOM，禁止用）
- `references/session-maintenance-protocol.md` 是 single source of truth，根文件里的短版必须与之保持一致

## Workflow
- Branch: `codex/<scope>-<slug>`
- Commit: Conventional Commits（`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`）
- PR: GitHub Flow，merge 到 main
- **TODO.md**：每次会话结束时按决策表更新

## Verification
`git diff --stat HEAD` 确认改动符合预期；改 `SKILL.md` 后用 `Get-Content -Encoding UTF8` 检查没有 BOM。

## Things to avoid
- 不要在 skill 主体加 TypeScript / 任何编译型语言
- 不要加 CI 依赖（这个 skill 没必要要求 Node 18+ 才能用）
- 不要改 `SKILL.md` 时漏改 `references/`（决策表 / 模板 / 检测矩阵三者必须锁步）
- 不要写带 BOM 的 UTF-8 文件（PowerShell 默认行为）
- 不要从 `examples/` 删文件而不补 README 的目录树
- 不要把 `description` 字段里的中文触发词写错（之前是 `涓?` 乱码，每个 agent 看到的触发词是错的）
- 不要用 PowerShell Get-Content | Set-Content 改 Markdown（CRLF 会丢成 LF-only、\a \b \v 会被 PS 解释成控制字符）。用 [System.IO.File]::ReadAllBytes/WriteAllBytes 字节级操作
- 不要在 skill 里加 hook / cron / 外部触发器（软自动才是设计核心；外部触发器破坏跨 agent 兼容）
- 不要去掉根文件顶部的 `## Session Maintenance Protocol` 块（agent 失去结束前自检清单）
> 最后更新：2026-07-03
