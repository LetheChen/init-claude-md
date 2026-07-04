# 贡献指南

感谢你对 init-claude-md 的关注！

## 如何贡献

### 报告问题

- 使用 [Bug 报告模板](https://github.com/LetheChen/init-claude-md/issues/new?template=bug_report.md)
- 附上平台信息（Codex / Claude Code）和 SKILL.md 版本
- 提供复现步骤

### 建议功能

- 使用 [功能建议模板](https://github.com/LetheChen/init-claude-md/issues/new?template=feature_request.md)
- 说明这个功能解决什么问题

### 提交代码

1. Fork 本仓库
2. 创建分支 `codex/<scope>-<slug>`
3. 遵循项目约定：
   - 所有文件 UTF-8 no BOM
   - Commit 用 Conventional Commits（`feat:` / `fix:` / `chore:` / `docs:` / `refactor:`）
   - 改动 `SKILL.md` 时同步更新 `references/` 中的决策表/模板
4. 提交 PR，描述变更内容

## 项目约定

详见 [CONTRIBUTING.md](CONTRIBUTING.md) 和仓库根目录的 `AGENTS.md` / `CLAUDE.md`。

- **语言**：文档和注释用中文，commit message 用英文
- **极简原则**：根文件 ≤60 行，不写目录树/架构概览
- **软自动**：不加 hook / cron / 外部触发器
