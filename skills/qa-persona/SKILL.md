---
name: qa-persona
version: 0.2.0
description: Use when setting up end-to-end testing for a multi-actor system (marketplace, CRM, workflow tool, project management), when manual QA finds "works in tests but unusable" bugs, when test coverage needs to grow iteratively with each shipped feature, or when unit tests pass but real users get stuck driving the flow.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Edit
  - Write
  - Bash
  - AskUserQuestion
triggers:
  - set up persona testing
  - set up qa-persona
  - persona-driven testing
  - bootstrap e2e for this multi-actor system
  - qa-persona init
voice-triggers:
  - "set up persona testing"
  - "qa persona"
  - "test the value loop"
---

# qa-persona

Persona-driven E2E testing methodology. Studies the codebase, proposes named personas covering the system's value loop, generates testing narratives (happy paths + edge cases), automates them as fast API scenarios, then validates the lived UX via browser walkthrough. The catalog and bug tracker are revisited every new feature.

## Core Principle

Test in two layers, **in this order**:

1. **API-only bash automation FIRST** — fast, deterministic. Proves the business loop closes.
2. **Browser walkthrough SECOND** — catches "works but unusable" UX-only gaps. Once the API is verified, every friction point is genuinely a UX problem (not a confounded backend bug).

The catalog (Markdown) lists every scenario. The bug tracker is a living artifact. Both grow with the product.

## When to Use

- Multi-actor systems where users interact across roles.
- "Unit tests pass but real users get stuck" is a recurring symptom.
- You want test coverage that grows automatically with each feature ship.

**Do NOT use for:** single-user CLI tools, libraries with no UI, pure backend services without human consumers.

## The Five Phases

### Phase 1 — Codebase study

Read enough of the codebase to identify:
- The **value loop** — the one transaction the system exists to enable.
- The **actors** — which user types do what.
- The **artifacts** — which entities flow through the loop.
- The **state transitions** — the lifecycle of each artifact.

Present this back to the user in one paragraph. **Stop and confirm before continuing.**

### Phase 2 — Persona proposal

Propose 3–5 named personas. For each: email, company/team, role, permission scope, intended use ("which part of the loop does this exercise"). Use fixed emails (e.g. `persona-buyer@example.com`) — never per-test bespoke users.

Output to `docs/qa-persona/personas.md` (template: `templates/persona-table.md`). User approves or edits before Phase 3.

### Phase 3 — Narrative authoring

Draft scenarios in 7 categories. Output to `docs/qa-persona/scenarios.md` (template: `templates/scenarios.md`):

- **A. Canonical happy paths** — value loop with 1, 2, 3, N actors.
- **B. Lifecycle edges** — decline, withdraw, idempotent re-submit, retry.
- **C. Input edges** — missing fields, extreme values, empty state.
- **D. Auth + isolation** — viewer cannot mutate, cross-tenant denied, role-gated.
- **E. Multi-actor matrices** — same persona type twice in flight, etc.
- **F. Adjacent product types** — same flow, different entity.
- **G. Cross-cutting** — audit logs, derived records, settlement side effects.

**First-batch composition (5–8 scenarios):** MUST include at least one A, one D, AND one G scenario. D and G are easy to defer ("we'll add audit log tests later") and easy to miss in production. Lock them in from Run #1.

Status legend: ✅ automated runner / ⚠️ walked once, no runner / 🔜 planned.

### Phase 4 — Layer 1 automation (API/bash)

Set up `scripts/qa/<flow-name>-e2e/`:
- `lib.sh` — shared helpers (`get_token`, `<actor>_<verb>`, `verify_<entity>`).
- `seed-personas.sh` — idempotent persona seeding.
- `reset.sh` — wipes domain state (NOT personas) between runs.
- `run-all.sh` — loops `scenarios/*.sh`, tallies PASS/FAIL, exits non-zero on any FAIL.
- `scenarios/A1-*.sh`, `B1-*.sh`, etc. — one runner per scenario.
- `README.md` — persona table + how to run.

Each runner: setup → actors act via curl → `verify_<entity>` prints the lifecycle truth table → grep asserts → exits with `SCENARIO PASSED` or `SCENARIO FAILED`. 10–30s per run.

