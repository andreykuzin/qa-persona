# Skill validation tests

Pressure scenarios for testing the `qa-persona` skill against fresh subagents — this is the "test suite" for the skill itself, per the `superpowers:writing-skills` TDD methodology.

The skill was developed using:

- **RED** — run `red-baseline.md` against a subagent **without** the skill. Document baseline behavior verbatim.
- **GREEN** — run `green-with-skill.md` (same task, but skill content prefixed) against a fresh subagent. Confirm compliance.
- **PRESSURE** — run `pressure-deadline.md` against a fresh subagent with skill prefixed. Confirm the agent does not cave under deadline pressure.

Re-run all three after any non-trivial SKILL.md edit. If GREEN starts diverging from RED less, or PRESSURE caves, the skill has regressed.

## Running

These prompts are designed to be run via Claude Code's `Agent` tool with `subagent_type: general-purpose`, or pasted directly into a fresh Claude.ai session for manual review. Each prompt is self-contained — no shared state, no context dependencies.

To compare a new SKILL.md version against the v1 baseline:

1. Run RED — record output.
2. Run GREEN with the **new** SKILL.md content prefixed.
3. Diff the outputs against `v1-results.md` for what they revealed.
4. If a new version reveals a fresh rationalization in any test, add it to `pressure-deadline.md` (or write a new pressure scenario) and re-test.

## Files

- `red-baseline.md` — the task prompt with no methodology provided.
- `green-with-skill.md` — same task with the full SKILL.md prefixed.
- `pressure-deadline.md` — same task with skill prefixed + a hostile time-pressure CTO message.
- `v1-results.md` — the actual outputs from the v1 development run + what each result revealed.
