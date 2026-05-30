#!/usr/bin/env bash
# Start Docker (if needed) and bring the lab online
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck disable=SC1091
[[ -f .env ]] && source .env
PORT="${OBSERVIUM_PORT:-8888}"

ensure_docker() {
  if docker info >/dev/null 2>&1; then
    return 0
  fi
  echo "Docker is not running. Starting Docker Desktop..."
  if [[ "$(uname)" == "Darwin" ]]; then
    open -a Docker
  else
    echo "ERROR: Start Docker manually, then run this script again."
    exit 1
  fi
  for i in $(seq 1 90); do
    if docker info >/dev/null 2>&1; then
      echo "Docker is ready."
      return 0
    fi
    sleep 2
  done
  echo "ERROR: Docker did not start within 3 minutes."
  exit 1
}

ensure_docker

echo "==> Starting containers..."
docker compose up -d

echo "==> Waiting for http://localhost:${PORT} ..."
for i in $(seq 1 60); do
  if curl -sf "http://localhost:${PORT}/" >/dev/null 2>&1; then
    echo ""
    echo "Observium is up: http://localhost:${PORT}"
    echo "Login: ${OBSERVIUM_ADMIN_USER:-admin} / ${OBSERVIUM_ADMIN_PASS:-observium}"
    exit 0
  fi
  sleep 3
done

echo "ERROR: Observium did not respond. Check logs:"
echo "  docker compose logs observium"
exit 1
