# init-claude-md

<p align="center">
  <b>中文</b> | <a href="#english">English</a>
</p>

Generate a project-specific **CLAUDE.md** / **AGENTS.md** file plus a living **TODO.md** task board that Claude Code / Codex actually reads and acts on — combining the **HumanLayer minimal pattern** with **Karpathy''s 4 behavioral rules** and a **Session Maintenance Protocol** baked into the generated file.

Works on both **Codex (OpenAI)** and **Claude Code (Anthropic)**.

---

## 是什么

`init-claude-md` 是一个 AI 编码技能（Skill），用于自动生成项目专属的 **CLAUDE.md** / **AGENTS.md** 文件和 **`TODO.md` 任务清单**。

大多数 CLAUDE.md 写得像架构文档，几百行，Agent 根本不读。这个技能生成的规则文件遵循三个经过实战验证的模式：

1. **HumanLayer 极简模式** — 根文件控制在 60 行以内，不写目录树、不写架构概览、不写通用废话。详细约定按关注点拆分到 `.claude/rules/`，通过 `paths:` 冒头做路径范围懒加载。
2. **Karpathy 4 条准则** — 行为约束而非代码约束，从源头减少 LLM 编码失误：先想再写、极简优先、手术级修改、目标驱动执行。
3. **Session Maintenance Protocol（核心新机制）** — 在生成的根文件顶部嵌入"会话维护协议"块。下一次会话的 agent 读到根文件，就自动知道在结束前回看本次实际做了什么、更新 `TODO.md` 和规则文件本身。**不需要任何外部 hook**。

### 核心设计原则

- **3 AM 测试** — 凌晨 3 点被叫醒的开发者，看这条规则能不能不思考就直接执行？不能就重写。
- **可验证性测试** — 机器能检查吗？Reviewer 能在 5 秒内验证吗？都不行就删掉。
- **只说不该做什么** — 让 Agent 自己去发现代码结构，只在容易踩坑的地方设路障。
- **生成的规则自己驱动维护** — 不要依赖外部 cron / hook，让生成的 CLAUDE.md / AGENTS.md 顶部那段短协议成为"会话结束的强制清单"。

---

## 快速开始

在你的项目根目录触发：

```
init CLAUDE.md
生成 CLAUDE.md
set up Claude Code rules for this project
```

技能会自动：

- 检测技术栈（package.json / pyproject.toml / go.mod ...）
- 检测平台（Codex / Claude Code / 双写）
- 选择 **Layout A**（单文件） / **B**（根+规则目录，默认） / **C**（monorepo）
- 生成 root CLAUDE.md / AGENTS.md + 顶部带 Session Maintenance Protocol 块
- 按 `examples/TODO.md` 骨架生成 TODO.md 任务清单
- 如果已有 CLAUDE.md / AGENTS.md / TODO.md，**按合并策略**处理（不覆盖用户真实文本）

---

## 安装

### Codex（OpenAI）

从 Codex 技能市场安装，或本地安装：

```bash
codex skill install init-claude-md
```

### Claude Code（Anthropic）

```bash
# 克隆到 skills 目录
git clone https://github.com/<your-username>/init-claude-md ~/.agents/skills/init-claude-md
```

---

## 生成的 CLAUDE.md 长什么样

Root CLAUDE.md（完整示例见 [`examples/`](examples/)）：

```markdown
# CLAUDE.md

## Session Maintenance Protocol

**开始时**：读 `TODO.md`，复述当前 🔴 和 🟡 段，确认本次会话要推进哪几项。

**结束前**（最后一条用户消息之后、停止前必做）：
1. 回看本次会话实际做了什么
2. 更新 `TODO.md`（决策表见 `references/session-maintenance-protocol.md`）
3. 更新本文件的规则（如果本次暴露了新约定）
4. 刷新日期戳

**触发条件**：≥1 个源文件被改 · 用户新增了约束 · 会话 > 10 分钟

## Core rules (from Karpathy)
1. Think Before Coding — surface assumptions, push back when warranted
2. Simplicity First — minimum code that solves the problem
3. Surgical Changes — touch only what you must
4. Goal-Driven Execution — define success criteria, loop until verified

## Language
- Communication: `zh`（用户偏好）
- Code comments: `zh`
- Commit messages: `en`（Conventional Commits）
- Rule files: `zh`

## Project conventions
- All database access goes through /src/db/queries/
- Use `pnpm run typecheck` after every change
- Never modify migration files after commit

## Verification
Run `pnpm run typecheck && pnpm test --changed` before stopping.

## Things to avoid
- Do not add dependencies without justification
- Do not refactor unrelated code in a fix
- Do not commit secrets or `.env` files
```

