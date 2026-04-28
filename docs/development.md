# Development log

## v1 — 2026-04-28

### Origin

Methodology extracted from a B2B fiber-leasing marketplace (FiberCo ↔ ISP RFP). Three persona walkthroughs across single-supplier, full-UI, and 3-supplier-RFP scenarios surfaced 6 bugs (1 major API 500, 2 medium status-machine bugs, 3 medium/minor UX) and 14 prioritized improvements that no unit test caught.

Original implementation lives in the source repo at:
- `scripts/qa/marketplace-e2e/` — Layer 1 bash scaffold
- `docs/superpowers/specs/2026-04-27-e2e-walkthrough-experience.md` — full Run #1–#3 walkthrough report

The v1 skill packaged the structural pieces (5 phases, 7 scenario categories, two-layer ordering, append-only journal, bug tracker) without baking in the fiber-marketplace domain.

### Test-driven development

Followed the `superpowers:writing-skills` TDD pattern: RED baseline (no skill) → GREEN with-skill → PRESSURE (deadline cave attempt). Full prompts, results, and what each revealed are in `tests/`.

### Refactor decisions

| Refactor | Triggered by | What changed |
|---|---|---|
| First-batch composition rule (must include A + D + G) | GREEN deferred category G past first batch | Added explicit rule in Phase 3 |
| `run-all.sh` template | GREEN agent invented this spontaneously — useful | Added to `templates/` and Phase 4 |
| `reset.sh` template | GREEN agent invented this spontaneously | Added to `templates/` and Phase 4 |
| Concrete iteration example in SKILL.md | Iteration paragraph was abstract | Added "multi-assignee → A3, E2" example |

PRESSURE test passed without revealing further loopholes. If a future run shows the agent caving, the verbatim rationalization should be captured in SKILL.md's "Red Flags" or "Common Mistakes" table.

### CI

Four jobs validate every push:

1. **shellcheck** on `templates/` (severity: warning)
2. **frontmatter validation** — name format, `Use when` description prefix, <1024 byte frontmatter
3. **bash -n syntax check** on each `.sh` template
4. **link checker** for `templates/...` references in SKILL.md (literal filenames only — brace expansion is rejected to prevent false-resolved paths)

### Skill vs plugin

Shipped as a single Claude Code skill (`SKILL.md` with frontmatter + supporting templates). Could be upgraded to a plugin if it grows to include slash commands (e.g. `/qa-persona-walkthrough` for an interactive walkthrough launcher), hooks (e.g. post-deploy hook that suggests appending Run #N), or a bundled MCP browser-control server. v1 has none of those, so a skill is correct.

### Schedule

A one-time remote agent fires 2026-05-12T03:00:00Z to dogfood the skill against a fresh public codebase (RealWorld / Listmonk / Excalidraw / Cal.com), apply Phases 1–3 only, and post a structured `Dogfood report` issue back to this repo. Routine ID: `trig_01Exq1ihUYs3gxq6x7x67mMr`. Manage at https://claude.ai/code/routines/trig_01Exq1ihUYs3gxq6x7x67mMr.

The dogfood deliverable will reveal real-codebase gaps that the synthetic project-management test couldn't.

## Open development questions

- Should there be a slash command (`/qa-persona`) for explicit invocation? Current activation is keyword-triggered ("set up persona testing", "qa-persona"). Slash command would require upgrading to a plugin.
- Should `reset.sh` be more opinionated about transactional safety (e.g. wrap in a savepoint)? Current template is `BEGIN; ...; COMMIT;` which is the minimum.
- Should the bug tracker be machine-readable (JSON / YAML) so CI can auto-block merges that don't reference a fixed bug ID? Current template is human-readable Markdown only.
- Is "first-batch composition: A + D + G" the right trio, or should B (lifecycle) also be mandatory? PRESSURE test included B naturally; GREEN test didn't. Open question.
