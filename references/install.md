# 安装 init-claude-md skill

## 系统要求

- Codex（OpenAI）/ Claude Code / 任何支持 `~/.codex/skills/` 或 `~/.agents/skills/` 的 AI agent
- Git

## 安装到 Codex（推荐）

**方式 1：本地复制**

```bash
# Linux / macOS / WSL
mkdir -p ~/.codex/skills/init-claude-md
cp -r /path/to/init-claude-md/* ~/.codex/skills/init-claude-md/
```

PowerShell：

```powershell
$dst = "$env:USERPROFILE\.codex\skills\init-claude-md"
New-Item -ItemType Directory -Path $dst -Force
Copy-Item -Path "E:\Document\Skills开发学习\init-claude-md\*" -Destination $dst -Recurse -Force
```

**方式 2：git clone**

```bash
git clone <this-repo-url> ~/.codex/skills/init-claude-md
```

## 安装到 Claude Code

```bash
mkdir -p ~/.claude/skills/init-claude-md
cp -r /path/to/init-claude-md/* ~/.claude/skills/init-claude-md/
```

## 安装到其他 agent

任何支持 `~/.agents/skills/` 的 agent：

```bash
mkdir -p ~/.agents/skills/init-claude-md
cp -r /path/to/init-claude-md/* ~/.agents/skills/init-claude-md/
```

## 验证安装

重启 AI agent。在新会话里说：

> "为当前项目生成 CLAUDE.md"

或：

> "init CLAUDE.md"

agent 应该自动激活本 skill 并开始执行（如果没激活，检查 frontmatter 里的 `description` 字段是否包含你的触发词）。

## 升级

```bash
cd ~/.codex/skills/init-claude-md
git pull
```

如果有 breaking change（比如 layout 决策树改了），需要**重新跑一次** skill 来更新目标项目的 CLAUDE.md。

## 卸载

直接删除 `~/.codex/skills/init-claude-md/` 目录即可。已生成的 CLAUDE.md / TODO.md 不会被删除。

## 可选：装好后跑自检

新会话里说：

> "init CLAUDE.md self-check"

应该看到 Step 8 的 10 项自检清单逐项通过。