Templates: `templates/seed-personas.sh`, `templates/lib.sh`, `templates/scenario.sh`, `templates/run-all.sh`, and `templates/reset.sh`.

### Phase 5 — Layer 2 walkthrough (browser)

Once Layer 1 green: drive the canonical scenario through the real UI using a headless browser (Playwright, Puppeteer, gstack `/browse`). Capture screenshots to `evidence/qa-persona/`.

Write `docs/qa-persona/walkthrough-RUN-1.md` (template: `templates/walkthrough-report.md`). For each step: what the persona did, what the system showed, ✅ what worked, ⚠️ friction, 🔴 gaps, 🐛 bugs.

End with: bug table (severity / where / fix sketch), prioritized improvements (P0/P1/P2/P3), business-requirement matrix, verdict.

## Iteration: every new feature

When a feature is deployed:

1. Identify which catalog scenarios the new feature touches.
2. Author new scenarios for the feature itself (Phase 3 categories).
3. Run affected Layer-1 runners. Fix red.
4. Re-walk affected Layer-2 narratives. **Append** `## Run #N — <feature>` to the walkthrough doc; do not rewrite previous runs.
5. Update the bug tracker (`docs/qa-persona/bugs.md`) — add new findings, close fixed ones, verify no regressions.

The catalog grows monotonically. The bug tracker is the running ledger.

**Concrete example:** A project management SaaS ships "multi-assignee tasks." Map: feature touches A1 (happy-path task lifecycle) and E1 (concurrent-claim race). Author **A3-multi-assignee.sh** and **E2-assignee-conflict.sh**. Run `run-all.sh` filtered to `A* E* D*`, fix any red. Re-walk A1+A3 in browser; append `## Run #2 — multi-assignee` to `walkthrough-RUN-1.md` (filename does not change — it's a journal). Update `bugs.md`: add new findings, mark previously-fixed bugs 🟢 with the commit that fixed them.

## Quick Reference

| Artifact | Path | Template |
|---|---|---|
| Personas | `docs/qa-persona/personas.md` | `templates/persona-table.md` |
| Scenarios | `docs/qa-persona/scenarios.md` | `templates/scenarios.md` |
| Bug tracker | `docs/qa-persona/bugs.md` | `templates/bug-tracker.md` |
| Walkthrough | `docs/qa-persona/walkthrough-RUN-N.md` | `templates/walkthrough-report.md` |
| Layer 1 scaffold | `scripts/qa/<flow>-e2e/` | `templates/seed-personas.sh`, `templates/lib.sh`, `templates/scenario.sh`, `templates/run-all.sh`, `templates/reset.sh` |
| Evidence | `evidence/qa-persona/*.png` | (no template) |

## Common Mistakes

| Mistake | Fix |
|---|---|
| Browser walkthrough first, then API | API first. Reversing conflates UX bugs with backend bugs and slows triage. |
| Per-test bespoke users | Reuse fixed-email personas everywhere. One source of truth in `seed-personas.sh`. |
| Rewriting the walkthrough on each feature | Append `## Run #N` instead. The doc is a journal. |
| Skipping the BR matrix | The matrix is what makes "are we done?" answerable. Don't skip. |
| Layer 1 = pytest | No. Pytest covers unit-level. Layer 1 is full-stack integration via curl + DB checks. |
| Auto-fixing bugs found during walkthrough | Log them in the bug tracker first. Fix in a separate session with proper review. |
| Letting Phase 1 skip user confirmation | The value-loop summary is the contract for everything that follows. Always confirm. |

## Red Flags — STOP and reconsider

- "I'll skip Phase 1 and go straight to scenarios" → No. Without the value loop locked, scenarios are arbitrary.
- "Let's do the browser walkthrough first, the API tests are slow to write" → Order matters. API first is non-negotiable.
- "I'll pick personas based on what feels right" → Personas must come from actors observed in the codebase + user approval.
- "We can rewrite the walkthrough doc cleanly each time" → No. Append-only. Past runs are evidence.

## Real-World Origin

Originated in a B2B connectivity marketplace (Supplier ↔ Buyer RFP). Three runs across single-supplier, full-UI, and 3-supplier RFP scenarios surfaced 6 bugs (1 major API 500, 2 medium status-machine bugs, 3 medium/minor UX) and 14 prioritized improvements that no unit test caught. See `examples/README.md` for the full case study.
