# init-claude-md

<p align="center">
  <b>中文</b> | <a href="#english">English</a>
</p>

Generate a project-specific **CLAUDE.md** file (and `.claude/rules/` directory) that Claude Code actually reads and acts on — combining the **HumanLayer minimal pattern** with **Karpathy's 4 behavioral rules**.

Works on both **Codex (OpenAI)** and **Claude Code (Anthropic)**.

---

## 是什么

`init-claude-md` 是一个 AI 编码技能（Skill），用于自动生成项目专属的 **CLAUDE.md** 文件和 **.claude/rules/** 规则目录。

大多数 CLAUDE.md 写得像架构文档，几百行，Agent 根本不读。这个技能生成的规则文件遵循两个经过实战验证的模式：

1. **HumanLayer 极简模式** — 根文件控制在 60 行以内，不写目录树、不写架构概览、不写通用废话。详细约定按关注点拆分到 `.claude/rules/`，通过 `paths:` 冒头做路径范围懒加载。
2. **Karpathy 4 条准则** — 行为约束而非代码约束，从源头减少 LLM 编码失误：先想再写、极简优先、手术级修改、目标驱动执行。

### 核心设计原则

- **3 AM 测试** — 凌晨 3 点被叫醒的开发者，看这条规则能不能不思考就直接执行？不能就重写。
- **可验证性测试** — 机器能检查吗？Reviewer 能在 5 秒内验证吗？都不行就删掉。
- **只说不该做什么** — 让 Agent 自己去发现代码结构，只在容易踩坑的地方设路障。

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
- 根据项目规模选择 Layout A（单文件）/ B（根+规则目录）/ C（monorepo）
- 生成 root CLAUDE.md + 按关注点拆分的 `.claude/rules/*.md`
- 如果已有 CLAUDE.md，**合并**而非覆盖

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

```
# CLAUDE.md

Minimal, high-signal project rules. Keep this file under 60 lines.
Detailed conventions live in `.claude/rules/` and load on-demand.

## Project conventions
- All database access goes through /src/db/queries/
- Use `pnpm run typecheck` after every change
- Never modify committed migration files

## Verification
Run `pnpm run typecheck && pnpm test --changed` before stopping.
Failures are required reading.

## Things to avoid
- Do not add dependencies without justification
- Do not refactor unrelated code in a fix
```

Rule file — 只在 Agent 触及匹配路径时加载：

```
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

## 目录结构

```
init-claude-md/
├── SKILL.md                       # 技能入口 — Agent 工作流指令
├── references/
│   ├── root-template.md           # 根 CLAUDE.md 骨架模板
│   ├── rule-file-template.md      # 每条规则文件的骨架 + paths: 说明
│   ├── content-rules.md           # 内容取舍规则（放什么、不放什么）
│   ├── rules-splitter.md          # 何时拆分、如何拆分的决策树 + 检测矩阵
│   └── karpathy-rules.md          # Karpathy 4 条准则原文
├── examples/
│   ├── humanlayer-CLAUDE.md       # 生成输出示例（HumanLayer 模式）
│   └── karpathy-CLAUDE.md         # 生成输出示例（纯 Karpathy 规则）
├── README.md
└── LICENSE
```

---

## 跨平台兼容

| 操作 | Claude Code | Codex |
|------|-------------|-------|
| 文件扫描 | Glob, Grep, Read | `shell_command` (rg, ls) |
| 读取文件 | Read | `shell_command` (cat) |
| 写入文件 | Write, Edit | `apply_patch` |

SKILL.md 使用意图驱动的描述（"find and read these files"），两个平台的 Agent 都能用自己的工具执行。不绑定任何一方的工具名。

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

**有效的 CLAUDE.md 只做一件事：告诉 Agent 这个项目有什么坑，以及踩进去的后果。**

---

## 贡献

这个技能本身也是用 CLAUDE.md 管理的（吃自己的狗粮）。如果你有改进建议：

1. Fork
2. 修改 SKILL.md 或 references/
3. 用 `init-claude-md` 重新生成自己的 CLAUDE.md，验证效果
4. 提 PR

规则文件本身是 Markdown，由人类拥有和编辑。技能只负责初始化，后续维护你来控。

---

## 致谢

- **Andrej Karpathy** — [4 core rules](https://github.com/forrestchang/andrej-karpathy-skills) for LLM coding agents
- **HumanLayer** — minimal, high-signal CLAUDE.md pattern

---

## License

MIT

---

# init-claude-md

<p align="center">
  <a href="#中文">中文</a> | <b>English</b>
</p>

Generate a project-specific **CLAUDE.md** file (and `.claude/rules/` directory) that Claude Code actually reads and acts on — combining the **HumanLayer minimal pattern** with **Karpathy's 4 behavioral rules**.

Works on both **Codex (OpenAI)** and **Claude Code (Anthropic)**.

---

## What it does

`init-claude-md` is an AI coding skill that automatically generates a project-tailored CLAUDE.md and `.claude/rules/` directory. Most CLAUDE.md files read like architecture docs — 300 lines of information the agent already knows or ignores. This skill generates files the agent *actually* reads, combining two battle-tested patterns:

1. **HumanLayer minimal pattern** — root file under 60 lines (80 hard limit). No directory trees, no architecture overviews, no generic advice. Detailed conventions are split into `.claude/rules/` markdown files that load on-demand via `paths:` frontmatter globs.
2. **Karpathy 4 rules** — behavioral guardrails that prevent the most common LLM coding mistakes: Think Before Coding, Simplicity First, Surgical Changes, and Goal-Driven Execution.

### Core design principles

- **3 AM test** — can a tired developer read this rule and act on it without thinking?
- **Specificity test** — can a machine check it? Can a reviewer verify it in 5 seconds? If neither, throw it out.
- **Negatives only** — say what NOT to do. Let the agent discover the codebase. Only encode the footguns.

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
- Selects **Layout A** (single file), **B** (root + rules directory), or **C** (monorepo)
- Generates a root CLAUDE.md + scoped `.claude/rules/*.md` files
- Merges with existing CLAUDE.md if one exists — never overwrites

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

## Generated output

**Root CLAUDE.md** ([full example](examples/humanlayer-CLAUDE.md)):

```
# CLAUDE.md

Minimal, high-signal project rules. Keep this file under 60 lines.

## Project conventions
- Database: `/src/db/queries/`, never raw SQL
- Typecheck: `pnpm run typecheck` after every change
- Migrations: immutable after commit

## Verification
Run `pnpm run typecheck && pnpm test --changed`.

## Things to avoid
- Do not add dependencies without justification
- Do not refactor unrelated code in a fix
- Do not commit secrets or `.env` files
```

**Rule file** — loads only when agent touches matching paths:

```
---
paths:
  - "src/db/**"
  - "prisma/**"
---

# Database conventions

## Rules
- Always use `prisma.$transaction` for multi-statement ops
- Migration files are immutable — create new ones, don't edit
- Seed data must be idempotent
```

See [`examples/`](examples/) for complete output examples.

---

## Directory structure

```
init-claude-md/
├── SKILL.md                       # Entry point — agent workflow instructions
├── references/
│   ├── root-template.md           # Root CLAUDE.md skeleton
│   ├── rule-file-template.md      # Per-concern rule file skeleton + paths: docs
│   ├── content-rules.md           # What belongs in CLAUDE.md and what doesn't
│   ├── rules-splitter.md          # Decision tree: when to split, detection matrix
│   └── karpathy-rules.md          # Karpathy's 4 behavioral rules verbatim
├── examples/
│   ├── humanlayer-CLAUDE.md       # Generated output example (HumanLayer pattern)
│   └── karpathy-CLAUDE.md         # Generated output example (pure Karpathy rules)
├── README.md
└── LICENSE
```

---

## Platform compatibility

| Operation | Claude Code | Codex |
|-----------|-------------|-------|
| File scanning | Glob, Grep, Read | `shell_command` (rg, ls) |
| File reading | Read | `shell_command` (cat) |
| File writing | Write, Edit | `apply_patch` |

The SKILL.md instructions are **intent-driven** ("find and read these files"), not tool-driven. Both agents translate the same intent into their native toolset.

---

## Philosophy: why most CLAUDE.md files fail

Agents don't read CLAUDE.md like humans:

| Human reads... | Agent reads... |
|---|---|
| Directory tree, module list | Ignores — can discover in 3 seconds |
| "This is a TypeScript project" | Already detected from `package.json` |
| "Follow best practices" | Untestable, ignored every time |
| Architecture overview (300 lines) | Only the first 50 lines register |

**Effective CLAUDE.md does exactly one thing: tells the agent where the traps are, and what happens if it steps in one.**

---

## Contributing

This skill eats its own dog food — it's managed with a CLAUDE.md generated by itself.

1. Fork the repo
2. Edit SKILL.md or references/
3. Run `init-claude-md` on this repo to validate your changes
4. Submit a PR

Rules are markdown, owned by humans. The skill only handles initialization — you own maintenance.

---

## Credits

- **Andrej Karpathy** — [4 core rules](https://github.com/forrestchang/andrej-karpathy-skills) for LLM coding agents
- **HumanLayer** — minimal, high-signal CLAUDE.md pattern

---

## License

MIT — use it, fork it, ship it. Attribution appreciated but not required.
