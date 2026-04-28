# Examples

## Origin: B2B connectivity marketplace

The methodology was extracted from a working implementation on a B2B connectivity marketplace where buyers request network capacity from suppliers via a multi-supplier RFP flow.

### What was tested

Two-sided marketplace with three primary actor types:
- **Buyers** — request connectivity between two endpoints.
- **Suppliers** — own network infrastructure, publish rate cards, respond with proposals.
- **Platform admin** — setup, impersonation, support.

### Personas used

| Email | Company | Role | Intended use |
|---|---|---|---|
| `persona-buyer@acme.com` | Acme Networks | buyer | Default buyer |
| `persona-buyer@contoso.com` | Contoso Corp | buyer | Second buyer (multi-buyer scenarios) |
| `persona-supplier-1@globex.com` | Globex Telecom | engineer (wholesale team) | Default supplier |
| `persona-supplier-2@initech.com` | Initech Networks | engineer (wholesale team) | Cost-competitive competitor |
| `persona-supplier-3@fabrikam.com` | Fabrikam Infrastructure | engineer (wholesale team) | Premium-SLA competitor |
| `persona-othersegment@globex.com` | Globex Telecom | engineer (consumer team only) | Team-gating tests (must be blocked) |
| `persona-noteam@globex.com` | Globex Telecom | engineer (no team) | Team-gating tests |
| `persona-viewer@globex.com` | Globex Telecom | viewer | Write-block tests (must 403) |
| `admin@platform.example` | — | admin | Setup, impersonation |

### Walkthrough runs

Three runs documented over a 2-week window:

- **Run #1** — Single supplier, API-only on the buyer side. Surfaced **Bug 1**: `accept_proposal` constructed `ServiceOrder` with nonexistent fields → 500. Fixed before Run #2.
- **Run #2** — Single supplier, full UI both sides. Surfaced **Bugs 4 & 5**: auto-fill price used 1km haversine fallback ($112) instead of refusing to seed; auto-fill term used rate card minimum instead of buyer's contract term.
- **Run #3** — Three suppliers competing on the same RFP, full UI both sides. Surfaced new friction: ranking column misses non-price criteria; losing suppliers see "Lost" but no reason or winning price.

### Bugs caught that unit tests missed

| # | Severity | Bug | Why pytest missed it |
|---|---|---|---|
| 1 | Major | `accept_proposal` 500 on field mismatch | No integration test exercised the full accept path with the new ServiceProposal entity |
| 2 | Major | Idempotent `submit` downgrades `fanned_out → no_suppliers` on 2nd call | Pytest tested first-call success, not second-call idempotency |
| 3 | Medium | Submit endpoint doesn't repair `no_suppliers → proposals_in` | Status-machine paths not exhaustively unit-tested |
| 4 | Medium | Auto-fill price used 1km fallback | Fallback was correct in isolation, wrong in lived experience |
| 5 | Medium | Auto-fill `term_months` ignored buyer's `contract_term_months` | Same — algorithm was correct, semantics were wrong |
| 6 | Minor | Buyer company displayed as `#10` instead of name | Cosmetic, no test exercised the display layer |

### Key insights

1. **API-first ordering matters.** Bug 1 and Bug 2 were API bugs that would have been impossible to triage if the browser walkthrough had been done first — confused UI behaviour would have been blamed on the frontend.
2. **Auto-seed friction is invisible to pytest.** Bugs 4 & 5 surfaced as "the supplier had to override the price every time" — a UX problem that only a human-in-the-loop walkthrough catches.
3. **Multi-actor scenarios force tenant-isolation correctness.** Run #3 (three different supplier companies on same RFP) was where ranking gaps and "why did I lose?" feedback gaps surfaced. They were invisible until competing suppliers all logged in on the same deal.

### Reference material

Internal artifacts from the original implementation (private repo):
- Full walkthrough report covering Runs #1–#3.
- Layer-1 bash scaffold used in production at `scripts/qa/marketplace-e2e/`.
- Scenario catalog with status legend.

These were the source material for the templates in this repo.
