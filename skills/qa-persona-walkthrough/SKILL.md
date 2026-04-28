---
name: qa-persona-walkthrough
version: 0.1.0
description: Use when driving Layer 2 (browser walkthrough) for one or more catalog scenarios — captures screenshots into evidence/, fills in the Run #N narrative. Optional --parallel mode dispatches per-persona sub-agents for genuine concurrency on E-category scenarios.
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash
  - Edit
  - Write
  - Agent
  - AskUserQuestion
triggers:
  - qa-persona walkthrough
  - drive browser walkthrough
  - layer 2 testing
  - run scenario in browser
  - parallel persona walkthrough
voice-triggers:
  - "walk through this scenario"
  - "drive the browser"
  - "run layer 2"
---

# qa-persona-walkthrough

Drive a Layer 2 (browser) walkthrough for the named scenarios. Captures screenshots into `evidence/qa-persona/` and fills in the Run #N narrative skeleton that `qa-persona-iterate` staged.

**Pre-condition:** Layer 1 (`run-all.sh`) for the same scenarios is green. If Layer 1 is red, refuse — fix backend first; mixing layers conflates UX and backend bugs.

## Inputs

`$ARGUMENTS` — scenario IDs space-separated, or `all`. Optional trailing `--parallel` flag.

Examples:
- `A1` — single canonical happy path
- `A1 D1 G1` — Run #1 first-batch composition
- `all` — re-walk every catalog scenario
- `E1 E3 --parallel` — concurrent multi-actor scenarios with one sub-agent per persona

## When to use `--parallel`

Default is sequential — one Claude drives every persona in turn. That's correct for A/B/C/F/G scenarios where the test is "did the lifecycle close cleanly," not "did concurrent actors race."

Use `--parallel` when **the scenario itself is about concurrency** — i.e. when sequential walkthrough literally cannot exercise the codepath under test:

- **E-category scenarios** (multi-actor matrices). E1 = two buyers submitting identical requests; E3 = same supplier splitting inventory across two simultaneous deals. Sequential = Claude races itself, which doesn't actually exercise the system's concurrency handling.
- **D-category scenarios where auth isolation is the assertion.** Sequential walkthrough has the coordinator carrying god-mode knowledge across personas; the viewer "test" is really "Claude pretends not to use admin knowledge." A real viewer sub-agent has no admin context to leak from.

For everything else, sub-agent overhead exceeds the benefit. Default to sequential.

## Pre-checks

1. `docs/qa-persona/scenarios.md` exists.
2. Each requested ID exists in the catalog. Refuse on unknown IDs.
3. **Layer 1 green check:** run `scripts/qa/<flow>-e2e/run-all.sh '<filter matching $ARGUMENTS>'`. If any FAIL, stop and tell the user. Do NOT proceed to browser.
4. Detect browser tooling, in this order:
   - `gstack` slash command available (`/browse`) → preferred.
   - `npx playwright` resolves → use it.
   - `puppeteer` in node_modules → use it.
   - Otherwise → ask the user which tool to use.
5. Detect the dev server URL (`README.md`, `package.json` scripts, `.env`). If unclear, ask.

## Steps (sequential mode)

For each scenario in `$ARGUMENTS`:

### 1. Read the scenario
Read `scripts/qa/<flow>-e2e/scenarios/<ID>-*.sh` to extract the persona sequence and the assertion shape (what state should exist at the end). The browser walkthrough mirrors this sequence in the UI.

### 2. Drive the UI
For each persona action in the scenario:
- Log in as the persona.
- Take a screenshot **before** acting → `evidence/qa-persona/run-N-<ID>-step-M-before.png`.
- Perform the action.
- Take a screenshot **after** → `evidence/qa-persona/run-N-<ID>-step-M-after.png`.
- Note in your working memory: what was visible, what was friction, what was missing, what surprised you.

### 3. Verify the lived experience
At the scenario's end, the UI state should match what `verify_<entity>` would print. If it doesn't, that's a Layer-2-only bug (the data is right, the UI lies about it).

