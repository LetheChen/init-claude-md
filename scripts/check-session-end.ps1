# Session-end check (PowerShell) — prompts agent to update TODO.md / rule files
# Never modifies files automatically. Output is English-only to avoid
# PowerShell 5.1 codepage issues on Windows (chcp 936 + UTF-8 source).
# See references/session-maintenance-protocol.md for the full decision table.

$ErrorActionPreference = "Stop"

$ROOT = git rev-parse --show-toplevel 2>$null
if (-not $ROOT) { $ROOT = (Get-Location).Path }
$TODO = Join-Path $ROOT "TODO.md"

$RULE_FILE = ""
if (Test-Path (Join-Path $ROOT "CLAUDE.md")) {
    $RULE_FILE = "CLAUDE.md"
} elseif (Test-Path (Join-Path $ROOT "AGENTS.md")) {
    $RULE_FILE = "AGENTS.md"
}

$RULE_FILE_DISPLAY = if ($RULE_FILE) { $RULE_FILE } else { "CLAUDE.md/AGENTS.md" }
$ROOT_DISPLAY = if ($ROOT) { $ROOT } else { "<no project root found>" }

Write-Host "=== Session-end Check ==="
Write-Host ("Project root: " + $ROOT_DISPLAY)
Write-Host ("Rule file   : " + $RULE_FILE_DISPLAY)

if (-not (Test-Path $TODO)) {
    Write-Host ""
    Write-Host "[skip] TODO.md not found (skill init will create it)"
    exit 0
}

$CHANGED = @(git --no-pager diff --name-only HEAD 2>$null).Count
Write-Host ("Changed files: " + $CHANGED)

if ($CHANGED -eq 0) {
    Write-Host "[ok] no source changes, but at least refresh TODO.md date stamp"
}

Write-Host ""
Write-Host "=== Decision table (see references/session-maintenance-protocol.md) ==="
Write-Host ""
Write-Host "1. Completed an item        -> move to [x] Done in TODO.md, append (YYYY-MM-DD)"
Write-Host "2. Found a new issue        -> add to Todo (P1/P2) or Backlog (P3+), include source link"
Write-Host "3. Abandoned an item        -> move to [x] Done, note 'abandoned: <reason>'"
Write-Host "4. New project convention   -> update the matching section in $RULE_FILE_DISPLAY"
Write-Host "5. Refresh 'Last updated: YYYY-MM-DD' (even if nothing else changed)"
Write-Host ""
Write-Host "Full decision table + edge cases: references/session-maintenance-protocol.md"