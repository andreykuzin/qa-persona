# QA Persona — Scenario Catalog (listmonk)

**Codebase:** https://github.com/knadh/listmonk
**Generated:** 2026-05-12 (dogfood run, Phase 3)
**Source:** [Dogfood report #1](https://github.com/andreykuzin/qa-persona/issues/1)

Tracks which scenario combos have been walked and which are still untested. Each scenario maps to a Layer-1 bash runner under `scripts/qa/listmonk-e2e/scenarios/` once automated.

**Status legend:**
- ✅ automated runner exists and passes
- ⚠️ manually walked once (Layer 2), no Layer-1 runner yet
- 🔜 planned, not run

---

## A. Canonical happy paths

| ID | Scenario | Actors | Status | Notes |
|---|---|---|---|---|
| A1 | Admin creates single-optin list → subscriber submits public form → admin creates + sends campaign → subscriber receives, clicks link, unsubscribes → subscription status `unsubscribed` | admin, subscriber-single | 🔜 | Smallest complete value loop |
| A2 | Admin creates double-optin list → subscriber submits form (status: `unconfirmed`) → subscriber clicks opt-in confirmation link (status: `confirmed`) → admin sends campaign → subscriber receives | admin, subscriber-double | 🔜 | Exercises confirmation email + state transition |

## B. Lifecycle edges

| ID | Scenario | Actors | Status | Notes |
|---|---|---|---|---|
| B1 | Admin starts campaign (`running`) → pauses (`paused`) → resumes (`running`) → campaign finishes (`finished`) | admin | 🔜 | Pause/resume state machine; common source of status bugs |
| B2 | Admin sends campaign to a list with zero confirmed subscribers → campaign completes immediately with `sent_count=0`, no error | admin | 🔜 | Empty-list edge; system should not 500 or hang |

## C. Input edges

| ID | Scenario | Actors | Status | Notes |
|---|---|---|---|---|
| C1 | Subscriber submits public form with malformed email (`not-an-email`) → 422 response, no subscriber record created | subscriber-single | 🔜 | Form validation boundary |

## D. Auth + isolation

| ID | Scenario | Actors | Status | Notes |
|---|---|---|---|---|
| D1 | Editor tries to GET or manage a list outside their `list:manage` scope → 403; editor's campaign list does not show campaigns from other lists | admin (setup), editor | 🔜 | **Must be in first batch.** Permission-boundary correctness |
| D2 | Subscriber self-service page loaded with a tampered UUID (`/subscription/.../<bad-uuid>`) → 404 or sanitized error; no other subscriber's data exposed | subscriber-single | 🔜 | UUID-as-capability; IDOR check |
| D3 | API user with `subscribers:manage` calls campaign-send endpoint → 403 | api-user | 🔜 | API scope isolation |

## E. Multi-actor matrices

| ID | Scenario | Actors | Status | Notes |
|---|---|---|---|---|
| E1 | Two subscribers on overlapping lists (one confirmed, one unconfirmed) receive same campaign; only confirmed subscriber gets the email; analytics show `sent_count=1` | admin, subscriber-single, subscriber-double | 🔜 | Subscription-status filter correctness under overlapping lists |

## F. Adjacent product types

| ID | Scenario | Actors | Status | Notes |
|---|---|---|---|---|
| F1 | *(Not applicable — listmonk has one primary entity type. Mapped to campaign-type variants: optin vs. regular campaign follow same flow with different entity shape. Placeholder pending first batch completion.)* | — | 🔜 | Category F interpreted as campaign-type variant; see dogfood report for rationale |

## G. Cross-cutting / analytics

| ID | Scenario | Actors | Status | Notes |
|---|---|---|---|---|
| G1 | Campaign finishes → subscriber clicks tracked link → `campaign_views` and `link_clicks` records correctly written; admin analytics page shows updated counts | admin, subscriber-single | 🔜 | **Must be in first batch.** Analytics pipeline correctness |
| G2 | Bounce received for subscriber-single (SMTP bounce event) → subscriber status transitions to `blocklisted` → subsequent campaign does not include them in `sent_count` | admin | 🔜 | Bounce→blocklist→exclusion chain; silent bug surface |

---

## First-batch composition

Required rule: first batch must include at least one scenario from categories A, D, and G.

**First batch:** A1 ✅, D1 ✅, G1 ✅ — rule satisfied.

Recommended execution order: D1 → A1 → G1 (auth gates first, then happy path, then analytics pipeline).

---

## Coverage as of 2026-05-12

- **Layer 1 bash runners:** 0 / 11
- **Layer 2 walkthroughs:** 0 documented
- **Open bugs:** 0 (see `bugs.md`)

The goal: every scenario above should have either a passing Layer-1 bash runner or be linked to a walkthrough run that exercised it manually.
