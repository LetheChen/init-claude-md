---
name: init-claude-md
description: Generate or refactor a project-specific CLAUDE.md (or AGENTS.md) plus a living TODO.md, following the minimal HumanLayer pattern and Karpathy 4 behavioral rules. Use when the user mentions CLAUDE.md, AGENTS.md, Claude Code / Codex project rules, wants to initialize / set up / create / init / generate / split AI coding guidelines, or needs a TODO.md task board. The skill also bakes a Session Maintenance Protocol into the generated file so every future session auto-updates the rules and TODO based on what actually happened. 中文触发词：生成/初始化/写一个 CLAUDE.md 或 AGENTS.md、补一份 TODO.md、规则文件按目录拆分、规则太多要整理、把这份 CLAUDE.md 拆细。
---

# Init CLAUDE.md / AGENTS.md

为新项目或现有项目自动生成**项目专属的 AI 编码规则文件**，并配套生成一份活的 `TODO.md` 任务清单。

遵循两个实战验证的模式：

1. **HumanLayer 极简模式** — 根文件 ≤60 行，不写目录树、不写架构概览、不写不可验证的废话
2. **Karpathy 4 条准则** — 行为约束而非代码约束，从源头减少 LLM 编码失误

并把**会话维护协议**烘到生成的根文件里——下一次会话的 agent 读到这个文件，就自动知道要在结束前回看本次实际做了什么、更新 `TODO.md` 和规则。

## 何时使用

- 用户说"生成 CLAUDE.md" / "init CLAUDE.md" / "set up Claude Code rules" / "为这个项目写 CLAUDE.md"（中英文同效）
- 用户说"生成 AGENTS.md" / "初始化 Codex 项目规则"
- 用户说"补一份 TODO.md" / "维护任务清单" / "把这次发现的问题记一下"
- 已有 CLAUDE.md 超过 200 行要求拆分
- 提到 `.claude/rules/` 或路径作用域的规则
- 新项目开工需要 AI 编码引导

## 何时不使用

- 用户只想改某一条具体规则 → 直接编辑文件，不要触发本 skill
- 用户问"什么是 CLAUDE.md" → 直接解释，不要生成
- 项目没有任何代码（无 package.json / pyproject.toml / go.mod / Cargo.toml 等） → 先问语言/框架/包管理器/测试运行器，**不要编造**
- 用户明确拒绝或没有技术栈信号

## 触发关键词

**英文**：init CLAUDE.md / set up Claude Code rules / generate project rules / split CLAUDE.md / add a TODO board
**中文**：生成 CLAUDE.md / 初始化项目规则 / 写一个 AGENTS.md / 补一份 TODO.md / 规则文件按目录拆分 / 规则太多要整理

## 核心交付物

每次执行本 skill 至少产出 2 类文件（按平台决定文件名）：

