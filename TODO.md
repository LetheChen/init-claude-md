# 待办清单

> 最后更新：2026-07-02
> 维护规则：会话开始时读，会话结束时按 `references/session-maintenance-protocol.md` 更新

## 🔴 进行中

- _(暂无)_

## 🟡 待处理

- _(暂无 — 初始化扫描未发现 TODO/FIXME/HACK 标记)_

## 🟢 后续

- 给仓库加 CI 检查：拒绝 UTF-8 BOM（PowerShell 默认写出会带 BOM）
- 给仓库加 markdownlint 配置（统一 references/ 和 examples/ 的格式）
- 在 `examples/` 补一个 `api-conventions.md` 范例 rule 文件
- 把"3 AM 测试"翻译成英文版写进 references/（当前只中文）

## ✅ 已完成

- [x] 重写 SKILL.md：中文主体、平台检测、Layout C、合并策略、Step 7 会话维护协议 (2026-07-02)
- [x] 新增 `references/session-maintenance-protocol.md`（完整决策表 + 边界 case + 英文版）(2026-07-02)
- [x] 新增 `examples/TODO.md` 完整范例 (2026-07-02)
- [x] 新增 `examples/monorepo-root-CLAUDE.md` + `monorepo-package-AGENTS.md`（Layout C）(2026-07-02)
- [x] 更新 `examples/humanlayer-CLAUDE.md` + `karpathy-CLAUDE.md` 顶部加 Session Maintenance Protocol (2026-07-02)
- [x] 更新 `references/root-template.md`、`rules-splitter.md`、`content-rules.md` (2026-07-02)
- [x] 本仓库 self-dogfood：AGENTS.md + CLAUDE.md + TODO.md 三件套都带协议头 + Language 段 (2026-07-02)
- [x] 修复 `AGENTS.md` / `CLAUDE.md` 带 UTF-8 BOM 的问题（统一 no-BOM）(2026-07-02)