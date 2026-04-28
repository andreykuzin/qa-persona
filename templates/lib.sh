#!/usr/bin/env bash
# Shared helpers for qa-persona scenario runners.
# Source this from any scenario script: `source scripts/qa/<flow>-e2e/lib.sh`
#
# Adapt the persona-flavoured action helpers (buyer_*, supplier_*, verify_*)
# to match your platform's API.

API_BASE="${API_BASE:-http://localhost:8000}"

# ---------------------------------------------------------------------------
# Auth
# ---------------------------------------------------------------------------

# get_token <email> <password> → echoes JWT
get_token() {
    local email="$1" pw="$2"
    curl -sf -X POST "$API_BASE/auth/login" \
        -H 'Content-Type: application/json' \
        -d "{\"email\":\"$email\",\"password\":\"$pw\"}" \
        | jq -r '.access_token'
}

# create_or_update_user <admin_token> <email> <name> <company_id> <role> <teams_json> <password>
# Adapt the endpoint + body to your platform's user-management API.
create_or_update_user() {
    local token="$1" email="$2" name="$3" company="$4" role="$5" teams="$6" pw="$7"
    curl -sf -X POST "$API_BASE/admin/users/upsert" \
        -H "Authorization: Bearer $token" \
        -H 'Content-Type: application/json' \
        -d "{
            \"email\": \"$email\",
            \"name\": \"$name\",
            \"company_id\": $company,
            \"role\": \"$role\",
            \"teams\": $teams,
            \"password\": \"$pw\"
        }" > /dev/null
}

# ---------------------------------------------------------------------------
# Persona-flavoured action helpers — adapt per project
# ---------------------------------------------------------------------------

# buyer_create_request <token> <body_json> → echoes new id
buyer_create_request() {
    local token="$1" body="$2"
    curl -sf -X POST "$API_BASE/api/RESOURCE/" \
        -H "Authorization: Bearer $token" \
        -H 'Content-Type: application/json' \
        -d "$body" | jq -r '.id'
}

# buyer_submit_request <token> <id> → echoes status
buyer_submit_request() {
    local token="$1" id="$2"
    curl -sf -X POST "$API_BASE/api/RESOURCE/$id/submit" \
        -H "Authorization: Bearer $token" \
        | jq -r '.status'
}

# supplier_submit_offer <token> <request_id> <body_json> → echoes offer id
supplier_submit_offer() {
    local token="$1" req_id="$2" body="$3"
    curl -sf -X POST "$API_BASE/api/RESOURCE/$req_id/offers" \
        -H "Authorization: Bearer $token" \
        -H 'Content-Type: application/json' \
        -d "$body" | jq -r '.id'
}

# buyer_accept_offer <token> <offer_id> → echoes order id
buyer_accept_offer() {
    local token="$1" offer_id="$2"
    curl -sf -X POST "$API_BASE/api/RESOURCE/offers/$offer_id/accept" \
        -H "Authorization: Bearer $token" \
        | jq -r '.order.id'
}

# ---------------------------------------------------------------------------
# Verification — print the full lifecycle truth table
# ---------------------------------------------------------------------------

# verify_request <id> → prints structured state for grep-asserts
verify_request() {
    local id="$1"
    local data
    data=$(curl -sf "$API_BASE/api/RESOURCE/$id")
    echo "REQUEST $id"
    echo "$data" | jq -r '"  status=\(.status) total=\(.total // 0)"'
    echo "$data" | jq -r '.offers[]? | "  offer \(.id) supplier=\(.supplier_name) status=\(.status) price=\(.price)"'
}

# Convenience: assert grep-pattern matches output, exit 1 if not
assert_contains() {
    local output="$1" pattern="$2"
    if ! grep -q "$pattern" <<< "$output"; then
        echo "FAIL: expected pattern '$pattern' not found in:"
        echo "$output"
        exit 1
    fi
}
