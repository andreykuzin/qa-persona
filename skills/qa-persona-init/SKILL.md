---
name: qa-persona-init
version: 0.1.0
description: Use when bootstrapping persona-driven E2E testing on a fresh codebase — runs Phases 1–4 (codebase study → personas → scenario catalog → Layer 1 bash scaffold) with stop-and-confirm gates.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Edit
  - Bash
  - AskUserQuestion
triggers:
  - bootstrap qa-persona
  - qa-persona init
  - set up persona testing
  - phase 1 codebase study
  - propose value loop
voice-triggers:
  - "bootstrap qa-persona"
  - "set up persona testing"
  - "study the codebase for testing"
---

# qa-persona-init

Bootstrap persona-driven E2E testing on the current codebase. Drives Phases 1–4 of the qa-persona methodology with explicit stop-and-confirm gates.

For the full methodology, the rationale, and the scenario-category definitions, follow the parent skill at `${CLAUDE_PLUGIN_ROOT}/skills/qa-persona/SKILL.md`. This skill is the launcher; the parent is the bible.

## Inputs

`$ARGUMENTS` — optional flow name (used for `scripts/qa/<flow>-e2e/` directory). If omitted, derive one from the codebase (e.g. `marketplace`, `tasks`, `crm`).

## What it produces

```
docs/qa-persona/
  personas.md
  scenarios.md
  bugs.md
scripts/qa/<flow>-e2e/
  README.md
  lib.sh
  seed-personas.sh
  reset.sh
  run-all.sh
  scenarios/      (empty — populated as Phase 4 progresses)
```

Templates live at `${CLAUDE_PLUGIN_ROOT}/skills/qa-persona/templates/`. Copy and adapt — never reference them at runtime.

## Steps

### Phase 1 — Codebase study
Read enough source to identify the **value loop**, **actors**, **artifacts**, and **state transitions**. Present back to the user in **one paragraph**.

> **STOP. Wait for the user to confirm or correct the value-loop summary before continuing. This is the contract for everything that follows.**

### Phase 2 — Persona proposal
Propose 3–5 named personas based on actors observed in the codebase. Use the schema from `templates/persona-table.md`. Fixed emails (`persona-<role>@<co>.com`) — never per-test bespoke users. Write to `docs/qa-persona/personas.md`.

> **STOP. Wait for user approval or edits before continuing.**

### Phase 3 — Scenario catalog
Author 5–8 scenarios across the seven categories (A–G). **First batch MUST include at least one A, one D, AND one G.** Status legend: ✅ / ⚠️ / 🔜. Write to `docs/qa-persona/scenarios.md` using `templates/scenarios.md`.

### Phase 4 — Layer 1 scaffold
Create `scripts/qa/<flow>-e2e/` from the bash templates (`lib.sh`, `seed-personas.sh`, `reset.sh`, `run-all.sh`). Replace `FLOW_NAME` and adapt API helpers to match the platform's actual auth + endpoints. Do NOT yet write per-scenario `.sh` files — those come from `qa-persona-iterate` or hand-authoring.

## Red flags — do not skip

- Skipping Phase 1's stop-and-confirm gate.
- Picking personas "based on what feels right" instead of from observed actors.
- Deferring categories D or G past the first batch.
- Inventing a scenario catalog without the user agreeing on the value loop first.

## After this

Run `qa-persona-iterate <feature>` whenever a feature ships, and `qa-persona-walkthrough` once Layer 1 is green.
