# Session-end hook 配置（可选增强）

> **重要**：本 skill 的"自动更新"分两层 —— **软自动**（默认，零依赖）和 **硬自动**（可选，需配置 agent hook）。

## 软自动（默认）

根文件顶部的 Session Maintenance Protocol 块 —— agent 读完就知道要在 session 结束前更新 TODO.md / 规则文件。**这是最低保障**，跨所有 agent。

**局限**：依赖 agent 真的读了根文件并自觉执行。如果 agent 读得太浅、上下文太长、或者任务中断，TODO 不会自动更新。

## 硬自动（可选）

在 AI agent 的 hook 系统里注册 session-end 触发器，session 真的结束时自动跑检查脚本。agent 想忘也忘不了。

## Claude Code 配置

把以下 JSON 合并到 `~/.claude/settings.json` 的 `hooks` 字段（注意是合并，不是覆盖整个文件）：

```json
{
  "hooks": {
    "SessionEnd": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"\$(git rev-parse --show-toplevel)/scripts/check-session-end.sh\""
          }
        ]
      }
    ]
  }
}
```

Claude Code 在每次 session 真正结束时会跑 `check-session-end.sh`，脚本只**打印建议**，不自动改文件（避免 agent 写错）。agent 看完建议再决定怎么改。

## Codex 配置

Codex 的 plugin 系统（`~/.codex/plugins/<name>/plugin.json`）支持 **tool-level hooks**（`PreToolUse` / `PostToolUse`），**但没有 SessionEnd 这种会话级事件**。

Codex 用户有 3 个选择：

1. **手跑脚本（推荐）**：在 session 结束前主动跑 `bash scripts/check-session-end.sh`，最低噪音
2. **PostToolUse 近似**：每次工具调用后跑一次轻量检查 —— 实现见 `references/hooks/codex-plugin.json`，但噪音较大（每改一个文件都触发）
3. **接受软自动**：依赖根文件顶部的协议块

## 检查脚本

`scripts/check-session-end.sh` / `scripts/check-session-end.ps1` —— 跨平台检查脚本，行为：

1. 找项目根（`git rev-parse --show-toplevel`）
2. 检查 `TODO.md` 是否存在
3. 数 `git diff --name-only HEAD` 改了多文件
4. 打印决策表提示

**脚本只输出建议，不自动改文件**。原因：自动改文件风险大，agent 应该有最终决定权。脚本是**提醒器**，不是**执行器**。

## 推荐组合

- **Claude Code 用户**：软自动 + 硬自动（`SessionEnd` hook），双重保险
- **Codex 用户**：软自动 + 手动跑脚本（用 `bash scripts/check-session-end.sh` 加到 session 结束前的最后一步）
- **Cursor / 其他**：软自动 + 手动跑脚本

## 故障排查

| 现象 | 排查 |
|------|------|
| 脚本没跑 | 检查 `git rev-parse --show-toplevel` 输出是否正确（要在项目根目录跑） |
| 脚本跑但 TODO 没更新 | agent 没遵守决策表 —— 检查根文件顶部的协议块是否被读 |
| Claude Code 不触发 SessionEnd | 检查 `~/.claude/settings.json` 合并后 JSON 格式合法（`python -m json.tool` 验证） |