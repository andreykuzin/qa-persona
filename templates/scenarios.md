# QA Persona — Scenario Catalog

Tracks which combos have been walked and which are still untested. Each scenario should map to a Layer-1 bash runner under `scenarios/` once automated.

**Status legend:**
- ✅ automated runner exists and passes
- ⚠️ manually walked once (Layer 2), no Layer-1 runner yet
- 🔜 planned, not run

---

## A. Canonical happy paths

| ID | Scenario | Status | Notes |
|---|---|---|---|
| A1 | Single supplier — buyer submits, supplier acts, buyer accepts | 🔜 | Smallest possible value loop |
| A2 | Two suppliers compete; buyer picks cheapest | 🔜 | First multi-actor scenario |
| A3 | Three suppliers compete; buyer picks middle (price/SLA/speed tradeoff) | 🔜 | RFP shape |
| A4 | N suppliers, buyer rejects all, then re-runs with adjusted request | 🔜 | Cycle through |

## B. Lifecycle edges

| ID | Scenario | Status | Notes |
|---|---|---|---|
| B1 | Supplier declines a draft (with reason) | 🔜 | |
| B2 | Supplier submits, then withdraws before close | 🔜 | |
| B3 | Supplier tries to withdraw after close → 409 | 🔜 | Negative test |
| B4 | Buyer rejects each submitted offer one by one | 🔜 | |
| B5 | Idempotent re-submit of a request | 🔜 | Common bug source |
| B6 | Re-trigger on stale state (e.g. supplier opens broadcast → re-fan-out) | 🔜 | |

## C. Input edges

| ID | Scenario | Status | Notes |
|---|---|---|---|
| C1 | Canonical complete input (covered by A1) | 🔜 | |
| C2 | One required field at limit / missing → graceful failure | 🔜 | |
| C3 | Extreme values (very large, very small, zero, negative) | 🔜 | |
| C4 | Empty state (no input → status `no_input` or 422) | 🔜 | |

## D. Auth + tenant isolation

| ID | Scenario | Status | Notes |
|---|---|---|---|
| D1 | Viewer cannot mutate (POST/PUT/DELETE → 403) | 🔜 | |
| D2 | Admin without scope/impersonation cannot mutate (→ 400) | 🔜 | |
| D3 | Cross-tenant resource access denied (Company A user → Company B resource) | 🔜 | |
| D4 | Buyer A cannot see Buyer B's history | 🔜 | |
| D5 | Team-gated route blocks no-team persona | 🔜 | |

## E. Multi-actor matrices

| ID | Scenario | Status | Notes |
|---|---|---|---|
| E1 | Two buyers submit identical requests; same suppliers compete on both; deals close independently | 🔜 | Tenant isolation under load |
| E2 | One supplier wins for buyer A, loses for buyer B (different price strategies) | 🔜 | |
| E3 | Same supplier splits inventory across two simultaneous deals | 🔜 | Inventory reservation |

## F. Adjacent product types

| ID | Scenario | Status | Notes |
|---|---|---|---|
| F1 | Sibling product follows same flow with different entity | 🔜 | |
| F2 | Variant pricing model (subscription vs. one-time) | 🔜 | |

## G. Cross-cutting / settlement

| ID | Scenario | Status | Notes |
|---|---|---|---|
| G1 | Accepted action produces correct downstream record (order, contract, invoice) | 🔜 | |
| G2 | Audit log captures actor, action, timestamp on every mutation | 🔜 | |
| G3 | Inventory / capacity reservation on accept | 🔜 | |

---

## Coverage as of <YYYY-MM-DD>

- **Layer 1 bash runners:** 0 / N
- **Layer 2 walkthroughs:** 0 documented
- **Open bugs:** 0 (see `bugs.md`)

The goal: every scenario above should have either a passing Layer-1 bash runner or be linked to a walkthrough run that exercised it manually.
