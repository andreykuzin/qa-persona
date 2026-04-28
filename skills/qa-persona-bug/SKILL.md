---
name: qa-persona-bug
version: 0.1.0
description: Use when promoting a row from docs/qa-persona/bugs.md to a GitHub issue via gh CLI; back-links the issue number into the bug tracker row. Refuses if the bug was already promoted.
allowed-tools:
  - Read
  - Edit
  - Bash
  - AskUserQuestion
triggers:
  - qa-persona bug
  - promote bug to github
  - file github issue from bug tracker
  - escalate qa bug
voice-triggers:
  - "promote this bug"
  - "file an issue for bug"
  - "escalate the bug to github"
---

# qa-persona-bug

Promote one bug row from `docs/qa-persona/bugs.md` to a GitHub issue and back-link the issue number into the bug tracker. Closes the loop between the walkthrough's Markdown ledger and the team's actual issue tracker.

## Inputs

`$ARGUMENTS` — the stable bug ID (the `#` column in `bugs.md`). One ID at a time. Refuse if multiple are passed — promote them one by one so commit messages stay clean.

## Pre-checks

1. `docs/qa-persona/bugs.md` exists.
2. `gh` CLI is available (`gh --version`). If not → tell the user to install it (`brew install gh` / `winget install GitHub.cli`) and stop.
3. `gh auth status` shows authenticated. If not → tell the user to run `gh auth login` and stop.
4. Find the row matching the ID. If absent → list available IDs and stop.
5. Inspect the row — refuse if **any** of these is true:
   - Status is already 🟢 (fixed) — promoting a fixed bug as a new open issue is wrong.
   - Status is already 🟡 (in progress / tracked) — almost certainly already promoted.
   - The `Bug` column contains a back-link of the form `(#<digits>)` — definitive proof of prior promotion.
   - The `Fixed in` column already references an issue.

   Note: `Fixed in` alone is not a reliable signal — step 4 below intentionally leaves it empty until a later walkthrough verifies the fix landed. Check the back-link in the `Bug` column or the 🟡 status as the primary "already promoted" indicators.

## Steps

### 1. Build the issue body
From the bug row, construct an issue with this shape:

```
Title: [qa-persona bug #<ID>] <one-line description>

Body:
**Severity:** <Major|Medium|Minor>
**Discovered:** <YYYY-MM-DD> (qa-persona Run #<N>)
**Where:** `<file:line>`

**Description**
<full description from bugs.md>

**Fix sketch**
<fix sketch from bugs.md>

**Walkthrough context**
See `docs/qa-persona/walkthrough-RUN-<latest>.md` Run #<N>.

---
*Filed via qa-persona-bug — back-linked into `docs/qa-persona/bugs.md`.*
```

### 2. Pick labels
Map severity → label:
- `Major` → `bug,severity:major`
- `Medium` → `bug,severity:medium`
- `Minor` → `bug,severity:minor,good-first-issue`

If a label doesn't exist in the repo, fall back to `bug` only — never abort on a missing label.

### 3. Create the issue
```bash
gh issue create \
  --title "[qa-persona bug #<ID>] <one-line>" \
  --body-file <tmpfile> \
  --label "<labels>"
```
Capture the resulting issue URL and number.

### 4. Back-link into bugs.md
Update the row in `docs/qa-persona/bugs.md`:
- Append `(#<issue-number>)` to the `Bug` column, e.g. `Idempotent submit downgrades status (#42)`.
- Update status `🔴` → `🟡` (in progress, since it's now tracked).
- Leave `Fixed in` empty until a later walkthrough confirms 🟢.

### 5. Print summary
```
✓ Filed issue #42: <title>
  URL: <url>
  bugs.md row updated: status 🔴 → 🟡, back-link added
  Next: qa-persona-walkthrough after the fix lands to verify and mark 🟢.
```

## Red flags — do not do

- Promoting bugs that are already 🟢 (fixed) or already linked to an issue.
- Inventing severity / fix-sketch text not present in `bugs.md` — the issue must reflect the ledger faithfully.
- Closing the bug row in `bugs.md` when the issue is filed. The bug closes only when a later walkthrough confirms it's gone — that's the methodology's verification rule.
- Creating the issue with `gh issue close --reason completed` to "skip ahead." Never. The issue lifecycle mirrors the bug lifecycle.
