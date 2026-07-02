# Session Maintenance Protocol — 完整决策表

> 短版（嵌入在生成的 CLAUDE.md / AGENTS.md 顶部）和**本长版**协同工作：短版是精简契约，长版是规则手册。短版引用本文件的决策表，遇到边界 case 时回查本文件。

## 会话开始协议

1. 读取 `TODO.md`（项目根目录）
2. 复述给用户（用 `## Language` 段 Communication 字段指定的语言）：
   - `🔴 进行中` 当前项（最多 3 项，只列与本会话相关的）
   - `🟡 待处理` P1/P2 优先级最高的 5 项
3. 问用户本次要推进哪几项 — **除非**用户首条消息已经明确说要做什么

如果 `TODO.md` 不存在，跳过（skill 初始化时生成）。

## 会话结束协议

满足以下任一触发条件 → 必须更新 `TODO.md`，可能也要更新规则文件：

- [ ] 源文件被改：`git diff --name-only` 显示 ≥1 个文件
- [ ] 用户新增约束：本会话用户消息里出现"用 X" / "不要 Y" / "以后都 Z" / "should be X"
- [ ] 会话时长 > 10 分钟（粗略启发，按实际情况判断）
- [ ] 代码里发现值得追踪的 bug 或 TODO

都不满足 → 至少把两个文件里的 `> 最后更新：YYYY-MM-DD` 时间戳刷新。

### TODO.md 决策表

| 发生什么 | 动作 |
|---|---|
| 用户要求做 X，X 已完成 | 找到 X 所在段（🟡/🟢/🔴）→ 移除 → 加到 `✅ 已完成`：`- [x] X (YYYY-MM-DD) 源:<file:line>` |
| 工作中发现 bug 或 TODO | 加到 `🟡 待处理`：`- [ ] (P1/P2) <bug> 源:<file:line>` |
| 发现低优先级清理 | 加到 `🟢 后续`（无需优先级标签）：`- [ ] <cleanup>` |
| 开始多步任务 | 移到 `🔴 进行中`：`- [ ] <task> 源:<设计文档>` |
| 放弃某项 | 移到 `✅ 已完成`：`- [x] ~~<item>~~ 已放弃：<原因> (YYYY-MM-DD)` |
| 项目仍然相关但没开始 | 留在 `🟡`/`🟢`，可调整优先级 |
| 项目已过时 | 移到 `✅ 已完成`：`已过时：<原因>` |

### CLAUDE.md / AGENTS.md 决策表

| 发生什么 | 动作 |
|---|---|
| 同一行为被用户纠正 ≥2 次 | 加到 `## Things to avoid`（具体而非"小心点"）|
| `## Verification` 命令错或不存在 | 更新命令（先确认新命令能跑）|
| 发现项目约定不在 `## Project conventions` | 添加（一行 + 源）|
| `.claude/rules/*.md` 现在误导人 | 重写该文件 — 不要删除规则，是规则错了不是不需要了 |
| 根文件接近 200 行 | 再次触发本 skill 拆分为 Layout B/C |
| 没新发现 | 跳过 — 只刷新 `> 最后更新：YYYY-MM-DD` |

## 边界 case

- **多用户 / 共享 repo**：只更新当前用户（你）做的项目，不要 claim 别的 agent 的工作
- **快速 Q&A**（<2 分钟，无代码改动）：跳过 TODO 更新，但刷日期戳
- **失败 / 中断的会话**：仍要更新 TODO.md — 失败的尝试去 `✅` 段加 `已放弃` 或 `未完成` 备注，**不要删**
- **发现本文件与现有 CLAUDE.md 规则矛盾**：以现有规则为准，把矛盾告诉用户，不要默默覆盖
- **发现项目根本不用本 skill 的产出**（团队有别的约定）：不强推 — 问用户

## 英文版（用于 Language.Communication = `en` 的项目）

```markdown
## Session Maintenance Protocol

**At session start:** read `TODO.md`, summarize `🔴 In progress` and `🟡 Todo`, confirm what to push this session.

**At session end (before stopping, after last user message):**

1. **Review what THIS session actually changed** — files modified, issues found, new constraints
2. **Update `TODO.md`** per decision table (see `references/session-maintenance-protocol.md` long form):
   - Completed → move to `✅ Done (YYYY-MM-DD)`
   - New issue → add to `🟡 Todo` (P1/P2) or `🟢 Backlog` (P3+)
   - Abandoned → move to `✅ Done` with `abandoned: <reason>`
3. **Update this file's rules** IF the session revealed new conventions:
   - Repeated user corrections → add to `## Things to avoid`
   - Repeatedly failed commands → fix `## Verification`
   - Hidden conventions → add to `## Project conventions`
4. **Refresh date stamp** `> Last updated: YYYY-MM-DD` (even if nothing else changed)

**Trigger** (any of): ≥1 source file changed · user added new constraints · session > 10 min
```

短版（嵌入在根文件顶部）= 上面的精简翻译。语言遵循项目 `## Language` 段 Communication 字段。