---
name: qa-persona-persona
version: 0.1.0
description: Use when adding, removing, or editing a persona in the qa-persona catalog — keeps personas.md and seed-personas.sh in lockstep, refuses to silently drop emails referenced by scenarios.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Edit
  - AskUserQuestion
triggers:
  - add persona
  - remove persona
  - edit persona
  - update persona table
  - new test persona
voice-triggers:
  - "add a persona"
  - "remove a persona"
  - "edit the persona table"
---

# qa-persona-persona

CRUD on the persona catalog. The single source of truth is `docs/qa-persona/personas.md`; every change here must produce a matching change in `scripts/qa/<flow>-e2e/seed-personas.sh`. The two artifacts must never drift.

## Inputs

`$ARGUMENTS` — free-form. First word is the action (`add`, `remove`, `edit`); the rest describes the change.

Examples:
- `add persona-supplier-4@bigcorp.com BigCorp, supplier role, sales team, RFP scenarios`
- `remove persona-noteam@company-b.com`
- `edit persona-viewer@company-b.com — change role to "auditor"`

## Pre-checks

1. Confirm `docs/qa-persona/personas.md` exists. If not, tell the user to run `qa-persona-init` first and stop.
2. Detect the flow name from `scripts/qa/<flow>-e2e/` — if multiple flows, ask the user which.

## Steps

### `add`
1. Parse email, company, role, team scope, intended use from `$ARGUMENTS`. Ask the user if any field is unclear — do not invent.
2. Append a new row to the persona table in `docs/qa-persona/personas.md`.
3. Append a matching `create_or_update_user` block to `scripts/qa/<flow>-e2e/seed-personas.sh`.
4. Print a 3-line summary: email added, file changes, suggested next step (`./seed-personas.sh` to provision).

### `remove`
1. **Reference scan first.** Grep `scripts/qa/<flow>-e2e/scenarios/` for the email. If any scenario references it:
   - List the offending scenario IDs.
   - Refuse to remove. Tell the user to either re-route those scenarios to a different persona or delete them first.
   - Exit without modifying any file.
2. If no references: delete the row from `personas.md` AND comment out (do not delete) the `create_or_update_user` block in `seed-personas.sh`. Add a one-line comment: `# removed YYYY-MM-DD — was: <email>`. Commenting (vs deleting) preserves the audit trail.
3. Print a 3-line summary.

### `edit`
1. Parse target email + which fields change.
2. Update the row in `personas.md`.
3. Update the matching block in `seed-personas.sh` — same email, changed fields.
4. If the email itself is changing, treat it as `remove` + `add` (with the reference-scan safeguard).
5. Print a 3-line summary.

## Output

- Updated `docs/qa-persona/personas.md`.
- Updated `scripts/qa/<flow>-e2e/seed-personas.sh`.
- Optionally: `personas.md` change diff shown to the user.

## Red flags — do not do

- Silently dropping a `create_or_update_user` line whose email is still grepped by scenarios.
- Inventing a company / role / team scope when `$ARGUMENTS` is ambiguous — ask instead.
- Renaming a persona's email in `personas.md` without also renaming it everywhere it's referenced.
