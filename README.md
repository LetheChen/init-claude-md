# init-claude-md

为项目生成**项目专属的 CLAUDE.md / AGENTS.md** + 活的 **TODO.md** 任务清单，让 Claude Code / Codex 真正读完并执行。遵循两个实战验证的模式：

1. **HumanLayer 极简模式** — 根文件 ≤60 行，不写目录树 / 架构概览 / 不可验证的废话。详细约定按关注点拆分到 .claude/rules/，通过 paths: frontmatter 做路径范围懒加载。
2. **Karpathy 4 条准则** — 行为约束而非代码约束，从源头减少 LLM 编码失误：先想再写、极简优先、手术级修改、目标驱动执行。

核心机制：**Session Maintenance Protocol**——在生成的根文件顶部嵌入 会话维护协议块。下一次会话的 agent 读到根文件，就自动知道在结束前回看本次实际做了什么、更新 TODO.md 和规则文件本身。**不需要任何外部 hook**。

Works on both Codex (OpenAI) and Claude Code (Anthropic).

## 快速开始

在项目根目录触发：

```text
init CLAUDE.md
生成 CLAUDE.md
set up Claude Code rules for this project
```

技能会自动：

- 检测技术栈（package.json / pyproject.toml / go.mod ...）
- 检测平台（Codex / Claude Code / 双写）
- 选择 **Layout A**（单文件） / **B**（根+规则目录，默认） / **C**（monorepo）
- 生成根 CLAUDE.md / AGENTS.md + 顶部带 Session Maintenance Protocol 块
- 按 examples/TODO.md 骨架生成 TODO.md
- 如果已有 CLAUDE.md / AGENTS.md / TODO.md，**按合并策略**处理（不覆盖用户真实文本）

## 安装

### Codex (OpenAI)

```text
codex skill install init-claude-md
```

### Claude Code (Anthropic)

```text
git clone https://github.com/LetheChen/init-claude-md ~/.agents/skills/init-claude-md
```

详细步骤见 [references/install.md](references/install.md)。

## 生成的 CLAUDE.md 长什么样

完整示例见 [examples/](examples/)：

````markdown
# CLAUDE.md

## Session Maintenance Protocol

**开始时**：读 TODO.md，复述当前 🔴 和 🟡 段，确认本次会话要推进哪几项。

**结束前**（最后一条用户消息之后、停止前必做）：
1. 回看本次会话实际做了什么
2. 更新 TODO.md（决策表见 [references/session-maintenance-protocol.md](references/session-maintenance-protocol.md)）
3. 更新本文件的规则（如果本次暴露了新约定）
4. 刷新日期戳

**触发条件**：≥1 个源文件被改 · 用户新增了约束 · 会话 > 10 分钟

## Core rules (from Karpathy)
1. Think Before Coding — surface assumptions, push back when warranted
2. Simplicity First — minimum code that solves the problem
3. Surgical Changes — touch only what you must
4. Goal-Driven Execution — define success criteria, loop until verified

## Language
- Communication: zh（用户偏好）
- Code comments: zh
- Commit messages: en（Conventional Commits）
- Rule files: zh

## Project conventions
- All database access goes through /src/db/queries/
- Use pnpm run typecheck after every change
- Never modify migration files after commit

## Verification
Run pnpm run typecheck && pnpm test --changed before stopping.

## Things to avoid
- Do not add dependencies without justification
- Do not refactor unrelated code in a fix
- Do not commit secrets or .env files
````

Rule file — 只在 Agent 触及匹配路径时加载：

````markdown
---
paths:
  - src/db/**
  - prisma/**
---

# Database conventions

## Rules
- Always use prisma. for multi-statement operations
- Migration files are immutable after commit
- Seed data must be idempotent
````

## 生成的 TODO.md 长什么样

````markdown
# 待办清单

> 最后更新：2026-07-03

## 🔴 进行中
- [ ] (P1) 实现用户头像上传到 S3 的预签名 URL 流程  源:src/api/users/upload.ts:42

## 🟡 待处理
- [ ] (P1) 修复登录页在 Safari 17 下的样式错位
- [ ] (P2) 替换 src/legacy/db.js 里所有 var 为 const/let

## 🟢 后续
- [ ] 升级 Next.js 14 → 15

## ✅ 已完成
- [x] 初始化项目 CLAUDE.md + TODO.md (2026-07-03)
````

完整范例见 [examples/TODO.md](examples/TODO.md)。

## 目录结构

```text
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
│   └── quick-start.md                      # 5 分钟上手指南
├── examples/
│   ├── humanlayer-CLAUDE.md                # HumanLayer 模式范例（带协议头）
│   ├── karpathy-CLAUDE.md                  # 纯 Karpathy 模式范例（带协议头 + Language 段）
│   ├── monorepo-root-CLAUDE.md             # Layout C: workspace 根
│   ├── monorepo-package-AGENTS.md          # Layout C: 子包（带 paths: frontmatter）
│   ├── api-conventions.md                  # 单个 rule 文件范例（带 paths: + good/bad 示例）
│   └── TODO.md                             # 完整 TODO.md 范例
├── README.md
├── CONTRIBUTING.md
├── .gitignore
├── LICENSE
└── .github/
    ├── ISSUE_TEMPLATE/
    │   ├── bug_report.md
    │   ├── feature_request.md
    │   └── config.yml
    └── PULL_REQUEST_TEMPLATE.md
```

## 跨平台兼容

| 操作 | Claude Code | Codex |
| --- | --- | --- |
| 文件扫描 | Glob, Grep, Read | shell_command (rg, ls) |
| 读取文件 | Read | shell_command (cat) |
| 写入文件 | Write, Edit | apply_patch |
| 平台判断 | .claude/ 目录存在 | .codex/ 目录存在 |
| 默认行为 | 写 CLAUDE.md | 写 AGENTS.md |

SKILL.md 使用意图驱动的描述（find and read these files），两个平台的 Agent 都能用自己的工具执行。**不绑定任何一方的工具名**。

**默认双写**：当两个平台信号都没检测到时，skill 会同时写 CLAUDE.md 和 AGENTS.md（同样内容），最安全。

## License

MIT — use it, fork it, ship it. Attribution appreciated but not required.

## Contributing

欢迎提交 Issue 和 PR。详见 [CONTRIBUTING.md](CONTRIBUTING.md)。