Rule file — 只在 Agent 触及匹配路径时加载：

```markdown
---
paths:
  - "src/db/**"
  - "prisma/**"
---

# Database conventions

## Rules
- Always use `prisma.$transaction` for multi-statement operations
- Migration files are immutable after commit
- Seed data must be idempotent
```

---

## TODO.md 长什么样

```markdown
# 待办清单

> 最后更新：2026-07-02

## 🔴 进行中
- [ ] (P1) 实现用户头像上传到 S3 的预签名 URL 流程  源:src/api/users/upload.ts:42

## 🟡 待处理
- [ ] (P1) 修复登录页在 Safari 17 下的样式错位
- [ ] (P2) 替换 `src/legacy/db.js` 里所有 `var` 为 `const`/`let`

## 🟢 后续
- [ ] 升级 Next.js 14 → 15

## ✅ 已完成
- [x] 初始化项目 CLAUDE.md + TODO.md (2026-07-02)
```

完整范例见 [`examples/TODO.md`](examples/TODO.md)。

---

## 目录结构

```
init-claude-md/
├── SKILL.md                                # 技能入口 — Agent 工作流指令（中文主体）
├── AGENTS.md                               # 本仓库自己的 Codex 规则文件（self-dogfooding 范例）
├── CLAUDE.md                               # 本仓库自己的 Claude Code 规则文件
├── TODO.md                                 # 本仓库自己的任务清单
├── references/
│   ├── root-template.md                    # 根 CLAUDE.md 骨架（含 Session Maintenance Protocol 头）
│   ├── rule-file-template.md               # 每个 rule 文件的骨架 + paths: 说明
│   ├── content-rules.md                    # 内容取舍规则（放什么、不放什么）
│   ├── rules-splitter.md                   # Layout A/B/C 决策树 + 检测矩阵
│   ├── karpathy-rules.md                   # Karpathy 4 条准则原文
│   ├── session-maintenance-protocol.md     # **会话维护决策表（核心新机制）**
│   ├── install.md                          # 安装到 ~/.codex/skills/ 的步骤
│   ├── quick-start.md                      # 5 分钟上手指南
├── examples/
│   ├── humanlayer-CLAUDE.md                # HumanLayer 模式范例（带协议头）
│   ├── karpathy-CLAUDE.md                  # 纯 Karpathy 模式范例（带协议头 + Language 段）
│   ├── monorepo-root-CLAUDE.md             # Layout C: workspace 根
│   ├── monorepo-package-AGENTS.md          # Layout C: 子包（带 paths: frontmatter）
│   ├── api-conventions.md                  # 单个 rule 文件范例（带 paths: + good/bad 示例）
│   └── TODO.md                             # 完整 TODO.md 范例
├── README.md
├── .gitignore
└── LICENSE
```

---
## 跨平台兼容

| 操作 | Claude Code | Codex |
|------|-------------|-------|
| 文件扫描 | Glob, Grep, Read | `shell_command` (rg, ls) |
| 读取文件 | Read | `shell_command` (cat) |
| 写入文件 | Write, Edit | `apply_patch` |
| 平台判断 | `.claude/` 目录存在 | `.codex/` 目录存在 |
| 默认行为 | 写 `CLAUDE.md` | 写 `AGENTS.md` |

SKILL.md 使用意图驱动的描述（"find and read these files"），两个平台的 Agent 都能用自己的工具执行。**不绑定任何一方的工具名**。

**默认双写**：当两个平台信号都没检测到时，skill 会同时写 `CLAUDE.md` 和 `AGENTS.md`（同样内容），最安全。

---

## 哲学：为什么大多数 CLAUDE.md 是废的

Agent 读 CLAUDE.md 时的行为和人类完全不同：

- **人类** 会扫目录树、理解架构、脑补上下文
- **Agent** 只看规则，然后立刻动手写代码

所以：

- 写 "This is a TypeScript monorepo with Next.js and Prisma" → Agent 3 秒就能从 `package.json` 看出来，白写
- 写 "Follow best practices" → 不可验证，Agent 忽略
- 写 "Write clean code" → 同上
- 写 300 行的架构文档 → Agent 只看前 50 行，后面的无视
- 写完后从不更新 → 项目演化、规则过时、Agent 继续犯同样的错

