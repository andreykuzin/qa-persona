#!/usr/bin/env bash
# Idempotent persona seeding — re-run any time to reset persona state.
# Adapt the create_or_update_user calls to match your platform's user-mgmt API.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
source scripts/qa/FLOW_NAME-e2e/lib.sh

API_BASE="${API_BASE:-http://localhost:8000}"
ADMIN_PW="${ADMIN_PW:-admin}"
PERSONA_PW="${PERSONA_PW:-persona}"

echo "Seeding personas against $API_BASE ..."

# 1. Get admin token (admin must already exist via dev seed)
ADMIN_TOKEN=$(get_token "admin@your-platform.com" "$ADMIN_PW")

# 2. Personas — one create_or_update_user call per row in docs/qa-persona/personas.md
# Args: <admin_token> <email> <name> <company_id> <role> <teams_json> <password>

create_or_update_user "$ADMIN_TOKEN" \
    "persona-buyer@company-a.com" "Persona Buyer" \
    1 "buyer" '[]' "$PERSONA_PW"

create_or_update_user "$ADMIN_TOKEN" \
    "persona-supplier-1@company-b.com" "Persona Supplier 1" \
    2 "supplier" '["sales"]' "$PERSONA_PW"

create_or_update_user "$ADMIN_TOKEN" \
    "persona-supplier-2@company-c.com" "Persona Supplier 2" \
    3 "supplier" '["sales"]' "$PERSONA_PW"

create_or_update_user "$ADMIN_TOKEN" \
    "persona-supplier-3@company-d.com" "Persona Supplier 3" \
    4 "supplier" '["sales"]' "$PERSONA_PW"

create_or_update_user "$ADMIN_TOKEN" \
    "persona-viewer@company-b.com" "Persona Viewer" \
    2 "viewer" '["sales"]' "$PERSONA_PW"

create_or_update_user "$ADMIN_TOKEN" \
    "persona-noteam@company-b.com" "Persona No-Team" \
    2 "supplier" '[]' "$PERSONA_PW"

echo "✓ All personas seeded"
echo ""
echo "Quick login test:"
get_token "persona-buyer@company-a.com" "$PERSONA_PW" > /dev/null && echo "  ✓ buyer login works"
get_token "persona-supplier-1@company-b.com" "$PERSONA_PW" > /dev/null && echo "  ✓ supplier-1 login works"
