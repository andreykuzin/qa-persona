# For non-Claude-Code agents

This is the qa-persona repo. The methodology is agent-agnostic — only the activation surface differs by tool.

If you're Codex, Cursor, Gemini, Aider, or anything else: read this file, then read `skills/qa-persona/SKILL.md`. You'll have everything you need.

## What this repo is

A persona-driven E2E testing methodology, packaged five ways:

- The **methodology bible** — `skills/qa-persona/SKILL.md`. Five phases, seven scenario categories, the rules that make the whole thing work. Read this first.
- Five **subskills**, one per workflow step, each a self-contained markdown prompt:
  - `skills/qa-persona-init/SKILL.md` — bootstrap a fresh project with stop-and-confirm gates
  - `skills/qa-persona-persona/SKILL.md` — persona CRUD (keeps `personas.md` and `seed-personas.sh` in sync)
  - `skills/qa-persona-iterate/SKILL.md` — map a shipped feature into A–G category coverage
  - `skills/qa-persona-walkthrough/SKILL.md` — drive Layer 2 in a browser; `--parallel` mode dispatches sub-agents per persona for E-category concurrency
  - `skills/qa-persona-bug/SKILL.md` — promote a row from `bugs.md` to a GitHub issue
- **Templates** — `skills/qa-persona/templates/`. Bash and markdown scaffolding you copy and adapt to your platform's auth and endpoints. Independent of any agent.

## How to use without Claude Code

To kick off a fresh project, paste the full content of `skills/qa-persona-init/SKILL.md` into your agent's context and tell it: *apply this skill to the current codebase.* The skill body is a complete prompt — it'll drive Phases 1–4 with stop-and-confirm gates exactly as Claude Code would.

For follow-up actions (CRUD, iterate, walkthrough, bug-promotion), do the same with the corresponding subskill file. Each one stands alone.

The bash templates are platform-independent. You'll need to adapt the API helpers in `lib.sh` to your auth shape and endpoints by hand — there's no autogeneration.

## Activation by agent

| Agent | How to trigger |
|---|---|
| Claude Code | Skills auto-activate on phrases like "set up persona testing." Slash commands available: `/qa-persona:init`, `/qa-persona:persona`, `/qa-persona:iterate`, `/qa-persona:walkthrough`, `/qa-persona:bug`. |
| Codex CLI | Paste the relevant `SKILL.md` content into the prompt context. No native skill loader. |
| Cursor | Reference `skills/qa-persona/SKILL.md` via `@file` in chat. |
| Gemini CLI | Same as Codex — paste the skill content into the system prompt. |
| Custom agent | Read each `SKILL.md` as a self-contained prompt. The `triggers` and `voice-triggers` arrays in frontmatter list phrases that should activate each skill. |

## What this repo isn't

It's not a runtime tool — there's no executable that runs qa-persona for you. The agent runs it. You read the methodology, your agent applies it.

It's not a test framework. The bash templates are scaffolding you adapt; they aren't a generic test runner.

It's not a Playwright wrapper. Layer 2 walkthroughs use whatever browser tool your agent has access to — gstack `/browse`, Playwright, Puppeteer, manual control. Bring your own.

## Layout

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
docs/                              # contributor docs
examples/                          # case study from the original B2B connectivity marketplace
tests/                             # RED / GREEN / PRESSURE skill validation prompts
```

## License

MIT — see [LICENSE](LICENSE).
