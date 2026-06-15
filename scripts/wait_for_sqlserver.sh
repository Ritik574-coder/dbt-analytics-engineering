#!/usr/bin/env bash
set -euo pipefail

HOST="${DBT_SQLSERVER_HOST:-localhost}"
PORT="${DBT_SQLSERVER_PORT:-1433}"
USER="${DBT_SQLSERVER_USER:-sa}"
PASSWORD="${DBT_SQLSERVER_PASSWORD:?DBT_SQLSERVER_PASSWORD is required}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-30}"
SLEEP_SECONDS="${SLEEP_SECONDS:-5}"

echo "Waiting for SQL Server at ${HOST}:${PORT}..."

for attempt in $(seq 1 "${MAX_ATTEMPTS}"); do
  if sqlcmd -S "${HOST},${PORT}" -U "${USER}" -P "${PASSWORD}" -C -Q "SELECT 1" >/dev/null 2>&1; then
    echo "SQL Server is ready (attempt ${attempt}/${MAX_ATTEMPTS})."
    exit 0
  fi

  echo "Attempt ${attempt}/${MAX_ATTEMPTS}: SQL Server not ready yet..."
  sleep "${SLEEP_SECONDS}"
done

echo "SQL Server did not become ready in time." >&2
exit 1
