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

### Claude Code

```bash
git clone https://github.com/<you>/qa-persona ~/.claude/skills/qa-persona
```

The skill activates when you ask Claude to "set up persona testing", "qa-persona", or similar phrases.

### Other agents (Codex, Cursor, etc.)

Read `SKILL.md` directly. The methodology is agent-agnostic — only the activation mechanism differs.

## Usage

In Claude Code:

```
Set up persona-driven E2E testing for this project.
```

Claude will:

1. **Phase 1 — Study the codebase** and propose the value loop in one paragraph. Stops for your approval.
2. **Phase 2 — Propose 3–5 named personas** with email, company, role, scope. Stops for your approval.
3. **Phase 3 — Author scenario narratives** covering happy paths and 6 categories of edge cases.
4. **Phase 4 — Build a bash automation scaffold** (Layer 1) — one runner per scenario, idempotent persona seeding, shared helpers.
5. **Phase 5 — Drive a browser walkthrough** (Layer 2) and write a dated narrative report with screenshots, bug table, priority list, and BR matrix.

After the first pass, every new feature triggers an iterative re-run that appends a new `Run #N` to the walkthrough doc and updates the bug tracker.

## What it produces

```
docs/qa-persona/
  personas.md            # Persona table (single source of truth)
  scenarios.md           # Scenario catalog with status legend
  bugs.md                # Running bug tracker
  walkthrough-RUN-1.md   # First walkthrough
  walkthrough-RUN-2.md   # Appended after first feature ship
  ...
scripts/qa/<flow>-e2e/
  README.md              # How to run
  lib.sh                 # Shared bash helpers
  seed-personas.sh       # Idempotent seeder
  scenarios/             # One runner per scenario
evidence/qa-persona/
  *.png                  # Screenshots from browser walkthroughs
```

## When to use

- Multi-actor systems (marketplaces, CRMs, workflow tools, project management).
- "Unit tests pass but real users get stuck" is a recurring problem.
- You want test coverage that grows automatically with features.

## When NOT to use

- Single-user CLI tools.
- Libraries with no UI.
- Pure backend services without human consumers.

## Origin

Battle-tested on a B2B fiber marketplace (FiberCo ↔ ISP RFP). Three runs across single-supplier and three-supplier scenarios surfaced 6 bugs and 14 prioritized improvements that no unit test caught. See `examples/README.md` for the full case study.

## License

MIT — see [LICENSE](LICENSE).

## Contributing

PRs welcome. The skill itself was authored as a v1 against a proven methodology but without the full TDD subagent testing cycle that `superpowers:writing-skills` recommends. If you find rationalizations agents use to skip phases, please file an issue with the verbatim quote — that's the gold dust for the next refactor pass.
