# QA Persona — Persona Table (listmonk)

**Codebase:** https://github.com/knadh/listmonk
**Generated:** 2026-05-12 (dogfood run, Phase 2)
**Source:** [Dogfood report #1](https://github.com/andreykuzin/qa-persona/issues/1)

---

| Email | Company / Context | Role | Teams / Scope | Intended use |
|---|---|---|---|---|
| `persona-admin@listmonk.example` | — | superadmin | all lists, subscribers, campaigns, settings, users | Default admin actor — exercises the full create/send/analytics path |
| `persona-editor@listmonk.example` | Marketing Team | user (custom role) | `campaigns:manage` + `list:manage` on list-newsletter only | Restricted admin-panel user — catches permission-boundary bugs (D1) |
| `persona-subscriber-single@example.com` | — | subscriber (no login, UUID-keyed) | list-newsletter (single opt-in) | Default subscriber — confirms immediately; exercises receive/click/unsubscribe flow |
| `persona-subscriber-double@example.com` | — | subscriber (no login, UUID-keyed) | list-promo (double opt-in) | Exercises opt-in confirmation email + unconfirmed→confirmed state transition |
| `persona-api@listmonk.example` | — | API user (token auth) | `subscribers:manage`, `campaigns:get` | Programmatic subscriber management — catches API auth boundary bugs |

---

> **Note on null-login actors:** `persona-subscriber-*` accounts have no admin-panel login. Their "credentials" are their email address + the UUID listmonk generates on subscription. Seed scripts must capture the UUID from the `subscribers` table after seeding, not from a login call. The persona template's Teams/Scope column is marked with the list assignment and "no login" to distinguish these from role-authenticated actors.