### 4. Fill in the Run #N narrative
Open the walkthrough doc (latest `walkthrough-RUN-*.md`). Find the `## Run #N` skeleton staged by `qa-persona-iterate` (or create one if missing). For each scenario walked, append:

```markdown
### <ID> — <persona> does <action> (UI: /<route>)

`<persona>` logged in. <What was visible — sidebar, page state, copy, response timing.>

✅ **What worked:** <concrete observation with quoted UI copy or numbers>
⚠️ **Friction:** <list>
🔴 **Gap (design vs reality):** <if any>
🐛 **Bug:** <symptom + repro + severity + fix sketch — short>
```

### 5. Update bugs.md
For every 🐛 logged: add a new row to `docs/qa-persona/bugs.md` with a stable ID, severity, where, fix sketch, status `🔴`. The new bug IDs go into the Run #N "New bugs surfaced" line.

### 6. Update BR coverage + verdict
Fill in the BR coverage table delta and write a one-paragraph verdict: did the value loop close end-to-end in the browser, yes or no, and what's blocking if no.

## Parallel mode — sub-agent dispatch

When `--parallel` is set:

### 1. Identify personas in the scenario
For each `$ARGUMENTS` scenario, read `scripts/qa/<flow>-e2e/scenarios/<ID>-*.sh` and extract every persona email referenced. Group by email — one sub-agent per distinct persona.

### 2. Dispatch sub-agents in a single message
Use the Agent tool with `subagent_type: general-purpose`. **All sub-agents launched in one message run concurrently** — that's the only way to test real concurrency. Each prompt MUST include the persona-isolation contract verbatim:

> You are persona `<email>`. You have ONLY this persona's credentials, view, and history. You do NOT know any other persona's password, session token, internal state, or recent actions. If a step requires information another persona holds, you must obtain it via the system's normal channels (notifications, broadcast, polling) — never out-of-band. If you cannot complete a step using only your persona's view, log it as 🔴 "missing UX affordance" and proceed.

Each sub-agent prompt also includes:
- The scenario spec (the relevant section of `scripts/qa/<flow>-e2e/scenarios/<ID>-*.sh`).
- Their persona's email + login URL + dev-server base URL.
- Their dedicated evidence subdirectory: `evidence/qa-persona/run-N-<ID>/<persona-slug>/` (one per persona — prevents filename collisions when multiple personas screenshot the same UI route at the same wall-clock).
- The browser tool to use (gstack/playwright/puppeteer — same detection as sequential mode).
- An explicit reporting contract: return JSON with `{step, ts, what_worked, friction, gaps, bugs}` for each action taken, plus screenshot paths.

### 3. Coordinator synthesis
After all sub-agents return, the coordinator (you, in this conversation):
- Merges per-persona reports into one Run #N narrative, ordered by timestamp.
- Cross-references the timestamps to identify race-condition findings ("buyer accepted at 12:00:03; supplier did not see 'won' notification until 12:00:11 — 8s gap is a UX-grade bug").
- For D-category isolation tests: explicitly note any 403 / "blocked" outcomes from the restricted persona — these are PASS evidence, not failures.
- Writes new bugs to `docs/qa-persona/bugs.md` and the narrative into the walkthrough doc as in sequential mode.

### 4. Caveats to surface to the user
- Token cost is roughly N × sequential cost where N = personas. For 3-supplier RFP, that's ~4× a sequential run. Worth it for E-scenarios; flag it in the summary so the user knows.
- Cross-agent timing is approximate — sub-agent wall-clock is not synchronized. For sub-second race assertions, instrument the API to emit timestamps that `verify_<entity>` returns; don't rely on screenshot mtime.
- Sub-agent prompts cannot enforce isolation perfectly (model may still draw on training). The persona-isolation contract above is best-effort; treat findings as "more honest than sequential," not "perfectly isolated."

## Red flags — do not do

- Skipping the Layer 1 green check. The whole methodology is built on API-first.
- Auto-fixing bugs found during the walkthrough. **Log them. Fix in a separate session with proper review.** Walkthroughs are observation, not patching.
- Rewriting an earlier `## Run #` section. Append-only.
- Compressing all screenshots into one file. One per before/after step — they're evidence, the file count is the proof.
