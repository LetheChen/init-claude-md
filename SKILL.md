---
name: init-claude-md
description: Generate CLAUDE.md / AGENTS.md + TODO.md for the current project, following the minimal HumanLayer pattern and Karpathy 4 rules. Bakes a Session Maintenance Protocol into the root file so future agents auto-update rules and TODO when they load the file. Use when user mentions CLAUDE.md, AGENTS.md, project rules, init / set up / generate / split / refactor AI coding guidelines, or needs a TODO board. 中文触发词：生成 / 初始化 / 拆细 CLAUDE.md 或 AGENTS.md、补一份 TODO.md、规则文件按目录拆分、规则太多要整理。
---

# 生成 CLAUDE.md / AGENTS.md + TODO.md

为项目生成**项目专属的 AI 编码规则文件**（CLAUDE.md / AGENTS.md）+ 活的 TODO.md 任务清单。

两个核心模式：

- **HumanLayer 极简模式** — 根文件 ≤60 行，不写目录树 / 架构概览 / 不可验证的废话
- **Karpathy 4 条准则** — Think Before Coding / Simplicity First / Surgical Changes / Goal-Driven Execution

关键机制：把 ## Session Maintenance Protocol 块嵌入到根文件顶部，未来的 agent 加载根文件时自动按决策表自检更新 TODO.md 和规则——**软自动**，零依赖（详见末尾「更新机制」）。

## 工作流

### Step 0：平台与目标文件检测

按以下信号判定输出文件名（多个信号取并集）：

| 信号 | 偏好 |
| --- | --- |
| 存在 .claude/ 目录 | Claude Code（写 CLAUDE.md） |
| 存在 .codex/ 目录 | Codex（写 AGENTS.md） |
| 已 commit 的 CLAUDE.md | 保留，写 CLAUDE.md |
| 已 commit 的 AGENTS.md | 保留，写 AGENTS.md |
| 用户显式说  Codex / Claude Code / 两个都要 | 用户说了算 |
| 都检测不到 | **默认双写**（最安全） |

不要在没有信号时强行猜。

### Step 1：项目扫描

并行读取（Codex 用 shell_command，Claude Code 用 Read）：

- **Manifest**：package.json / pyproject.toml / go.mod / Cargo.toml / pom.xml → 语言、框架、scripts
- **README**：前 50 行 → 项目意图 + 主语言
- **现有规则文件**：CLAUDE.md / AGENTS.md（合并策略见 Step 3）
- **现有 TODO.md**（迁移但**不覆盖**）
- **代码风格**：.eslintrc* / biome.json / .prettierrc*
- **任务运行器**：Makefile / justfile / package.json scripts
- **CI**：.github/workflows/
- **Monorepo 检测**：顶层是否含 apps/ packages/ services/ modules/
- **TODO 注释**：扫一次 TODO / FIXME / HACK（为 TODO.md 提供初始项）

**空项目（无代码）→ 停下来问用户**，不要编造。

### Step 2：决定文件布局

`
是否有清晰技术栈？
├── 否 → 问用户，不要生成
└── 是
    │
    是否 monorepo（apps/ packages/ services/ 多个子包）？
    ├── 是 → Layout C
    └── 否
        │
        源代码 < 10 且无 DB / 无 auth？
        ├── 是 → Layout A（仅根文件）
        └── 否 → Layout B（根文件 + 规则目录，默认）
`

