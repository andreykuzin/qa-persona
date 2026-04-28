# Personas

Single source of truth for E2E test personas. Mirrored by `scripts/qa/<flow>-e2e/seed-personas.sh`.

| Email | Company | Role | Teams / Scope | Intended use |
|---|---|---|---|---|
| `persona-buyer@<co1>.com` | <Company A> | <buyer-role> | [<team>] | Default buyer in the value loop |
| `persona-supplier-1@<co2>.com` | <Company B> | <supplier-role> | [<team>] | Default supplier (single-supplier scenarios) |
| `persona-supplier-2@<co3>.com` | <Company C> | <supplier-role> | [<team>] | Second supplier (multi-supplier scenarios) |
| `persona-supplier-3@<co4>.com` | <Company D> | <supplier-role> | [<team>] | Third supplier (RFP / ranking scenarios) |
| `persona-viewer@<co2>.com` | <Company B> | viewer | [<team>] | Auth/isolation: must 403 on all mutations |
| `persona-noteam@<co2>.com` | <Company B> | <supplier-role> | [] | Auth/isolation: must be blocked from team-gated routes |
| `admin@<your-platform>.com` | — | admin | [] | Setup, impersonation, support flows |

## Setup notes

- **Default password** for all personas: `persona` (override via `PERSONA_PW` env var).
- **Admin password**: `admin` (override via `ADMIN_PW`).
- Personas are seeded by `scripts/qa/<flow>-e2e/seed-personas.sh` — idempotent, safe to re-run.
- Every scenario script reuses these emails. No per-test bespoke users.

## Persona-to-scenario mapping

Which personas exercise which categories from `scenarios.md`:

| Category | Personas involved |
|---|---|
| A. Happy paths | `persona-buyer`, `persona-supplier-1..N` |
| B. Lifecycle edges | `persona-buyer`, `persona-supplier-1` |
| C. Input edges | `persona-buyer` |
| D. Auth + isolation | `persona-viewer`, `persona-noteam`, cross-company combinations |
| E. Multi-actor | All |
| F. Adjacent products | `persona-buyer`, sibling-team supplier persona |
| G. Cross-cutting | `admin`, all |

## Adding a new persona

1. Add a row above with email + company + role + scope + intended use.
2. Add a `create_or_update_user` line in `scripts/qa/<flow>-e2e/seed-personas.sh`.
3. Re-run `seed-personas.sh` to idempotently provision.
4. Reference the new email in scenario scripts as needed.
