# Content rules — what to put in, what to leave out

## Always include in root CLAUDE.md

- The 4 Karpathy rules (compressed to 1-2 lines each)
- Detected package manager + test + typecheck + lint commands
- Branch + commit + PR workflow (if detectable)
- A runnable verification command
- 3-5 hard "do not" rules specific to THIS project

## Never include in root CLAUDE.md

| Don't write | Why |
|---|---|
| "This is a TypeScript project" | Trivial, agent can detect |
| Full directory tree | Stale immediately, bloats file |
| Architecture overview / module descriptions | Belongs in README, not agent rules |
| "Follow best practices" | Untestable, ignored |
| "Write clean code" | Untestable, ignored |
| "Use TypeScript strict mode" | Already in tsconfig |
| "Add tests" | Generic, not actionable |
| LLM cheerleading ("you are a senior engineer") | Adds noise |
| Lists of every npm script | Read from package.json |
| Code style rules covered by the linter | Duplicates config |

## Always include in rule files

- WHY the rule exists (one line)
- The specific, verifiable rule
- A code example showing good vs bad (optional but powerful)
- The failure mode if violated (for anti-patterns)

## Never include in rule files

- Generic advice (e.g. "handle errors properly")
- Behavior that should be enforced by the linter
- The same rule that's already in root (split, don't duplicate)
- Implementation tutorials (those go in the code as comments)

## Tone

- Imperative, terse, second-person implicit
- Use "Do X" not "You should consider X"
- Use "Never X" for hard bans, "Avoid X" for soft guidance
- No apologies, no hedging ("perhaps consider...")

## Specificity test

Before including a rule, ask:

1. Can a machine check this? (e.g. "use 2-space indent" — yes)
2. If not, can a reviewer verify it in 5 seconds? (e.g. "always return early on errors" — yes)
3. If not, throw the rule out. (e.g. "be thoughtful" — no)

## The "3 AM test"

If a tired developer reads this rule at 3 AM, can they act on it without thinking? If no, rewrite.

## Self-edit cadence

- Every rule that gets ignored twice in practice → delete or rewrite.
- Every rule that produces zero questions → keep.
- Once root CLAUDE.md approaches 200 lines → split to rules/ before adding more.
