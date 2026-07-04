# 待办清单

> 最后更新：2026-07-05
> 维护规则：会话开始时读，会话结束时按 `references/session-maintenance-protocol.md` 更新

## 🔴 进行中

- _(暂无)_

## 🟡 待处理

- 更新 GitHub 仓库元数据（description、topics）— 需手动在网页操作

## 🟢 后续

- 翻译"3 AM 测试"为英文版（README 中文版独有，英文版需要同步）

## ✅ 已完成

- [x] 重写 SKILL.md：中文主体、平台检测、Layout C、合并策略、Step 7 会话维护协议 (2026-07-02)
- [x] 新增 `references/session-maintenance-protocol.md`（完整决策表 + 边界 case + 英文版）(2026-07-02)
- [x] 新增 `examples/TODO.md` 完整范例 (2026-07-02)
- [x] 新增 `examples/monorepo-root-CLAUDE.md` + `monorepo-package-AGENTS.md`（Layout C）(2026-07-02)
- [x] 更新 `examples/humanlayer-CLAUDE.md` + `karpathy-CLAUDE.md` 顶部加 Session Maintenance Protocol (2026-07-02)
- [x] 更新 `references/root-template.md`、`rules-splitter.md`、`content-rules.md` (2026-07-02)
- [x] 本仓库 self-dogfood：AGENTS.md + CLAUDE.md + TODO.md 三件套都带协议头 + Language 段 (2026-07-02)
- [x] 修复 `AGENTS.md` / `CLAUDE.md` 带 UTF-8 BOM 的问题（统一 no-BOM）(2026-07-02)
- [x] 修复 `examples/karpathy-CLAUDE.md` 缺 `## Language` 段、`monorepo-package-AGENTS.md` 缺 `paths:` frontmatter（与 SKILL.md 描述对齐）(2026-07-02)
- [x] 新增 `examples/api-conventions.md`（rule 文件范例：带 paths: frontmatter + good/bad 示例）(2026-07-02)
- [x] 清理 hook 资产：删 `references/session-end-hook.md` + `references/hooks/` 2 个 json + `scripts/` 2 个脚本；SKILL.md 删 Step 7.5 + 改"安装与使用"段为"更新机制"；README.md 删中英双版 hook 段 + 同步目录树；quick-start.md 删"启用硬自动"段 (2026-07-02)
- [x] AGENTS.md / CLAUDE.md：删 2 条 hook 警告（"Codex 无 SessionEnd"/"check-session-end.sh 改成自动改文件"），加 2 条软自动设计警告（"不要加 hook / cron / 外部触发器"/"不要去掉根文件顶部的 Session Maintenance Protocol 块"）(2026-07-02)
- [x] 用 skill-creator 原则审视并优化：SKILL.md 删 3 段冗余（"何时使用" 28 行 / Step 0.5 环境检测 13 行 / "TODO.md 维护机制" 36 行）→ 318 → 205 行；修复 21 处 PowerShell 字符串处理损坏（15 处 `\r`→CR 单字符 + 3 处 `\a`→BEL + 2 处 `\b`→BS + 1 处 `\v`→VT + 1 处 `\n`→LF 单字符导致 CRLF 跨行丢失）；README.md 删英文双版（184 行）+ 哲学段 + 致谢段 → 464 → 177 行；修复 5 处同源字符损坏（2 处 `\r` + 1 处 `\a` + 1 处 `\v` + 1 处 `\n`）；全仓库累计 26 处（SKILL.md 21 + README.md 5）；尾部三段合并成参考资料表格 (2026-07-03)
- [x] AGENTS.md / CLAUDE.md 刷日期戳 2026-07-03
- [x] AGENTS.md / CLAUDE.md Things to avoid 段加 1 条 PowerShell 写文件警告（`Get-Content | Set-Content` 会丢 CRLF + 解释 `\a` `\b` `\v` 控制字符；改用 `ReadAllBytes/WriteAllBytes` 字节级操作）(2026-07-03)
- [x] 发布流程切换到 solo push-to-main：fast-forward 本地 main 到 5967a8f 后 push origin/main；AGENTS.md / CLAUDE.md Workflow 段改 "PR: GitHub Flow" → "Solo 维护者直接 push origin/main" (2026-07-03)
- [x] 更新维护 GitHub 开源信息：修复 README 占位符/路径、添加 .github/ISSUE_TEMPLATE + PR_TEMPLATE、添加 CONTRIBUTING.md、更新 LICENSE 年份 (2026-07-04)
