# Changelog

All notable changes to qa-persona will be documented here. Format roughly follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.2.0] — 2026-04-28

Promoted from skill to Claude Code plugin.

### Added
- `.claude-plugin/plugin.json` — plugin manifest.
- Five gstack-style subskills at `skills/qa-persona-<name>/SKILL.md`, each with `version`, `allowed-tools`, `triggers`, and `voice-triggers` frontmatter:
  - `qa-persona-init` — Phase 1–4 launcher with stop-and-confirm gates.
  - `qa-persona-persona` — persona CRUD that keeps `personas.md` and `seed-personas.sh` in lockstep.
  - `qa-persona-iterate` — feature → coverage across A–G; stages the next Run #N skeleton.
  - `qa-persona-walkthrough` — Layer 2 driver; refuses if Layer 1 is red. `--parallel` dispatches per-persona sub-agents for E-category concurrency, with explicit persona-isolation contract.
  - `qa-persona-bug` — promotes a `bugs.md` row to a GitHub issue via `gh`; back-links the issue number; refuses duplicate promotion via `(#\d+)` back-link detection or 🟡 status (caught by codex review).
- Five matching slash commands at `commands/<name>.md` (thin stubs that route to the subskills) — namespaced as `/qa-persona:<name>`.
- `AGENTS.md` — pointer file for non-Claude-Code agents (Codex, Cursor, Gemini, Aider).
- Root `skills/qa-persona/SKILL.md` gets `version`, `allowed-tools`, `triggers`, `voice-triggers` frontmatter.
- CI: `validate-plugin` (manifest schema), `validate-commands` (command frontmatter), `validate-subskills` (subskill frontmatter + per-skill name format).

### Changed
- `SKILL.md` moved to `skills/qa-persona/SKILL.md`.
- `templates/` moved to `skills/qa-persona/templates/`. Relative paths in `SKILL.md` still resolve.
- Install instructions: now `claude plugin install qa-persona` (or `--plugin-dir` for local).
- CI paths updated for the new layout.

### Migration
If you cloned v0.1.0 to `~/.claude/skills/qa-persona`, switch to the plugin install. The old skill-only install still works against `skills/qa-persona/SKILL.md` — but the slash commands require the plugin.

## [0.1.0] — 2026-04-28

Initial public release.

### Added
- `SKILL.md` — five-phase methodology with API-first / browser-second layering.
- `templates/` — persona table, scenario catalog, walkthrough report, bug tracker, plus bash scaffold (`lib.sh`, `seed-personas.sh`, `reset.sh`, `run-all.sh`, `scenario.sh`).
- `examples/README.md` — case study from the B2B fiber marketplace where the methodology was distilled.
- `tests/` — RED, GREEN, and PRESSURE pressure-scenarios for skill validation, plus v1 results.
- `docs/development.md` — development log, refactor decisions, open questions.
- CI: shellcheck, frontmatter validation, bash syntax, link checker.

### Validated
- RED baseline (without skill): agent goes Playwright-first, single spec per journey, passive coverage growth.
- GREEN with skill: 5 phases applied, fixed-email personas (with cross-tenant probe), 7-category catalog, API-first preserved, concrete iteration example.
- PRESSURE (4-hour deadline cave attempt): no cave. Agent compressed phases to fit but kept all of them and kept ordering.