- **Layout A** — 仅根文件 CLAUDE.md / AGENTS.md
- **Layout B** — 根文件 + .claude/rules/*.md（默认）
- **Layout C** — Monorepo 根文件 + 每个子包一份规则

### Step 3：合并策略（如目标文件已存在）

| 段 | 处理 |
| --- | --- |
| 缺失段 | 添加并填入检测结果 |
| 段内容是占位符（<...> / 空） | 填充 |
| 段内容是真实文本 | **保留**，不覆盖 |
| Things to avoid 段 | **追加**到末尾，不删现有条目 |
| Verification 命令 | 仅在原命令跑不通时更新；保留用户已写好的命令 |
| Workflow 分支/提交规范 | 保留用户约定，不擅自改成「标准」约定 |
| Session Maintenance Protocol 段 | 重新生成（skill 自身维护的，不属于用户手写） |
| Language 段 | 重新生成（4 字段必填） |

**反例**：不要因为「检测到 package manager 是 npm」就覆盖用户写的「我们用 pnpm」。

### Step 4：生成根文件（CLAUDE.md / AGENTS.md）

按 \references/root-template.md 模板填充。要点：

- **顶部**插入「会话维护协议」块（见 Step 7）—— 这是本 skill 的核心交付
- 60 行硬上限
- 4 个 Karpathy 准则压缩到 1-2 行
- ## Language 4 字段必填
- 末尾给一条**真实可跑**的 verification 命令
- 不写目录树、不写架构概览

### Step 5：生成 TODO.md

按 examples/TODO.md 骨架填 4 段：

- 🔴 进行中（≤3 项）
- 🟡 待处理（带 P1/P2 优先级 + 源链接）
- 🟢 后续（低优先级）
- ✅ 已完成（初始化时为空）

填充来源（来自 Step 1 扫描）：

- 注释里的 TODO / FIXME / HACK → 🟡
- 缺少测试的源文件 → 🟢
- 硬编码值 / 魔数 → 🟢
- 顶层目录里 README 提到的「待办」/「TODO」→ 🟡
- 没扫到 → **留空，不编造**（这是核心原则）

### Step 6：生成 .claude/rules/*.md（仅 Layout B / C）

按 \references/rule-file-template.md 模板。每个文件：

- paths: frontmatter 决定何时加载
- 30-80 行
- 单个关注点
- 最多 200 行
- 命名：lowercase-hyphen，api-conventions.md 而非 \rules.md

### Step 7：会话维护协议（核心新机制）

每个生成的根文件顶部必须嵌入「会话维护协议」段（短版，写在根文件里），完整决策表在 \references/session-maintenance-protocol.md（长版，被规则文件引用）。

短版固定模板（中文版；英文版见 \references/session-maintenance-protocol.md 末尾）：

`markdown
## Session Maintenance Protocol

**开始时**：读 TODO.md，复述当前 🔴 和 🟡 段，确认本次会话要推进哪几项。

**结束前**（最后一条用户消息之后、停止前必做）：

1. **回看本次会话实际做了什么** —— 改动的文件、发现的问题、用户新增的约束
2. **更新 TODO.md**（决策表见 \references/session-maintenance-protocol.md）：
   - 完成了某项 → 移到 ✅ 段，加 (YYYY-MM-DD)
   - 新发现的问题 → 加到 🟡（P1/P2）或 🟢（P3+），附源链接
   - 放弃某项 → 移到 ✅ 段，备注 已放弃：<原因>
3. **更新本文件的规则** —— 如果本次会话暴露了新的项目级约定：
   - 用户反复纠正的行为 → 加到 Things to avoid 段
   - 反复跑错的命令 → 更新 Verification 段
   - 隐含约定 → 加到 Project conventions 段
4. **刷新日期戳** > 最后更新：YYYY-MM-DD（即使其他都没变）

**触发条件**（满足任一即必须更新 TODO.md）：≥1 个源文件被改 · 用户新增了约束 · 会话 > 10 分钟
`

### Step 8：自检清单

声明完成前必跑：

- [ ] 根文件 ≤60 行（不含代码块）
- [ ] 根文件无目录树、无架构概览
- [ ] 根文件**顶部**带「会话维护协议」段
- [ ] TODO.md 4 段都有（即使空也留骨架）
- [ ] 所有 rule 文件有 paths: frontmatter
- [ ] 没有任何 rule 文件 >200 行
- [ ] ## Language 4 字段全填
- [ ] Verification 命令真的能跑（用 bash -c 试一次）
- [ ] 没复制粘贴无用的框架默认
- [ ] **本仓库自己的 AGENTS.md / CLAUDE.md 也满足以上全部**（self-dogfooding）

### Step 9：给用户回执

`
Created:
- AGENTS.md (XX 行) — 满足 60 行硬上限，带会话维护协议头
- CLAUDE.md (XX 行) — 同上
- TODO.md — 4 段骨架
- .claude/rules/api-conventions.md
- ...

Next:
1. 打开每个文件，确认推断的规则和你的团队实际一致
2. 手动跑一次 verification 命令，确认能跑通
3. 提交。观察下一轮 AI 会话——任何被忽略的规则都要重写
4. 根文件接近 200 行时，再次触发本 skill 拆分
5. 第一次编码会话后回看本文件 —— 会话维护协议第 3 步会要求 agent 自己加新规则
`

## 参考资料

| 文件 | 用途 |
| --- | --- |
| \references/root-template.md | 根文件骨架（已带会话维护协议头） |
| \references/rule-file-template.md | 单个 rule 文件骨架 |
| \references/content-rules.md | 内容取舍规则（放什么、不放什么） |
| \references/rules-splitter.md | Layout A/B/C 决策树 + 检测矩阵 |
| \references/karpathy-rules.md | Karpathy 4 条准则原文 |
| \references/session-maintenance-protocol.md | **会话维护决策表（必读）** |
| \references/install.md | 安装到 ~/.codex/skills/ / ~/.claude/skills/ 的步骤 |
| \references/quick-start.md | 5 分钟上手（生成 → 检查 → 提交 → 维护） |
| examples/TODO.md | 完整 TODO.md 范例 |
| examples/humanlayer-CLAUDE.md | HumanLayer 模式范例 |
| examples/karpathy-CLAUDE.md | 纯 Karpathy 模式范例 |
| examples/monorepo-root-CLAUDE.md | Monorepo workspace 根（Layout C） |
| examples/monorepo-package-AGENTS.md | Monorepo 子包（带 paths: frontmatter） |
| examples/api-conventions.md | 单个 rule 文件范例 |

## 更新机制

本 skill 不带 hook / cron / 外部触发器。## Session Maintenance Protocol 块嵌入在生成的根文件（CLAUDE.md / AGENTS.md）**顶部**，agent 每次新会话自动加载根文件，看到协议块就按决策表更新 TODO.md。

**这是软自动**：依赖 agent 自觉执行。优点是跨所有 agent、零依赖；代价是上下文太挤或任务急时可能跳过。决策表本身（\references/session-maintenance-protocol.md）是 single source of truth，根文件短版必须与之锁步。