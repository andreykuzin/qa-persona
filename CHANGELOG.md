# Changelog

All notable changes to qa-persona will be documented here. Format roughly follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

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
