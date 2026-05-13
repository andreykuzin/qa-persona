# Bug Tracker — listmonk

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
| — | — | — | — | *(No bugs logged yet — walkthroughs have not run)* | — | — | — |

---

## Open count by severity

- **Major:** 0
- **Medium:** 0
- **Minor:** 0
- **Deferred (P3):** 0

---

## Per-run delta

*(No runs yet. First walkthrough will populate this section.)*

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
