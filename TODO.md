# 待办清单

> 最后更新：2026-07-02
> 维护规则：会话开始时读，会话结束时按 `references/session-maintenance-protocol.md` 更新

## 🔴 进行中

- _(暂无)_

## 🟡 待处理

- _(暂无 — 初始化扫描未发现 TODO/FIXME/HACK 标记)_

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