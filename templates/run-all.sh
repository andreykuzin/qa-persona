#!/usr/bin/env bash
# Run every scenario in scenarios/, tally results, exit non-zero on any FAIL.
# Optional first arg: glob to filter (e.g. ./run-all.sh 'A* D*')
set -u
cd "$(git rev-parse --show-toplevel)"

SCENARIO_DIR="scripts/qa/FLOW_NAME-e2e/scenarios"
FILTER="${1:-*}"

shopt -s nullglob
mapfile -t SCRIPTS < <(cd "$SCENARIO_DIR" && ls $FILTER 2>/dev/null | grep -E '\.sh$' | sort)

if [ ${#SCRIPTS[@]} -eq 0 ]; then
    echo "No scenarios match filter: $FILTER"
    exit 1
fi

PASSED=()
FAILED=()
START=$(date +%s)

for s in "${SCRIPTS[@]}"; do
    echo ""
    echo "============================================================"
    echo "  $s"
    echo "============================================================"
    if "$SCENARIO_DIR/$s"; then
        PASSED+=("$s")
    else
        FAILED+=("$s")
    fi
done

ELAPSED=$(( $(date +%s) - START ))

echo ""
echo "============================================================"
echo "  RESULTS  (${ELAPSED}s elapsed)"
echo "============================================================"
echo ""
echo "PASSED (${#PASSED[@]}):"
for s in "${PASSED[@]}"; do echo "  ✓ $s"; done
echo ""
if [ ${#FAILED[@]} -gt 0 ]; then
    echo "FAILED (${#FAILED[@]}):"
    for s in "${FAILED[@]}"; do echo "  ✗ $s"; done
    exit 1
fi

echo "ALL ${#PASSED[@]} SCENARIOS PASSED"
