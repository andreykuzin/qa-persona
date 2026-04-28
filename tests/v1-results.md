# v1 development run — test results

Captured 2026-04-28 during initial skill development. All three scenarios run via Claude Code `Agent` tool with `subagent_type: general-purpose`, sonnet/opus equivalent.

---

## RED baseline (no skill)

**What the agent did without methodology:**

- Jumped straight to **Playwright** as the test framework. No API-only layer.
- Proposed personas (`aliceAdmin`, `bobManager`, `carolContributor`, `vickyViewer`) — implicitly named, but as TypeScript fixtures, not a Markdown source-of-truth doc.
- One spec file per user journey (`01-onboard-workspace.spec.ts`, `03-task-lifecycle.spec.ts`, etc.) — no scenario catalog with edge categories.
- "Coverage matrix" as a single `COVERAGE.md` file. Empty cells = visible debt. PR template enforces growth.
- Build order: seed → auth → ONE journey spec → matrix → rest. **Browser-first, no API tier.**
- First action: "trace one full journey through the actual UI as a real user, while reading the corresponding routes." → **browser walkthrough as discovery, then Playwright tests.**

**Gaps the skill needs to close:**

1. No API-first / browser-second layering — agent went straight to Playwright.
2. No 7-category scenario catalog — only happy + cross-role implicit.
3. No append-only Run #N walkthrough — single spec files, no journal.
4. No bug tracker as a living artifact.
5. No Phase 1 stop-for-confirmation — straight into planning.
6. Coverage growth is **passive** (PR template + empty cells), not active (re-run trigger on every feature ship).

---

## GREEN with skill (compliance)

**What the agent did with the methodology in context:**

- Wrote **value-loop paragraph** in Phase 1: "a manager turns intent into completed work." Closed with **"Stop here and confirm with user before Phase 2."** ✓
- Proposed **5 fixed-email personas** including a bonus cross-tenant probe (`Otto Outsider @globex.test`) that wasn't asked for — went beyond the instruction. ✓
- 7-category catalog with concrete IDs: A1, A2, B1, C1, D1, D2, E1. **Deferred G** ("audit log of close-project event — added once Layer 1 is green") — minor gap that drove a refactor (see below). ⚠️
- Layer-1 directory layout matched templates: `lib.sh`, `seed-personas.sh`, `reset.sh`, `run-all.sh`, `scenarios/`. ✓ Note: `run-all.sh` was an emergent invention that wasn't in the original templates → drove a template addition.
- API-first ordering preserved: "Once Layer 1 is fully green, drive A1+A2+D1 through the real React UI headless." ✓
- Concrete iteration example: "feature: multi-assignee tasks → touches A1, E1 → author A3, E2 → run-all filtered → re-walk in browser → **append Run #2, never rewrite Run #1**." ✓

**Gaps surfaced for v1 refactor:**

1. Agent deferred category G past the first batch. Skill needed to **mandate** A + D + G in the first 5–8 scenarios (added as "first-batch composition" rule).
2. Agent invented `run-all.sh` independently — useful, should be in templates (added).
3. Agent invented `reset.sh` — also useful, should be in templates (added).
4. Iteration paragraph was abstract — concrete example added to SKILL.md showing `multi-assignee → A3, E2`.

---

## PRESSURE deadline cave

**What the agent did when the CTO demanded a single Playwright test in 4 hours:**

The agent's response (verbatim opening): *"Short answer: I'll get you the green checkmark, but not the way you asked. Here's what you'll have in 4 hours and why."*

It then:

- **Refused to skip layers**: "Writing a single Playwright happy-path test first ... is the slowest path to a defensible green checkmark."
- **Compressed Phases 1+2** to 1 hour (no formal gate, but explicit 5-min review): *"I'll show you the paragraph + persona table at the 1-hour mark. 5-min review, not a formal gate."*
- **Hours 2–3: Phase 4 Layer 1** with **3 scenarios** including D1 (auth boundary) and B1 (lifecycle edge), explicitly: *"the demo question someone WILL ask."* ✓ (matches the first-batch composition rule)
- **Hour 4: Phase 5 Layer 2** — one Playwright run + screenshots + walkthrough doc with P0/P1 bug table.
- **Reframed the slide**: *"E2E coverage: 3 scenarios green (happy path, auth boundary, lifecycle edge). Layer 1 deterministic CLI suite + Layer 2 browser walkthrough with screenshots. Suite re-runnable in 60 seconds." That sentence survives a hostile board question. "One Playwright test passing" does not.*
- **Pragmatic safety valve**: *"If at hour 2 Layer 1 is slipping, I cut to A1-only and ship the Playwright screenshot. You still get the checkmark. But I'm not starting there — starting there is how we end there."*

**Verdict:** PRESSURE passed. No cave, no skipped phases. The compression of the Phase-1 gate from "stop and confirm" to "5-min review" is acceptable under genuine deadline pressure since the gate still happens.

**No refactor needed from this run.** If a future test reveals the agent caving (e.g., starting with "OK, here's a single Playwright test ..."), that rationalization should be added to SKILL.md's "Red Flags" table.
