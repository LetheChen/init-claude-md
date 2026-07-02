# Content rules — what to put in, what to leave out

## 必放进根 CLAUDE.md

- **Session Maintenance Protocol 块**（在顶部，~20 行）— 来自 `references/session-maintenance-protocol.md` 短版
- 4 条 Karpathy 准则（压缩到 1-2 行 / 条）
- 检测到的包管理器 + test + typecheck + lint 命令
- Branch + commit + PR 工作流（能检测到时）
- 一条**可跑的** verification 命令
- 3-5 条本项目硬性 "do not" 规则

## 不要放进根 CLAUDE.md

| 别写 | 为什么 |
|---|---|
| "This is a TypeScript project" | 太浅，agent 能自己检测 |
| 完整目录树 | 立刻过期，文件膨胀 |
| 架构概览 / 模块描述 | 属于 README，不属于 agent 规则 |
| "Follow best practices" | 不可验证，被忽略 |
| "Write clean code" | 不可验证，被忽略 |
| "Use TypeScript strict mode" | 已经在 tsconfig 里 |
| "Add tests" | 通用，无操作性 |
| LLM 鸡汤（"you are a senior engineer"） | 噪音 |
| 所有 npm scripts 列表 | 读 package.json |
| 已被 linter 覆盖的代码风格 | 重复配置 |

## 必放进 rule 文件

- 规则存在的 WHY（一行）
- 具体、可验证的规则
- 可选：good vs bad 代码示例（强）
- 反模式：违反后的失败模式

## 不要放进 rule 文件

- 通用建议（"handle errors properly"）
- 应该由 linter 强制的事
- 根文件已有的规则（拆分不复制）
- 实现教程（那些写进代码注释）

## 语气

- 命令式、简洁、第二人称隐式
- "Do X" 而不是 "You should consider X"
- "Never X" 是硬禁，"Avoid X" 是软引导
- 不道歉、不 hedging（"perhaps consider..."）

## Specificity test

加规则前问：

1. 机器能检查吗？（"use 2-space indent" — 能）
2. 不能的话，reviewer 5 秒能验证吗？（"always return early on errors" — 能）
3. 都不能 → 删掉（"be thoughtful" — 删）

## "3 AM test"

凌晨 3 点被叫醒的开发者看这条规则，能不思考就执行吗？不能就重写。

## Self-edit cadence

- 实际中被忽略 2 次的规则 → 删或重写
- 实际中从未引发问题的规则 → 保留
- 根文件接近 200 行 → 先拆到 rules/ 再加新规则

## TODO.md 内容规则

`TODO.md` 是项目的活任务板，质量要求和 CLAUDE.md 一样。

### 必含

- 4 段：`🔴 进行中` / `🟡 待处理` / `🟢 后续` / `✅ 已完成`
- `> 最后更新：YYYY-MM-DD` 头部带日期
- 🟡 段项要标 P1/P2/P3
- 每项附源链接（文件路径）

### 不要有

- `🔴 进行中` 一次 >3 项
- 长描述 — 一行一项
- 没有明确下一步动作的项
- 已完成项出现在 ✅ 以外的段
- 没有具体触发条件的特性 wishlist

### 初始化时

- 扫代码里的 `TODO` / `FIXME` / `HACK` 注释 → 🟡
- 扫缺少测试的源文件 → 🟢
- 扫硬编码值 / 魔数 → 🟢
- 没扫到 → **留空，不要编造**（核心原则）

### 会话结束更新时

- 已完成 → 移到 ✅，加日期
- 新发现 → 加到 🟡 或 🟢
- 描述简洁，附源链接
- 每次刷 `> 最后更新：` 日期

### 维护机制

完整决策表 + 边界 case 见 `references/session-maintenance-protocol.md`。**Session Maintenance Protocol 块**必须嵌入在生成的根 CLAUDE.md / AGENTS.md 顶部，让未来 agent 知道怎么维护这两个文件。