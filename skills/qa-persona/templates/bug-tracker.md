# Bug Tracker

Living ledger of issues surfaced by qa-persona walkthroughs. Updated on every `Run #N`.

**Status legend:**
- 🟢 fixed and verified in a later run
- 🟡 in progress
- 🔴 open
- ⚪ deferred (P3, won't fix near-term)

---

## All bugs

| # | Discovered | Status | Severity | Bug | Where | Fix sketch | Fixed in |
|---|---|---|---|---|---|---|---|
| 1 | <YYYY-MM-DD> | 🔴 | Major | <description> | `<file:line>` | <fix> | — |
| 2 | <YYYY-MM-DD> | 🟢 | Medium | <description> | `<file:line>` | <fix> | commit `<sha>` |
| 3 | <YYYY-MM-DD> | ⚪ | Minor | <description> | `<file:line>` | <fix> | P3 deferred |

---

## Open count by severity

- **Major:** <count>
- **Medium:** <count>
- **Minor:** <count>
- **Deferred (P3):** <count>

---

## Per-run delta

### Run #1 (<YYYY-MM-DD>)

- New bugs: #1, #2, #3
- Fixed: —

### Run #2 (<YYYY-MM-DD>)

- New bugs: #4
- Fixed: #2 (commit `abc123`)
- Regressions: none

### Run #3 (<YYYY-MM-DD>)

- New bugs: —
- Fixed: #1 (commit `def456`)
- Regressions: none

---

## Rules

1. **Every bug gets a stable ID.** Never renumber.
2. **Every fix references the commit** in the `Fixed in` column.
3. **Every run must verify previous fixes did not regress.** Note regressions explicitly in the per-run delta.
4. **Severity definitions:**
   - **Major:** 5xx error, data corruption, blocks the value loop.
   - **Medium:** wrong status transition, wrong data shape, friction-but-completable.
   - **Minor:** copy / display / cosmetic.
5. **Close on verification, not on commit.** A bug is 🟢 when a later walkthrough confirms it's gone — not just when the fix is merged.
