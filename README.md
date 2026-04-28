# qa-persona

Persona-driven E2E testing methodology, packaged as a Claude Code skill.

Tests multi-actor systems by walking named personas through the value loop, in two layers:

- **Layer 1 — API automation.** Fast bash scenarios (~10–30s each) that prove the business loop closes. Curl the API, query the DB, assert the lifecycle truth table.
- **Layer 2 — Browser walkthrough.** Headless browser pass that catches "works but unusable" UX gaps the API tests can't see.

Designed to grow with the product: each new feature triggers an iterative pass that revisits affected narratives, appends a new `Run #N` to the walkthrough log, and updates a running bug tracker.

## Why not just Playwright?

Playwright tests UI rendering. This methodology tests **business reality**: did the right actor see the right thing at the right time, and is the resulting data shape something the next workflow can actually use? The narrative walkthrough forces you to write down what was confusing, what was missing, what should have been there. No automation generates that.

## Why API first, browser second?

Because mixing the two layers conflates two failure modes — backend bugs and UX bugs — into one report, which makes triage harder. API-first separates correctness from usability so each layer's feedback is pure:

- **Layer 1 fails** → backend or data-model bug. Fix and rerun.
- **Layer 2 fails** → UX/copy/flow bug. The data is right; the human can't get to it.

## Install

### Claude Code (plugin)

As of v0.2.0, qa-persona is a Claude Code plugin that bundles the skill plus five slash commands.

```bash
# from a marketplace registration (preferred once published):
claude plugin install qa-persona

# or directly from a local checkout:
git clone https://github.com/andreykuzin/qa-persona
claude --plugin-dir ./qa-persona
```

The skill auto-activates on phrases like "set up persona testing" or "qa-persona". The slash commands are user-invokable any time.

### Slash commands and subskills

Five workflow commands, each backed by a self-contained subskill at `skills/qa-persona-<name>/SKILL.md`. Slash commands are namespaced as `/qa-persona:<name>` for explicit invocation; the subskills also auto-activate from natural-language phrases (`triggers` / `voice-triggers` arrays in frontmatter).

| Slash command / Skill | Purpose |
|---|---|
| `/qa-persona:init` / `qa-persona-init` | Bootstrap Phases 1–4 with stop-and-confirm gates. Produces `docs/qa-persona/` + `scripts/qa/<flow>-e2e/`. |
| `/qa-persona:persona` / `qa-persona-persona` | CRUD on personas. Keeps `personas.md` and `seed-personas.sh` in lockstep; refuses to drop emails referenced by scenarios. |
| `/qa-persona:iterate` / `qa-persona-iterate` | After every feature ship: map to A–G categories, scaffold new scenario runners, stage the next `## Run #N` skeleton. |
| `/qa-persona:walkthrough [--parallel]` / `qa-persona-walkthrough` | Drive Layer 2 in a real browser, capture evidence, fill in the Run #N narrative. `--parallel` dispatches per-persona sub-agents for E-category concurrency. Refuses if Layer 1 is red. |
| `/qa-persona:bug` / `qa-persona-bug` | Promote a `bugs.md` row to a GitHub issue via `gh`; back-link the issue number into the bug tracker. Refuses on duplicate promotion. |

### Other agents (Codex, Cursor, etc.)

See [AGENTS.md](AGENTS.md) — pointer file for non-Claude-Code agents. The methodology is agent-agnostic; only the activation mechanism differs. Each `skills/qa-persona-*/SKILL.md` is a self-contained prompt you can paste into any agent.

## Usage

The fastest path:

```
/qa-persona:init
```

Then Claude will:

1. **Phase 1 — Study the codebase** and propose the value loop in one paragraph. Stops for your approval.
2. **Phase 2 — Propose 3–5 named personas** with email, company, role, scope. Stops for your approval.
3. **Phase 3 — Author scenario narratives** covering happy paths and 6 categories of edge cases.
4. **Phase 4 — Build a bash automation scaffold** (Layer 1) — one runner per scenario, idempotent persona seeding, shared helpers.

When Layer 1 is green, run `/qa-persona:walkthrough <IDs>` for Phase 5. After every feature ships, run `/qa-persona:iterate <feature>` to grow coverage. Promote any walkthrough-found bug to GitHub with `/qa-persona:bug <ID>`.

You can also ignore the slash commands entirely and ask Claude in natural language — the skill activates the same way it did pre-plugin.

## What it produces

```
docs/qa-persona/
  personas.md            # Persona table (single source of truth)
  scenarios.md           # Scenario catalog with status legend
  bugs.md                # Running bug tracker
  walkthrough-RUN-1.md   # First walkthrough — appended each run, never rewritten
scripts/qa/<flow>-e2e/
  README.md              # How to run
  lib.sh                 # Shared bash helpers
  seed-personas.sh       # Idempotent seeder
  reset.sh               # Wipe domain state between runs
  run-all.sh             # Loop scenarios, tally PASS/FAIL
  scenarios/             # One runner per scenario (A1, B1, D1, ...)
evidence/qa-persona/
  run-N-<ID>-step-M-{before,after}.png   # Screenshots from browser walkthroughs
```

## When to use

- Multi-actor systems (marketplaces, CRMs, workflow tools, project management).
- "Unit tests pass but real users get stuck" is a recurring problem.
- You want test coverage that grows automatically with features.

## When NOT to use

- Single-user CLI tools.
- Libraries with no UI.
- Pure backend services without human consumers.

## Related work

qa-persona stands on the shoulders of several traditions and overlaps partially with each. None do all of: fixed-email persona catalog + API-first/browser-second ordering + append-only Run #N journal + verified-fixed bug tracker + coverage that grows with each ship.

- **Persona-Based Testing** (manual-QA discipline) — qa-persona inherits the "named actor with goals/frustrations" idea and automates it.
- **BDD / Gherkin / Cucumber / SpecFlow** — "As a &lt;persona&gt;" is canonical, but persona is per-scenario; qa-persona promotes it to a stable catalog.
- **[Karate DSL](https://karatelabs.io/)** — closest non-AI cousin to the unified API+UI layer.
- **[Xray (Jira)](https://www.getxray.app/)** — closest cousin to "coverage tied to releases," but manually curated, not journal-style.
- **[agentmantis/test-skills](https://github.com/agentmantis/test-skills)** — Playwright SDET skills with handover→regression promotion; framework-discipline rather than persona/journal-driven.
- **[firstloophq/claude-code-test-runner](https://github.com/firstloophq/claude-code-test-runner)** — natural-language E2E runner with a Test State MCP for pass/fail; no personas, no two-layer ordering.
- **[wshobson/agents · qa-orchestra](https://github.com/wshobson/agents)** — multi-agent QA with Chrome MCP; orchestrator pattern, single-pass.
- **mabl / Functionize** — closed-source AI-driven exploratory + self-healing; flow-based, no persona catalog or run journal exposed as artifacts.

## Origin

Battle-tested on a B2B fiber marketplace (FiberCo ↔ ISP RFP). Three runs across single-supplier and three-supplier scenarios surfaced 6 bugs and 14 prioritized improvements that no unit test caught. See `examples/README.md` for the full case study.

## License

MIT — see [LICENSE](LICENSE).

## Contributing

PRs welcome. The skill itself was authored as a v1 against a proven methodology but without the full TDD subagent testing cycle that `superpowers:writing-skills` recommends. If you find rationalizations agents use to skip phases, please file an issue with the verbatim quote — that's the gold dust for the next refactor pass.
