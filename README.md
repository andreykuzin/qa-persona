# qa-persona

[![CI](https://github.com/andreykuzin/qa-persona/actions/workflows/ci.yml/badge.svg)](https://github.com/andreykuzin/qa-persona/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/github/v/tag/andreykuzin/qa-persona?label=version)](https://github.com/andreykuzin/qa-persona/releases)

End-to-end testing for multi-user SaaS apps, driven by AI-generated personas with goals, scope, and a point of view. Catches the bugs unit tests can't.

## The problem

You ship a feature. Pytest passes. CI is green. You demo it internally and everything looks fine.

A real customer opens it the next morning and gets stuck on step three.

This happens because unit tests answer "does this function return the right value." They don't answer "did the right person see the right thing at the right time, and could they actually do something useful with it." That second question is where SaaS apps with more than one type of user — buyers and sellers, admins and managers and contributors, requesters and approvers — go wrong.

The gap is bigger than people think. On the B2B fiber marketplace this methodology was extracted from, three persona walkthroughs surfaced six bugs that 200+ pytest tests had missed: a 500 in the accept-proposal path, two status-machine bugs that only triggered on the second idempotent call, three UX bugs that were technically "working" but unusable in practice.

If your tests live in `tests/test_*.py` and your bugs live in customer support tickets, the gap between them is what qa-persona is for.

## What it does

qa-persona tests your app the way real users would use it.

You don't write `test_create_request_returns_201`. You write a persona — Sarah, the network engineer at EZECOM, who has $8k/month to spend and needs fiber capacity to a new POP — and an AI agent drives Sarah through your system end to end. First through the API (fast, deterministic, proves the business loop closes). Then through the browser (catches the "works but unusable" UX gaps the API tests can't see).

Each persona is a real character, not a credential:

- **An intent.** Sarah is trying to get fiber installed under budget. She's not trying to "POST a JSON body."
- **A fixed identity.** `persona-isp@ezecom.com` is the same Sarah in every test run. The product evolves; she stays — so coverage compounds across releases instead of starting over.
- **A scope.** Sarah can't see what BigCorp's account is doing. If she can, that's a bug. The persona-isolation rules catch it.
- **A point of view.** When Sarah gets stuck, *that's the test signal.* "I couldn't tell which supplier won my deal" is a finding. Pytest can't tell you that. A persona walking the flow can.

Three to five personas usually cover the value loop. The catalog grows with the product: every new feature ship triggers an iterative re-run that revisits affected personas, appends a new run to the walkthrough log, and updates the bug tracker. The catalog never shrinks.

## How the two layers fit together

Tests run in two layers, in this order:

1. **API automation first.** Fast bash scenarios, ~10–30 seconds each, that prove the business loop actually closes. Curl the API, query the DB, assert the lifecycle truth table. If a Layer 1 fails, it's a backend bug — full stop.

2. **Browser walkthrough second.** Once Layer 1 is green, drive the same scenario through the real UI in a headless browser. Anything that fails here is a UX bug — the data is right, the human can't get to it.

Mixing the two layers conflates failure modes. API-first separates correctness from usability so each layer's feedback is pure.

## Install (Claude Code)

qa-persona is shipped as a Claude Code plugin. Three install paths, in order of how often they're the right answer:

**User-level (recommended — works across every project):**
```bash
git clone https://github.com/andreykuzin/qa-persona.git \
  ~/.claude/plugins/cache/local/qa-persona
```
Then add `~/.claude/plugins/cache/local/qa-persona` to `pluginPaths` in `~/.claude/settings.json`.

**Per-project:**
```bash
git clone https://github.com/andreykuzin/qa-persona.git .claude/plugins/qa-persona
```

**Marketplace (once published):**
```bash
claude plugin install qa-persona
```

For Codex / Cursor / Gemini / any other agent, see [AGENTS.md](AGENTS.md) — every skill in this repo is a self-contained markdown prompt you can paste in.

## Requirements

Most of qa-persona is markdown — your agent reads it and applies it. Specific commands rely on a few external tools:

| Need it for | What |
|---|---|
| Layer 1 bash templates (`lib.sh`, `seed-personas.sh`, scenario runners) | `bash`, `curl`, `jq` |
| `reset.sh` against a Postgres dev DB | `docker` (or adapt to your local psql) |
| `/qa-persona:walkthrough` | A headless browser tool — gstack `/browse`, Playwright, or Puppeteer. The skill auto-detects what's available; ask the user if it can't decide. |
| `/qa-persona:walkthrough --parallel` | The Agent tool (Claude Code only — sub-agents are how concurrency is tested) |
| `/qa-persona:bug` | `gh` CLI, authenticated against your repo's GitHub remote |

The plugin doesn't install any of these for you. Things will fail loudly if a command is missing — the SKILL.md pre-checks call it out before doing destructive work.

## Commands

Five workflow steps, available as both slash commands and natural-language skills:

| Slash command | Skill name | What it does |
|---|---|---|
| `/qa-persona:init` | `qa-persona-init` | Bootstrap on a fresh codebase. Studies the repo, proposes the value loop, gates for your approval, then proposes 3–5 personas, then a scenario catalog covering happy paths and six categories of edge cases, then scaffolds the bash automation. |
| `/qa-persona:persona` | `qa-persona-persona` | Add, remove, or rename a persona. Keeps `personas.md` and `seed-personas.sh` in lockstep. Refuses to drop a persona whose email is still referenced by scenarios. |
| `/qa-persona:iterate` | `qa-persona-iterate` | Run after every feature ship. Maps the new feature into the catalog, proposes new scenarios, scaffolds runners, and stages the next run skeleton in the walkthrough doc. |
| `/qa-persona:walkthrough` | `qa-persona-walkthrough` | Drive the browser pass. Add `--parallel` for multi-actor scenarios where one Claude can't honestly race itself — dispatches one sub-agent per persona with strict isolation. |
| `/qa-persona:bug` | `qa-persona-bug` | Promote a bug from the running ledger to a GitHub issue via `gh`, back-link the issue number, refuse on duplicates. |

The shortest possible kickoff:

```
/qa-persona:init
```

You'll get the value-loop summary, then approve or correct it. Personas come next, then scenarios, then the bash scaffold. Three stop-and-confirm gates, on purpose — the methodology is built around pausing before commitment because the most expensive class of test-suite mistakes is the silent one.

## What gets created on disk

```
docs/qa-persona/
  personas.md            # Persona table — single source of truth
  scenarios.md           # Scenario catalog with status legend
  bugs.md                # Running bug tracker
  walkthrough-RUN-1.md   # The walkthrough journal — appended each run, never rewritten

scripts/qa/<flow>-e2e/
  README.md              # How to run
  lib.sh                 # Shared bash helpers
  seed-personas.sh       # Idempotent persona seeder
  reset.sh               # Wipe domain state between runs (preserves personas)
  run-all.sh             # Loop scenarios, tally PASS/FAIL
  scenarios/             # One runner per scenario (A1, B1, D1, ...)

evidence/qa-persona/
  run-N-<ID>-step-M-{before,after}.png   # Screenshots from browser walkthroughs
```

## When it fits

Use qa-persona when:

- Your app has more than one type of user with different goals.
- Your unit tests pass but real users still get stuck.
- You want test coverage that grows as you ship, instead of decaying.
- Marketplace, CRM, project-management tool, workflow tool, multi-tenant SaaS — anything with a value loop that requires multiple actors to close.

Don't use it for:

- Single-user CLI tools.
- Libraries with no UI.
- Pure backend services without human consumers.

## Related work

qa-persona stands on traditions and overlaps with each. None do all of: a fixed-email persona catalog + API-first / browser-second ordering + an append-only run journal + a verified-fixed bug tracker + coverage that grows with each ship.

- **Persona-Based Testing** (manual-QA discipline) — qa-persona inherits the "named actor with goals and frustrations" idea and automates it.
- **BDD / Gherkin / Cucumber / SpecFlow** — "As a &lt;persona&gt;" is canonical, but the persona is per-scenario; qa-persona promotes it to a stable catalog.
- **[Karate DSL](https://karatelabs.io/)** — closest non-AI cousin to the unified API+UI layer.
- **[Xray (Jira)](https://www.getxray.app/)** — closest cousin to "coverage tied to releases," but manually curated, not journal-style.
- **[agentmantis/test-skills](https://github.com/agentmantis/test-skills)** — Playwright SDET skills with handover→regression promotion; framework-discipline rather than persona/journal-driven.
- **[firstloophq/claude-code-test-runner](https://github.com/firstloophq/claude-code-test-runner)** — natural-language E2E runner with a Test State MCP for pass/fail; no personas, no two-layer ordering.
- **[wshobson/agents · qa-orchestra](https://github.com/wshobson/agents)** — multi-agent QA with Chrome MCP; orchestrator pattern, single-pass.
- **mabl / Functionize** — closed-source AI-driven exploratory + self-healing; flow-based, no persona catalog or run journal exposed as artifacts.

## Security model

qa-persona drives shell execution (the bash scaffold is sourced and run) and asks for credentials (persona logins, gh auth). A few things to know:

- **Persona passwords come from environment variables**, not the codebase. The templates use `${PERSONA_PW}` and `${ADMIN_PW}` with safe defaults; production credentials never go in `seed-personas.sh`. If you set a real password, set it in your shell or `.env` — not in the file.
- **The bash templates are scaffolding**, not vendored runtime code. You read what's there, adapt the API helpers to your platform, and commit the result. The plugin never executes anything you haven't reviewed.
- **`gh` auth is reused, not requested.** `/qa-persona:bug` calls `gh issue create` against whichever auth `gh auth status` already has. The plugin doesn't ask for, store, or transmit tokens.
- **No telemetry.** The plugin makes no network calls of its own. `gh` and your browser tool are the only outbound connections, and only when you invoke a command that uses them.
- **`--parallel` walkthroughs spawn sub-agents** via the Agent tool, each scoped to one persona's view by prompt. The persona-isolation contract is best-effort (model-level), not OS-level — treat findings as "more honest than sequential," not formally isolated.

If you find an injection vector, credential leak, or anything else security-relevant, please email or open a private security advisory rather than a public issue.

## Why not just Playwright?

Playwright tests UI rendering. This methodology tests business reality — did the right actor see the right thing at the right time, and is the resulting data shape something the next workflow can actually use. The narrative walkthrough forces you to write down what was confusing, what was missing, what should have been there. No automation generates that.

You can absolutely use Playwright as the Layer-2 driver. qa-persona is a methodology, not a framework — bring whatever browser tool you already trust.

## Origin

Battle-tested on a B2B fiber marketplace where ISPs request dark-fiber capacity from FiberCos via a multi-supplier RFP flow. Three persona walkthroughs across single-supplier, full-UI, and three-supplier scenarios surfaced six bugs and fourteen prioritized improvements that no unit test caught. See [examples/README.md](examples/README.md) for the case study with bug-by-bug detail.

## License

MIT — see [LICENSE](LICENSE).

## Contributing

PRs welcome. The first version was written against a proven methodology, not the full TDD subagent testing cycle that `superpowers:writing-skills` recommends. If you find rationalizations agents use to skip phases, file an issue with the verbatim quote — that's the gold dust for the next refactor pass.
