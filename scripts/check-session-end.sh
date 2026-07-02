#!/usr/bin/env bash
# Session-end check — 提示 agent 是否需要更新 TODO.md / 规则文件
# 不自动改文件，只输出建议（避免 agent 写错）
# 跨平台：Linux / macOS / Git Bash / WSL 都能跑

set -e

# 找项目根
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
TODO="$ROOT/TODO.md"

# 探测规则文件名
RULE_FILE=""
if [ -f "$ROOT/CLAUDE.md" ]; then
  RULE_FILE="$ROOT/CLAUDE.md"
elif [ -f "$ROOT/AGENTS.md" ]; then
  RULE_FILE="$ROOT/AGENTS.md"
fi

echo "=== Session-end Check ==="
echo "项目根: $ROOT"
echo "规则文件: ${RULE_FILE:-<未发现 CLAUDE.md / AGENTS.md>}"

if [ ! -f "$TODO" ]; then
  echo ""
  echo "⚠️  TODO.md 不存在 — 跳过（skill 初始化时会生成）"
  exit 0
fi

# 数改动
CHANGED=$(git diff --name-only HEAD 2>/dev/null | wc -l | tr -d ' ')
echo "本次会话改动文件数: $CHANGED"

if [ "$CHANGED" -eq 0 ]; then
  echo "✅ 无源文件改动 — 至少刷 TODO.md 的日期戳"
fi

echo ""
echo "=== 决策表（来自 references/session-maintenance-protocol.md） ==="
echo ""
echo "1. 完成了某项 → 移到 TODO.md 的 ✅ 段，加 (YYYY-MM-DD)"
echo "2. 发现新问题 → 加到 🟡 (P1/P2) 或 🟢 (P3+)，附源链接"
echo "3. 放弃某项 → 移到 ✅ 段，备注 \"已放弃：<原因>\""
echo "4. 新增项目级约定 → 更新 ${RULE_FILE:-CLAUDE.md/AGENTS.md} 的对应段"
echo "5. 刷新 > 最后更新：YYYY-MM-DD（即使其他都没变）"
echo ""
echo "完整决策表 + 边界 case 见 references/session-maintenance-protocol.md"