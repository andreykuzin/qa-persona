# AGENTS.md

Pointer file for non-Claude-Code agents (Codex, Cursor, Gemini, Aider, custom). qa-persona's methodology is agent-agnostic — only the activation surface differs.

## What this repo provides

- **Methodology bible:** `skills/qa-persona/SKILL.md`. Read this first.
- **Five subskills** (one per workflow step), each a self-contained markdown prompt:
  - `skills/qa-persona-init/SKILL.md` — bootstrap Phases 1–4 with stop-and-confirm gates.
  - `skills/qa-persona-persona/SKILL.md` — persona CRUD (keeps `personas.md` and `seed-personas.sh` in lockstep).
  - `skills/qa-persona-iterate/SKILL.md` — map shipped features into A–G category coverage.
  - `skills/qa-persona-walkthrough/SKILL.md` — drive Layer 2 browser walkthrough; `--parallel` mode for E-category concurrency.
  - `skills/qa-persona-bug/SKILL.md` — promote `bugs.md` rows to GitHub issues.
- **Templates** (bash + markdown) at `skills/qa-persona/templates/`. Copy and adapt — never reference at runtime.

## How to use without Claude Code

1. Read `skills/qa-persona/SKILL.md` end-to-end. The "Five Phases" section is the workflow; the "Common Mistakes" and "Red Flags" tables are the guardrails.
2. To kick off a fresh project, paste the full content of `skills/qa-persona-init/SKILL.md` into your agent's system prompt and tell it: "Apply this skill to the current codebase."
3. For follow-up actions (CRUD, iterate, walkthrough, bug-promotion), do the same with the corresponding subskill file.
4. The bash templates in `skills/qa-persona/templates/` are independent of any agent — they are the Layer-1 scaffold. Adapt them to your platform's auth + endpoints by hand.

## Activation surfaces

| Agent | How to trigger |
|---|---|
| **Claude Code** | Skills auto-activate on phrases like "set up persona testing" / "qa-persona init". Slash commands available: `/qa-persona:init`, `/qa-persona:persona`, `/qa-persona:iterate`, `/qa-persona:walkthrough`, `/qa-persona:bug`. |
| **Codex CLI** | Paste the relevant `SKILL.md` content into the prompt context. No native skill loader. |
| **Cursor** | Reference `skills/qa-persona/SKILL.md` via `@file` in the chat. |
| **Gemini CLI** | Same — paste skill content into the system prompt. |
| **Custom agent** | Read each `SKILL.md` as a self-contained prompt. The `triggers` and `voice-triggers` arrays in frontmatter list phrases that should activate each skill. |

## What this repo is NOT

- Not a runtime tool — there is no executable that runs qa-persona for you. The agent runs it.
- Not a test framework — the bash templates are scaffolding you adapt to your platform, not a generic test runner.
- Not a Playwright wrapper — Layer 2 (browser) walkthroughs use whatever browser tool your agent has access to (gstack `/browse`, Playwright, Puppeteer, manual).

## Structure

```
.claude-plugin/plugin.json         # Claude Code plugin manifest
commands/                          # /qa-persona:* slash command stubs (Claude Code only)
skills/
  qa-persona/                      # parent skill — methodology bible
    SKILL.md
    templates/                     # bash + markdown templates
  qa-persona-init/SKILL.md         # subskill: Phase 1–4 bootstrap
  qa-persona-persona/SKILL.md      # subskill: persona CRUD
  qa-persona-iterate/SKILL.md      # subskill: feature → coverage
  qa-persona-walkthrough/SKILL.md  # subskill: browser walkthrough (+ --parallel)
  qa-persona-bug/SKILL.md          # subskill: bug → GitHub issue
docs/                              # contributor docs (development.md, etc.)
examples/                          # case study from the original B2B fiber marketplace
tests/                             # RED / GREEN / PRESSURE skill validation prompts
```

## License

MIT — see [LICENSE](LICENSE).