| 平台 | 主文件 | 详细规则 | 任务清单 |
|------|--------|----------|----------|
| Claude Code | CLAUDE.md | .claude/rules/*.md | TODO.md |
| Codex (OpenAI) | AGENTS.md | .codex/rules/*.md（可选）| TODO.md |
| 通用（默认双写） | 两者 | 两者 | TODO.md |

## 语言策略

- **Skill 主体语言**：中文（用户偏好）
- **生成文件语言**：由生成的 `## Language` 段锁定 4 个字段，不可隐式默认
- **Agent 对话语言**：用户首条消息语言

### 4 字段检测顺序

1. 读 `README.md` 前 50 行检测项目主语言
2. 比对用户首条消息语言
3. 不同则**问用户**，不要擅自决定
4. 项目为空则用用户语言

每个生成的 `CLAUDE.md` / `AGENTS.md` **必须**包含一个 `## Language` 段，把以下 4 个字段全部填出来，让选择可审计：

- Communication：`<zh | en | bilingual>`
- Code comments：`<zh | en>`
- Commit messages：`<en | zh>`
- Rule files：`<zh | en | bilingual>`

## 工作流

### Step 0：平台与目标文件检测

按以下信号判定输出文件名（多个信号取并集）：

| 信号 | 偏好 |
|------|------|
| 存在 .claude/ 目录 | Claude Code（写 CLAUDE.md）|
| 存在 .codex/ 目录 | Codex（写 AGENTS.md）|
| 已 commit 的 CLAUDE.md | 保留，写 CLAUDE.md |
| 已 commit 的 AGENTS.md | 保留，写 AGENTS.md |
| 用户显式说"Codex" / "Claude Code" / "两个都要" | 用户说了算 |
| 都检测不到 | **默认双写**（最安全）|

不要在没有信号时强行猜。

### Step 0.5：环境检测（首次运行）

确认本 skill 是否被 agent 加载到：

| skill 目录检查 | 状态 | 含义 |
|----------------|------|------|
| `~/.codex/skills/init-claude-md/SKILL.md` 存在 | 已装 Codex | agent 会自动激活本 skill |
| `~/.claude/skills/init-claude-md/SKILL.md` 存在 | 已装 Claude Code | agent 会自动激活 |
| `~/.agents/skills/init-claude-md/SKILL.md` 存在 | 已装通用 agent | agent 会自动激活 |
| 上面都不存在 | **未装** | 当前文档只读，agent 不会自动触发；告诉用户安装步骤（见 `references/install.md`），**不要**假装激活 |

> **重要**：如果检测到未装，告诉用户怎么装（粘贴 `references/install.md` 里的命令）。**不要**在不装的情况下凭空生成 CLAUDE.md —— 用户会以为是 agent 智能行为，破坏可重复性。

### Step 1：项目扫描

并行读取以下文件（Codex 用 `shell_command`，Claude Code 用 `Read`）：

- `README.md` / `README.*.md`（前 50 行 → 主语言 + 项目意图）
- `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml` / `pom.xml`（语言/框架/scripts）
- `tsconfig.json` / `jsconfig.json`（TS/JS 配置）
- 现有 `CLAUDE.md` / `AGENTS.md`（是否需要合并——见 Step 3）
- 现有 `TODO.md`（是否需要迁移——不要覆盖）
- `.eslintrc*` / `biome.json` / `.prettierrc*`（代码风格）
- `Makefile` / `justfile`（任务运行器）
- `Dockerfile*` / `docker-compose*.yml`（部署）
- `.github/workflows/`（CI 约定）
- `prisma/schema.prisma` / `drizzle.config.*` / `migrations/`（数据库栈）
- 顶层目录列表（monorepo 检测：看 apps/ packages/ services/ modules/）
- 扫一次代码里的 `TODO` / `FIXME` / `HACK` 注释（为 TODO.md 提供初始项）

**空项目（无代码）→ 停下来问用户**，不要编造。

### Step 2：决定文件布局

```
是否有清晰技术栈？
├── 否 → 问用户，不要生成
└── 是
    │
    是否 monorepo（顶层有 apps/ packages/ services/ 多个子包）？
    ├── 是 → Layout C（monorepo）
    └── 否
        │
        源代码文件 <10 且无 DB、无 auth？
        ├── 是 → Layout A（仅根文件）
        └── 否 → Layout B（根文件 + 规则目录，默认）
```

**Layout A — 单文件**：仅 CLAUDE.md / AGENTS.md，≤60 行
**Layout B — 根文件 + 规则目录**：默认选择
**Layout C — Monorepo**：根文件（workspace 级）+ 每个子包一份 `AGENTS.md` 或 `<子包>/.claude/rules/*.md`

### Step 3：合并策略（如目标文件已存在）

如果 CLAUDE.md / AGENTS.md 已存在，按下表处理；**不覆盖**用户的真实文本：

| 段 | 处理 |
|----|------|
| 缺失段 | 添加并填入检测结果 |
| 段内容是占位符（`<...>` / 空）| 填充 |
| 段内容是真实文本 | **保留**，不覆盖 |
| "Things to avoid" 段 | **追加**到末尾，不删现有条目 |
| "Verification" 命令 | 仅在原命令跑不通时更新；保留用户已写好的命令 |
| "Workflow" 分支/提交规范 | 保留用户约定，不擅自改成"标准"约定 |
| "Session Maintenance Protocol" 段 | 重新生成（这是 skill 自身维护的，不属于用户手写）|
| "Language" 段 | 重新生成（4 字段必填）|

**反例**：不要因为"检测到 package manager 是 npm"就覆盖用户写的 "我们用 pnpm"。
**反例**：不要因为"惯例是 Conventional Commits"就覆盖用户写的"用 gitmoji"。

### Step 4：生成根文件（CLAUDE.md / AGENTS.md）

按 `references/root-template.md` 模板填充。要点：

- **顶部**插入"会话维护协议"块（见 Step 7）—— 这是本 skill 的核心交付
- 60 行硬上限
- 4 个 Karpathy 准则压缩到 1-2 行
- "Language" 4 字段必填
- 末尾给一条**真实可跑**的 verification 命令
- 不写目录树、不写架构概览

### Step 5：生成 TODO.md

按 `examples/TODO.md` 骨架填 4 段（注意：emoji 段头是 fixed，不要换文字）：

- 🔴 进行中（≤3 项）
- 🟡 待处理（带 P1/P2 优先级 + 源链接）
- 🟢 后续（低优先级）
- ✅ 已完成（初始化时为空）

填充来源（来自 Step 1 扫描）：

- 注释里的 `TODO` / `FIXME` / `HACK` → 🟡
- 缺少测试的源文件 → 🟢
- 硬编码值 / 魔数 → 🟢
- 顶层目录里 README 提到的"待办"/"TODO" → 🟡
- 没扫到 → **留空，不编造**（这是核心原则）

### Step 6：生成 .claude/rules/*.md（仅 Layout B / C）

按 `references/rule-file-template.md` 模板。每个文件：

- `paths:` frontmatter 决定何时加载
- 30-80 行
- 单个关注点
- 最多 200 行
- 命名：lowercase-hyphen，`api-conventions.md` 而非 `rules.md`

### Step 7：会话维护协议（核心新机制）

> 这是本 skill 的核心：让**生成的规则文件本身驱动维护**，而不是依赖外部触发。

每个生成的根文件顶部必须嵌入"会话维护协议"段（短版，写在根文件里），完整决策表在 `references/session-maintenance-protocol.md`（长版，被规则文件引用）。

短版固定模板（中文版；英文版见 `references/session-maintenance-protocol.md` 末尾）：

```markdown
## Session Maintenance Protocol

**开始时**：读 `TODO.md`，复述当前 🔴 和 🟡 段，确认本次会话要推进哪几项。

**结束前**（最后一条用户消息之后、停止前必做）：

1. **回看本次会话实际做了什么** —— 改动的文件、发现的问题、用户新增的约束
2. **更新 `TODO.md`**（决策表见 `references/session-maintenance-protocol.md`）：
   - 完成了某项 → 移到 ✅ 段，加 `(YYYY-MM-DD)`
   - 新发现的问题 → 加到 🟡（P1/P2）或 🟢（P3+），附源链接
   - 放弃某项 → 移到 ✅ 段，备注 `已放弃：<原因>`
3. **更新本文件的规则** —— 如果本次会话暴露了新的项目级约定：
   - 用户反复纠正的行为 → 加到 "Things to avoid" 段
   - 反复跑错的命令 → 更新 "Verification" 段
   - 隐含约定 → 加到 "Project conventions" 段
4. **刷新日期戳** `> 最后更新：YYYY-MM-DD`（即使其他都没变）

**触发条件**（满足任一即必须更新 TODO.md）：≥1 个源文件被改 · 用户新增了约束 · 会话 > 10 分钟
```

英文版（用于 Language 段 Communication=`en` 的项目）见 `references/session-maintenance-protocol.md` 末尾，骨架一样，仅文案翻译。

### Step 7.5：硬自动 hook（可选增强）

默认的协议块是**软自动**（agent 自觉执行）。要做**硬自动**，在 AI agent 的 hook 系统里注册 session-end 触发器：

- **Claude Code**：把 `references/hooks/claude-code-settings.json` 粘到 `~/.claude/settings.json` 的 `hooks` 字段（合并而非覆盖整个文件）
- **Codex**：plugin 系统只支持 tool-level hooks（`PreToolUse` / `PostToolUse`），**没有 SessionEnd 事件**。Codex 用户推荐**手跑** `bash scripts/check-session-end.sh`（或 PowerShell 版本）
- **其他 agent**：调 `scripts/check-session-end.sh` 的等价物

`scripts/check-session-end.sh` / `.ps1` 是跨平台检查脚本，行为：

1. 找项目根（`git rev-parse --show-toplevel`）
2. 探测 `CLAUDE.md` 或 `AGENTS.md`
3. 数 `git diff --name-only HEAD` 改了多文件
4. 打印决策表提示

**脚本只输出建议，不自动改文件**（避免 agent 写错）。是**提醒器**不是**执行器**。

完整说明见 `references/session-end-hook.md`。

### Step 8：自检清单

声明完成前必跑：

- [ ] 根文件 ≤60 行（不含代码块）
- [ ] 根文件无目录树、无架构概览
- [ ] 根文件**顶部**带"会话维护协议"段
- [ ] `TODO.md` 4 段都有（即使空也留骨架）
- [ ] 所有 rule 文件有 `paths:` frontmatter
- [ ] 没有任何 rule 文件 >200 行
- [ ] "Language" 4 字段全填
- [ ] `Verification` 命令真的能跑（用 `bash -c` 试一次）
- [ ] 没复制粘贴无用的框架默认
- [ ] **本仓库自己的 AGENTS.md / CLAUDE.md 也满足以上全部**（self-dogfooding）

### Step 9：给用户回执

```
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
```

## TODO.md 维护机制

> 本节是给 agent（执行本 skill 的 agent 和未来的 agent）看的，不是给用户看的。

`TODO.md` 是项目的活待办清单，与 CLAUDE.md / AGENTS.md 同级放在项目根目录。

### 会话生命周期

```
会话开始 → 读取 TODO.md，了解当前待办和进行中任务
         ↓
       工作...
         ↓
会话结束 → 按 references/session-maintenance-protocol.md 的决策表更新 TODO.md
         ↓
       同时按 Step 7 第 3 步决定是否更新 CLAUDE.md / AGENTS.md
```

### 决策表（短版）

| 操作 | 规则 |
|------|------|
| 完成某项 | 从当前段移除 → 移到 `✅ 已完成`，加 `(YYYY-MM-DD)` 后缀 |
| 发现新问题 | 加到 `🟡 待处理`（P1/P2）或 `🟢 后续`（P3+），标注优先级 + 源链接 |
| 开始做某项 | 移到 `🔴 进行中` |
| 放弃某项 | 移到 `✅ 已完成`，备注 `已放弃：<原因>` |

### 维护原则

- 描述简洁（一行），附源代码链接或设计文档链接
- 已完成项**不删除**，只下移到 ✅ 段
- 不要为已完成项写冗长总结 — 一行带日期即可
- 每次会话结束前必检查是否需要更新
- 如无变化，更新 `> 最后更新：YYYY-MM-DD` 即可

完整决策表 + 边界 case 见 `references/session-maintenance-protocol.md`。

## 参考资料

- `references/root-template.md` — 根文件骨架（已带会话维护协议头）
- `references/rule-file-template.md` — 单个 rule 文件骨架
- `references/content-rules.md` — 内容取舍规则（放什么、不放什么）
- `references/rules-splitter.md` — Layout A/B/C 决策树 + 检测矩阵
- `references/karpathy-rules.md` — Karpathy 4 条准则原文
- `references/session-maintenance-protocol.md` — **会话维护决策表**（必读）
- `examples/TODO.md` — 完整 TODO.md 范例
- `examples/humanlayer-CLAUDE.md` — HumanLayer 模式范例
- `examples/karpathy-CLAUDE.md` — 纯 Karpathy 模式范例
- `examples/monorepo-root-CLAUDE.md` — Monorepo workspace 根文件范例（Layout C）
- `examples/monorepo-package-AGENTS.md` — Monorepo 子包文件范例（带 `paths:` frontmatter）
- `examples/api-conventions.md` — 单个 rule 文件范例（带 `paths:` frontmatter + good/bad 示例）

## 安装与使用

- `references/install.md` — 把本 skill 装到 `~/.codex/skills/` / `~/.claude/skills/` 的步骤
- `references/quick-start.md` — 5 分钟上手（生成 → 检查 → 提交 → 维护）
- `references/session-end-hook.md` — **硬自动 hook 配置**（让 session 真正结束时自动跑检查脚本）
- `references/hooks/claude-code-settings.json` — Claude Code `SessionEnd` hook 模板（粘到 `~/.claude/settings.json`）
- `references/hooks/codex-plugin.json` — Codex plugin hook 模板（**PostToolUse 近似**，Codex 无 SessionEnd 事件）
- `scripts/check-session-end.sh` — bash 跨平台检查脚本
- `scripts/check-session-end.ps1` — PowerShell 检查脚本（英文输出避开 chcp 936 乱码）
