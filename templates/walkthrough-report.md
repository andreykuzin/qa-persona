# E2E Persona Walkthrough — Run #1

**Date:** <YYYY-MM-DD>
**Personas used:**
- `<persona-buyer>@<company>.com` — <role> at <Company>
- `<persona-supplier-1>@<company>.com` — <role> at <Company>
- `admin@<platform>.com` — platform admin (setup only)

**Reference design:** `<link to spec/design doc, if any>`

**Outcome:** <one-line summary, e.g. "REQ-001 → Supplier A wins → ORD-001 ($X / N months)">

This report walks step by step through what each persona did, what the system showed, what worked, and what was friction. It compares *intended* design against *actual* lived experience and surfaces improvement areas.

---

## 1. The story we tested

<One paragraph: who, what, why. Real names, real numbers, concrete context.>

---

## 2. Step-by-step

### Step 1 — <persona> does <action> (UI: `/<route>`)

`<persona>` logged in. <What was visible — sidebar, page state, copy, response timing.>

✅ **What worked:** <concrete observation with quoted UI copy or numbers>

⚠️ **Friction:**
- <confusing copy / wrong default / missing context>
- <another friction point>

🔴 **Gap (design vs reality):** <design says X, UI does not do X yet>

🐛 **Bug:** <symptom + repro + severity + fix sketch — short>

### Step 2 — <next persona / next action>

<Same shape>

[... repeat for each step ...]

---

## 3. Bugs surfaced

| # | Severity | Bug | Where | Fix sketch |
|---|---|---|---|---|
| 1 | Major | <one-line description> | `<file:line>` | <one-line fix> |
| 2 | Medium | <one-line description> | `<file:line>` | <one-line fix> |
| 3 | Minor | <one-line description> | `<file:line>` | <one-line fix> |

All MUST land before the next walkthrough. Logged in `bugs.md` with stable IDs.

---

## 4. Required improvements

### P0 — Blocks demos

1. <improvement with rationale>
2. <improvement>

### P1 — Operational glue

1. <improvement>

### P2 — UX polish

1. <improvement>

### P3 — Deferred (settlement / etc.)

1. <improvement>

---

## 5. Business-requirement reality check

Mapping back to `<spec doc>` requirements:

| BR | Intended | Actual today | Gap |
|---|---|---|---|
| BR-1 | <requirement> | ✅ / ⚠️ / 🔴 | <what's missing> |
| BR-2 | <requirement> | ✅ / ⚠️ / 🔴 | <what's missing> |

**Net:** <X of N requirements satisfied. Top remaining gaps: ...>

---

## 6. Verdict

<Does the value loop close end-to-end in the browser? One paragraph. State explicitly whether a real user could complete this transaction without intervention.>

---

## 7. Evidence

Screenshots in `evidence/qa-persona/`:
- `run-1-step-1.png` — <description>
- `run-1-step-2.png` — <description>
- `run-1-step-3.png` — <description>

Database final state:
```
<copy-paste of final state from verify_<entity> output>
```

---

## Run #2 — <feature shipped> (<YYYY-MM-DD>)

[Append new run sections here. Do NOT rewrite Run #1.]

**What changed since Run #1:**
- <feature / fix>

**Personas re-used:** <same as Run #1, or note new ones>

### Findings

✅ **Fixed since Run #1:** <bug references>

🐛 **New bugs surfaced:** <log in bugs.md, list IDs here>

### BR coverage update

| BR | After Run #1 | After Run #2 |
|---|---|---|
| BR-1 | ⚠️ | ✅ |

### Verdict update

<One paragraph on the delta from Run #1 to Run #2.>

---

## Run #3 — ...

[Continue appending. Each run is dated, named after the trigger feature, and updates BR coverage + bug tracker. Past runs are evidence and stay intact.]
