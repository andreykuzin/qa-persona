---
name: qa-persona-iterate
version: 0.1.0
description: Use after every feature ship to map the new feature into qa-persona coverage — proposes new scenarios across A–G, scaffolds runners, stages the next Run #N skeleton in the walkthrough doc.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Write
  - Edit
  - Bash
  - AskUserQuestion
triggers:
  - qa-persona iterate
  - new feature coverage
  - update persona scenarios
  - feature shipped, update qa
  - append run N
voice-triggers:
  - "feature shipped, update qa"
  - "iterate persona testing"
  - "stage the next run"
---

# qa-persona-iterate

Run after every feature ship. Closes the loop the methodology promises: catalog grows monotonically, walkthrough is appended (never rewritten), bug tracker stays current.

## Inputs

`$ARGUMENTS` — free-form description of the feature that just shipped. If omitted, infer from the current branch diff (`git diff main...HEAD --stat`) and recent commit messages.

## Pre-checks

1. `docs/qa-persona/scenarios.md` exists. If not → tell the user to run `qa-persona-init` first and stop.
2. Detect the flow name from `scripts/qa/<flow>-e2e/`.
3. Detect the current `Run #` by counting `^## Run #` headers in the latest `walkthrough-RUN-*.md` (default: next is current+1).

## Steps

### 1. Identify affected scenarios
Read `docs/qa-persona/scenarios.md`. For each existing scenario ID, decide whether the feature touches it. Output a table:

| Scenario | Affected? | Why |
|---|---|---|
| A1 | yes | feature changes the happy-path lifecycle |
| D1 | no | auth model unchanged |

### 2. Propose new scenarios
For each of the seven categories, ask: does this feature need a NEW scenario in this category? Lean toward **yes** for A (happy path), D (auth/isolation), and G (cross-cutting / audit) — those decay fastest.

Propose new scenario IDs continuing the existing numbering (e.g. if last A is `A2`, propose `A3-<feature-slug>.sh`). Output a second table:

| New ID | Category | Title | Why |
|---|---|---|---|
| A3 | Happy path | multi-assignee task lifecycle | feature: multi-assignee tasks |
| E2 | Multi-actor | concurrent assignee claim race | feature: multi-assignee tasks |

> **STOP. Show both tables to the user. Wait for approval before scaffolding.**

### 3. Scaffold runners
For each approved new scenario:
- Copy `${CLAUDE_PLUGIN_ROOT}/skills/qa-persona/templates/scenario.sh` to `scripts/qa/<flow>-e2e/scenarios/<ID>-<slug>.sh`.
- Replace placeholders: scenario ID, title, persona emails, action sequence skeleton.
- Mark the scenario in `scenarios.md` with status 🔜 → ⚠️ once authored, ✅ once it passes.

### 4. Stage Run #N skeleton
Find the existing `walkthrough-RUN-1.md` (the journal — filename never changes). **Append** (do not rewrite):

```markdown
## Run #N — <feature> (<YYYY-MM-DD>)

**What changed since Run #N-1:**
- <bullet from $ARGUMENTS>

**Personas re-used:** <list>
**Scenarios walked:** <new + affected IDs>

### Findings

✅ **Fixed since Run #N-1:** <bug IDs from bugs.md, or "—">

🐛 **New bugs surfaced:** [filled in during qa-persona-walkthrough]

### BR coverage update

[table]

### Verdict update

[one-paragraph delta]
```

### 5. Update bug tracker delta
In `docs/qa-persona/bugs.md`, add a new `### Run #N (<date>)` section under "Per-run delta" with placeholders `New bugs: —` and `Fixed: —`. The walkthrough fills these in.

## Output

- New `scripts/qa/<flow>-e2e/scenarios/*.sh` files.
- Updated `docs/qa-persona/scenarios.md` with new rows.
- Appended `## Run #N` skeleton in the walkthrough doc.
- New `### Run #N` block in `bugs.md`.

## Red flags — do not do

- Rewriting Run #N-1 instead of appending Run #N.
- Skipping category G when the feature touches a state mutation (audit-log scenarios are the easiest to forget and the ones legal cares about).
- Auto-running the new scenarios without confirming with the user — author first, run via `qa-persona-walkthrough` or `run-all.sh` second.
