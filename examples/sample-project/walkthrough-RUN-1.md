# E2E Persona Walkthrough — Run #1 (listmonk)

> **Status: STRUCTURAL PLACEHOLDER**
> The dogfood run (2026-05-12) executed Phases 1–3 only. This file is the Phase-5 skeleton — the shape a real walkthrough report takes, pre-populated with listmonk-specific context. Fill in the step-by-step and evidence sections after running Layer-1 bash runners and conducting the browser walkthrough.

**Date:** *(to be filled on first real run)*
**Trigger:** First walkthrough — baseline run against listmonk HEAD
**Personas used:**
- `persona-admin@listmonk.example` — superadmin
- `persona-editor@listmonk.example` — marketing editor (restricted role)
- `persona-subscriber-single@example.com` — subscriber, list-newsletter (single opt-in)
- `persona-subscriber-double@example.com` — subscriber, list-promo (double opt-in)
- `persona-api@listmonk.example` — API user (token auth)

**Reference design:** https://listmonk.app/docs/ — listmonk official documentation

**Outcome:** *(to be filled — e.g. "campaign-newsletter-001 sent → subscriber-single receives, clicks, unsubscribes; analytics records written")*

---

## 1. The story we tested

*(Fill in after run: who did what, with what list/campaign names and IDs, in what order.)*

Example shape: `persona-admin` creates `list-newsletter` (single opt-in), seeds `persona-subscriber-single` via the public subscription form, authors `campaign-newsletter-001`, sends it. `persona-subscriber-single` receives the email (captured in test SMTP inbox), clicks the tracked link, then clicks the unsubscribe link. Admin checks analytics: `sent_count=1`, `link_clicks=1`, `unsubscribe_count=1`. Then `persona-editor` attempts to access `list-promo` (outside scope) — expects 403.

---

## 2. Step-by-step

### Step 1 — persona-admin creates list-newsletter (UI: `/lists`)

*(Fill in after run.)*

✅ **What worked:** *(quote exact UI copy or API response)*

⚠️ **Friction:**
- *(document anything confusing, slow, or requiring workaround)*

🔴 **Gap (design vs reality):** *(design says X, actual behavior is Y)*

🐛 **Bug:** *(symptom + repro + severity + fix sketch — short)*

### Step 2 — persona-subscriber-single submits public subscription form (UI: `/subscription/form`)

*(Fill in after run.)*

### Step 3 — persona-admin creates and sends campaign-newsletter-001 (UI: `/campaigns`)

*(Fill in after run.)*

### Step 4 — persona-subscriber-single receives email, clicks tracked link, unsubscribes

*(Fill in after run — check test SMTP inbox for received email, extract UUID-keyed self-service URL.)*

### Step 5 — persona-admin reviews analytics (UI: `/campaigns/<id>`)

*(Fill in after run — verify `sent_count`, `views`, `link_clicks` are correctly recorded.)*

### Step 6 — persona-editor attempts out-of-scope list access (UI: `/lists`, API: `GET /api/lists`)

*(Fill in after run — confirm 403 and that campaign list is scoped correctly.)*

### Step 7 — persona-subscriber-single self-service page with tampered UUID (D2)

*(Fill in after run — load `/subscription/<list-uuid>/<bad-uuid>`, confirm 404 or sanitized error, no other subscriber data leaked.)*

---

## 3. Bugs surfaced

| # | Severity | Bug | Where | Fix sketch |
|---|---|---|---|---|
| — | — | *(no bugs logged yet)* | — | — |

All bugs MUST land in `bugs.md` with stable IDs before the next walkthrough.

---

## 4. Required improvements

### P0 — Blocks demos

*(Fill in after run.)*

### P1 — Operational glue

*(Fill in after run.)*

### P2 — UX polish

*(Fill in after run.)*

### P3 — Deferred

*(Fill in after run.)*

---

## 5. Business-requirement reality check

| BR | Intended | Actual today | Gap |
|---|---|---|---|
| BR-1 | Single opt-in list: subscriber confirms immediately on form submit | *(fill)* | *(fill)* |
| BR-2 | Double opt-in list: subscriber must click confirmation email before status → `confirmed` | *(fill)* | *(fill)* |
| BR-3 | Campaign analytics: `sent_count`, `views`, `link_clicks` correctly incremented | *(fill)* | *(fill)* |
| BR-4 | Editor role cannot access or modify lists outside assigned scope | *(fill)* | *(fill)* |
| BR-5 | UUID-keyed self-service pages do not expose other subscribers' data | *(fill)* | *(fill)* |
| BR-6 | API user with `subscribers:manage` scope cannot trigger campaign sends | *(fill)* | *(fill)* |
| BR-7 | Bounce events trigger subscriber status → `blocklisted`; subsequent campaigns exclude them | *(fill)* | *(fill)* |

**Net:** *(X of 7 requirements satisfied. Top remaining gaps: ...)*

---

## 6. Verdict

*(Fill in after run: does the value loop close end-to-end? Can a real admin send a campaign, and can a real subscriber receive, click, and unsubscribe without intervention?)*

---

## 7. Evidence

Screenshots in `evidence/qa-persona/`:
- *(fill in after run — one entry per key step screenshot)*

Database final state:
```
*(copy-paste from final subscriber/campaign query after run)*
```

---

## Run #2 — *(next feature shipped)* (*(date)*)

[Append new run sections here. Do NOT rewrite Run #1.]

**What changed since Run #1:**
- *(feature / fix)*

**Personas re-used:** same as Run #1

### Findings

✅ **Fixed since Run #1:** *(bug references)*

🐛 **New bugs surfaced:** *(log in bugs.md, list IDs here)*

### BR coverage update

| BR | After Run #1 | After Run #2 |
|---|---|---|
| BR-1 | *(fill)* | *(fill)* |

### Verdict update

*(One paragraph on the delta from Run #1 to Run #2.)*
