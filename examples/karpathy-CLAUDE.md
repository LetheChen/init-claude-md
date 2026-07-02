# CLAUDE.md

## Session Maintenance Protocol

**At session start:** read `TODO.md`, summarize `🔴 In progress` and `🟡 Todo`, confirm what to push this session.

**At session end (before stopping, after last user message):**

1. **Review what THIS session actually changed** — files modified, issues found, new constraints
2. **Update `TODO.md`** per decision table (see `references/session-maintenance-protocol.md`):
   - Completed → move to `✅ Done (YYYY-MM-DD)`
   - New issue → add to `🟡 Todo` (P1/P2) or `🟢 Backlog` (P3+)
   - Abandoned → move to `✅ Done` with `abandoned: <reason>`
3. **Update this file's rules** IF the session revealed new conventions:
   - Repeated user corrections → add to `## Things to avoid`
   - Repeatedly failed commands → fix `## Verification`
   - Hidden conventions → add to `## Project conventions`
4. **Refresh date stamp** `> Last updated: YYYY-MM-DD` (even if nothing else changed)

**Trigger** (any of): ≥1 source file changed · user added new constraints · session > 10 min

> Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don'\''t assume. Don'\''t hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don'\''t pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what'\''s confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn'\''t requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don'\''t "improve" adjacent code, comments, or formatting.
- Don'\''t refactor things that aren'\''t broken.
- Match existing style, even if you'\''d do it differently.
- If you notice unrelated dead code, mention it - don'\''t delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don'\''t remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user'\''s request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.