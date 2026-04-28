#!/usr/bin/env bash
# Scenario A1 — Single supplier happy path
# Buyer submits → Supplier offers → Buyer accepts → assert order created.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
source scripts/qa/FLOW_NAME-e2e/lib.sh

PERSONA_PW="${PERSONA_PW:-persona}"

echo "=== Scenario A1: single-supplier happy path ==="

# 1. Setup pre-conditions (login as each persona)
BUYER_TOKEN=$(get_token "persona-buyer@company-a.com" "$PERSONA_PW")
SUPPLIER_TOKEN=$(get_token "persona-supplier-1@company-b.com" "$PERSONA_PW")

# 2. Buyer creates and submits the request
RID=$(buyer_create_request "$BUYER_TOKEN" '{
    "fieldA": "valueA",
    "fieldB": 123,
    "fieldC": "describe what is being requested"
}')
echo "Created request $RID"

STATUS=$(buyer_submit_request "$BUYER_TOKEN" "$RID")
echo "After submit, request status = $STATUS"

# 3. Supplier submits an offer
OID=$(supplier_submit_offer "$SUPPLIER_TOKEN" "$RID" '{
    "price": 9800,
    "term_months": 36,
    "notes": "Standard offer for A1 test"
}')
echo "Supplier submitted offer $OID"

# 4. Buyer accepts
ORDER_ID=$(buyer_accept_offer "$BUYER_TOKEN" "$OID")
echo "Buyer accepted → order $ORDER_ID"

# 5. Verify lifecycle
OUTPUT=$(verify_request "$RID")
echo "$OUTPUT"

# 6. Assert expected state
assert_contains "$OUTPUT" "status=awarded"
assert_contains "$OUTPUT" "offer $OID supplier=.*status=accepted"

echo ""
echo "SCENARIO A1 PASSED"
