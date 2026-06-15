#!/usr/bin/env bash
# Local development bootstrap for dbt-analytics-engineering.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "==> Checking prerequisites..."

command -v python3 >/dev/null || { echo "python3 is required." >&2; exit 1; }
command -v docker >/dev/null || { echo "docker is required." >&2; exit 1; }
docker compose version >/dev/null || { echo "docker compose is required." >&2; exit 1; }

if [ ! -f .env ]; then
  echo "==> Creating .env from .env.example"
  cp .env.example .env
  echo "    Review .env and update passwords before production use."
fi

# shellcheck disable=SC1091
set -a && source .env && set +a

echo "==> Creating Python virtual environment"
python3 -m venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate

echo "==> Installing Python dependencies"
pip install --upgrade pip
pip install -r requirements.txt

if [ ! -f "$HOME/.dbt/profiles.yml" ]; then
  echo "==> Creating ~/.dbt/profiles.yml from template"
  mkdir -p "$HOME/.dbt"
  cp profiles.example.yml "$HOME/.dbt/profiles.yml"
  echo "    Update ~/.dbt/profiles.yml with your credentials."
fi

echo "==> Starting SQL Server"
docker compose up -d

echo "==> Waiting for SQL Server to become healthy..."
for _ in $(seq 1 30); do
  if docker compose ps --format json | grep -q '"Health":"healthy"'; then
    break
  fi
  sleep 2
done

echo "==> Running dbt deps and debug"
dbt deps
dbt debug

echo ""
echo "Setup complete. Next steps:"
echo "  source .venv/bin/activate"
echo "  dbt run"
echo "  dbt test"
echo "  dbt docs generate && dbt docs serve"
