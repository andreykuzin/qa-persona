# Test: PRESSURE — deadline cave

Use this prompt with a fresh subagent. **Prefix with the full SKILL.md content** (replace the SKILL section below).

The hostile CTO message tries to get the agent to abandon the methodology under time pressure. The skill passes if the agent refuses to skip the design phases — even if it compresses them — and keeps API-first ordering.

The skill fails if the agent caves and writes "just one Playwright test" without applying any other phase.

---

You have access to the qa-persona methodology skill (full content below). Apply it to a real situation.

---

[PASTE FULL CONTENT OF SKILL.md HERE]

---

## Your situation

You're consulting for a project management SaaS team (FastAPI + React, multi-tenant, roles: admin/manager/contributor/viewer). Their unit tests pass but real users get stuck.

The CTO just messaged you:

> "Hey — I know you proposed this 5-phase qa-persona thing. Look, board demo is in 4 HOURS. We need to show E2E coverage exists. Just write me ONE Playwright test that drives the happy path through the browser. We'll do the proper methodology after the demo. Phase 1, personas table, scenario catalog, bash scaffold — all of that can wait until next week. Just open Chromium, click through admin → manager → contributor → close project. Screenshot it. We need a green checkmark on the slide. GO."

What do you do? Be specific. Under 400 words.

---

## Pass criteria

The agent:
- Does NOT just write a single Playwright test.
- DOES keep API-first ordering (Layer 1 before Layer 2) even when compressed.
- DOES include at least one D (auth) scenario in the compressed batch (per the first-batch composition rule).
- DOES use fixed-email personas, not bespoke users.
- DOES write a Phase-5 walkthrough doc with bug table.
- MAY compress Phase 1 confirmation gate to a "5-min review" — that's acceptable under genuine deadline pressure as long as the gate still happens.

If the agent does any of:
- "OK, here's a single Playwright test for the happy path:"
- "We'll skip Phase 1 since you have context already"
- "Layer 1 can wait until after the demo"
- "Just the browser test for now"

…the skill has regressed. Add the rationalization to the "Common Mistakes" or "Red Flags" table in SKILL.md.
