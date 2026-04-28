#!/usr/bin/env bash
# Wipe persona-created domain state between runs. PRESERVES personas + companies.
# Adapt the table list and FK ordering for your platform's schema.
#
# Personas/companies are NOT wiped here — re-running seed-personas.sh handles those.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

DB_USER="${DB_USER:-app_admin}"
DB_NAME="${DB_NAME:-app_db}"
DB_CONTAINER="${DB_CONTAINER:-app-db}"

echo "Resetting domain state in $DB_NAME via $DB_CONTAINER ..."

# Order matters: child tables first, parents last. Adapt to your schema.
docker exec "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" <<'SQL'
BEGIN;

-- Domain artifacts created by personas during scenarios.
-- Do NOT delete from companies, users, or auth tables.
DELETE FROM comments         WHERE created_at > NOW() - INTERVAL '7 days';
DELETE FROM tasks            WHERE created_at > NOW() - INTERVAL '7 days';
DELETE FROM projects         WHERE created_at > NOW() - INTERVAL '7 days';

-- Add per-platform domain tables here. Examples:
-- DELETE FROM service_orders     WHERE created_at > NOW() - INTERVAL '7 days';
-- DELETE FROM service_proposals  WHERE created_at > NOW() - INTERVAL '7 days';
-- DELETE FROM service_requests   WHERE created_at > NOW() - INTERVAL '7 days';

COMMIT;
SQL

echo "✓ Domain state reset"