**有效的 CLAUDE.md 只做两件事：**

1. 告诉 Agent 这个项目有什么坑，以及踩进去的后果
2. 告诉 Agent 怎么在每次会话结束后自动维护规则和 TODO（这就是 Session Maintenance Protocol）

---

## 贡献

这个技能本身也是用 CLAUDE.md / AGENTS.md 管理的（吃自己的狗粮）。`AGENTS.md` / `CLAUDE.md` / `TODO.md` 三件套就是本仓库的真实产出。

如果你有改进建议：

1. Fork
2. 修改 SKILL.md 或 references/
3. 跑一遍 `init-claude-md`（在自己的 fork 上）验证效果
4. 提 PR

规则文件本身是 Markdown，由人类拥有和编辑。skill 只负责初始化 + 提供 Session Maintenance Protocol 决策表，后续维护由 agent 持续驱动。

---

## 致谢

- **Andrej Karpathy** — [4 core rules](https://github.com/forrestchang/andrej-karpathy-skills) for LLM coding agents
- **HumanLayer** — minimal, high-signal CLAUDE.md pattern

---

## License

MIT — use it, fork it, ship it. Attribution appreciated but not required.

---

# init-claude-md

<p align="center">
  <a href="#中文">中文</a> | <b>English</b>
</p>

Generate a project-specific **CLAUDE.md** / **AGENTS.md** file plus a living **TODO.md** task board that Claude Code / Codex actually reads and acts on — combining the **HumanLayer minimal pattern** with **Karpathy''s 4 behavioral rules** and a **Session Maintenance Protocol** baked into the generated file.

Works on both **Codex (OpenAI)** and **Claude Code (Anthropic)**.

---

## What it does

`init-claude-md` is an AI coding skill that automatically generates a project-tailored CLAUDE.md / AGENTS.md, a `.claude/rules/` directory, and a TODO.md task board. Most rule files read like architecture docs — 300 lines the agent already knows or ignores. This skill generates files the agent *actually* reads and keeps up to date, combining three battle-tested patterns:

1. **HumanLayer minimal pattern** — root file under 60 lines (80 hard limit). No directory trees, no architecture overviews, no generic advice. Detailed conventions are split into `.claude/rules/` markdown files that load on-demand via `paths:` frontmatter globs.
2. **Karpathy 4 rules** — behavioral guardrails that prevent the most common LLM coding mistakes: Think Before Coding, Simplicity First, Surgical Changes, and Goal-Driven Execution.
3. **Session Maintenance Protocol (new core mechanism)** — a short block baked into the top of every generated root file. The next session''s agent reads it and knows: at session end, review what actually changed, update `TODO.md`, and update this file''s rules if the session revealed new conventions. **No external hook required.**

### Core design principles

- **3 AM test** — can a tired developer read this rule and act on it without thinking?
- **Specificity test** — can a machine check it? Can a reviewer verify it in 5 seconds? If neither, throw it out.
- **Negatives only** — say what NOT to do. Let the agent discover the codebase. Only encode the footguns.
- **The rule file drives its own maintenance** — no cron, no hook, no human reminder. The protocol at the top of the generated file is the trigger.

---

## Quick start

From any project root:

```
init CLAUDE.md
set up Claude Code rules
生成 CLAUDE.md
```

The skill automatically:

- Detects your tech stack (`package.json`, `pyproject.toml`, `go.mod`, etc.)
- Detects your platform (Codex / Claude Code / both — defaults to both)
- Selects **Layout A** (single file), **B** (root + rules directory, default), or **C** (monorepo)
- Generates a root CLAUDE.md / AGENTS.md with the Session Maintenance Protocol block at the top
- Generates TODO.md with 4 segments (in progress / todo / backlog / done)
- Merges with existing CLAUDE.md / AGENTS.md / TODO.md per merge strategy (never overwrites user-written text)

---

## Installation

### Codex (OpenAI)

```bash
codex skill install init-claude-md
```

### Claude Code (Anthropic)

```bash
git clone https://github.com/<your-username>/init-claude-md ~/.agents/skills/init-claude-md
```

---

## What the generated CLAUDE.md looks like

**Root CLAUDE.md** ([full example](examples/humanlayer-CLAUDE.md)):

```markdown
# CLAUDE.md

## Session Maintenance Protocol
...

## Core rules (from Karpathy)
1. Think Before Coding — surface assumptions, push back when warranted
...

## Language
- Communication: `zh`（用户偏好）
- Code comments: `zh`
- Commit messages: `en`
- Rule files: `zh`

## Project conventions
- All database access goes through /src/db/queries/
- Use `pnpm run typecheck` after every change

## Verification
Run `pnpm run typecheck && pnpm test --changed` before stopping.

## Things to avoid
- Do not add dependencies without justification
- Do not refactor unrelated code in a fix
- Do not commit secrets or `.env` files
```

**Rule file** — loads only when the agent touches matching paths:

```markdown
---
paths:
  - "src/db/**"
  - "prisma/**"
---

# Database conventions

## Rules
- Always use `prisma.$transaction` for multi-statement operations
- Migration files are immutable after commit
- Seed data must be idempotent
```

See [`examples/`](examples/) for complete output examples, including TODO.md and Layout C (monorepo).

---

## Directory structure

```
init-claude-md/
├── SKILL.md                                # skill entry -- agent workflow (Chinese body)
├── AGENTS.md                               # this repo's Codex rule file (self-dogfood)
├── CLAUDE.md                               # this repo's Claude Code rule file
├── TODO.md                                 # this repo's task board
├── references/
│   ├── root-template.md                    # root CLAUDE.md skeleton (with protocol header)
│   ├── rule-file-template.md               # per-rule-file skeleton + paths: docs
│   ├── content-rules.md                    # content curation rules (in/out)
│   ├── rules-splitter.md                   # Layout A/B/C decision tree + detection matrix
│   ├── karpathy-rules.md                   # Karpathy 4 rules verbatim
│   ├── session-maintenance-protocol.md     # **session maintenance decision table (core)**
│   ├── install.md                          # install to ~/.codex/skills/
│   ├── quick-start.md                      # 5-minute onboarding
├── examples/
│   ├── humanlayer-CLAUDE.md                # HumanLayer pattern (with protocol header)
│   ├── karpathy-CLAUDE.md                  # pure Karpathy pattern (with protocol + Language)
│   ├── monorepo-root-CLAUDE.md             # Layout C: workspace root
│   ├── monorepo-package-AGENTS.md          # Layout C: sub-package (with paths: frontmatter)
│   ├── api-conventions.md                  # rule file example (paths: + good/bad)
│   └── TODO.md                             # complete TODO.md example
├── README.md
├── .gitignore
└── LICENSE
```

---
## Platform compatibility

| Operation | Claude Code | Codex |
|-----------|-------------|-------|
| File scanning | Glob, Grep, Read | `shell_command` (rg, ls) |
| File reading | Read | `shell_command` (cat) |
| File writing | Write, Edit | `apply_patch` |
| Platform detect | `.claude/` exists | `.codex/` exists |
| Default output | `CLAUDE.md` | `AGENTS.md` |

The SKILL.md instructions are **intent-driven** ("find and read these files"), not tool-driven. Both agents translate the same intent into their native toolset.

**Default behavior**: if no platform signal is detected, the skill writes both `CLAUDE.md` and `AGENTS.md` (same content). This is the safest default for projects used by both.

---

## Philosophy: why most CLAUDE.md files fail

Agents don''t read CLAUDE.md like humans:

| Human reads... | Agent reads... |
|---|---|
| Directory tree, module list | Ignores — can discover in 3 seconds |
| "This is a TypeScript project" | Already detected from `package.json` |
| "Follow best practices" | Untestable, ignored every time |
| Architecture overview (300 lines) | Only the first 50 lines register |
| Once written, never updated | Grows stale, agent keeps making the same mistakes |

**Effective CLAUDE.md does exactly two things:**

1. Tells the agent where the traps are, and what happens if it steps in one.
2. Tells the agent how to maintain itself (and `TODO.md`) at the end of every session.

---

## Contributing

This skill eats its own dog food — `AGENTS.md`, `CLAUDE.md`, and `TODO.md` in this repo are real outputs of the skill.

1. Fork
2. Edit SKILL.md or references/
3. Run `init-claude-md` on this repo to validate your changes
4. Submit a PR

Rule files are markdown, owned by humans. The skill handles initialization + provides the Session Maintenance Protocol decision table. Long-term maintenance is driven by the protocol block at the top of every generated file.

---

## Credits

- **Andrej Karpathy** — [4 core rules](https://github.com/forrestchang/andrej-karpathy-skills) for LLM coding agents
- **HumanLayer** — minimal, high-signal CLAUDE.md pattern

---

## License

MIT — use it, fork it, ship it. Attribution appreciated but not required.
