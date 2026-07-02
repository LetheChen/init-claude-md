# 5 分钟上手

## 1. 在你的项目里跑（30 秒）

新会话里说：

> "为这个项目生成 CLAUDE.md 和 TODO.md"

或者：

> "init CLAUDE.md"

agent 会自动：

1. 扫项目（`package.json` / `README` / 现有规则文件 / monorepo 检测）
2. 按 Step 2 决定 Layout A / B / C
3. 生成 `CLAUDE.md`（或 `AGENTS.md`），≤60 行，顶部带 Session Maintenance Protocol 头
4. 生成 `TODO.md`，4 段齐全
5. 按 Layout B/C 生成 `.claude/rules/*.md`

## 2. 检查产出（2 分钟）

打开生成的 CLAUDE.md，逐项核对：

- [ ] ≤60 行（不含代码块）
- [ ] 顶部有 `## Session Maintenance Protocol` 段
- [ ] `## Language` 段 4 字段全填
- [ ] `## Verification` 段命令可跑（手动跑一次）
- [ ] 没有目录树、没有架构概览、没有"write clean code"

打开 TODO.md，逐项核对：

- [ ] 4 段（🔴/🟡/🟢/✅）齐全
- [ ] 没有编造内容（如果项目里没 TODO 注释，🟡 段应该空着）

## 3. 提交（30 秒）

```bash
git add CLAUDE.md TODO.md .claude/
git commit -m "feat: add CLAUDE.md + TODO.md via init-claude-md skill"
```

## 4. 启用硬自动（可选，2 分钟）

把 `references/hooks/claude-code-settings.json` 粘到 `~/.claude/settings.json` 的 `hooks` 字段。重启 Claude Code。从下一次会话开始，session 结束时会自动跑检查脚本并提示更新。

Codex 用户：见 `references/session-end-hook.md`，Codex 没有 SessionEnd 事件，需要**手跑** `bash scripts/check-session-end.sh`。

## 5. 维护（持续）

每次新会话结束前观察：

- agent 是否主动更新了 TODO.md？ ✅
- agent 是否在 Things to avoid 段加了新发现？ ✅
- Verification 命令是否还能跑？ ✅
- 根文件是否接近 200 行？ → 再次触发本 skill 拆分

## 6. 调优（按需）

| 现象 | 修复 |
|------|------|
| TODO 一直没更新 | 检查根文件协议块 → 考虑加 session-end hook |
| 规则被 agent 忽略 | 改写规则（具体 + 可验证） |
| 根文件超过 60 行 | 触发本 skill 重生，按 Layout B 拆分 |
| 根文件超过 200 行 | 必须拆分到 `.claude/rules/*.md` |
| 规则被反复违反 | 加到 Things to avoid 段，加具体反例 |

## 下一步

- 想看完整决策表：读 `references/session-maintenance-protocol.md`
- 想理解 Layout 选择：读 `references/rules-splitter.md`
- 想看内容取舍：读 `references/content-rules.md`
- 想看范例：浏览 `examples/`（humanlayer / karpathy / monorepo）