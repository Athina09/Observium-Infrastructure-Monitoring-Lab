#!/usr/bin/env bash
# Start the lab and register the Ubuntu client with Observium
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi

if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker is not running."
  echo "  macOS: open Docker Desktop, or run ./scripts/start.sh"
  exit 1
fi

echo "==> Building and starting containers..."
docker compose up -d --build

echo "==> Waiting for Observium to become ready..."
for i in $(seq 1 60); do
  if curl -sf "http://localhost:${OBSERVIUM_PORT:-8888}/" >/dev/null 2>&1; then
    echo "    Observium is up."
    break
  fi
  if [[ $i -eq 60 ]]; then
    echo "ERROR: Observium did not respond within 5 minutes."
    exit 1
  fi
  sleep 5
done

echo "==> Adding Ubuntu client as SNMP device..."
"$ROOT/scripts/add-devices.sh"

echo ""
echo "Lab is ready."
echo "  Web UI:  http://localhost:${OBSERVIUM_PORT:-8888}"
echo "  Login:   admin / observium  (change in .env)"
echo ""
echo "Next steps:"
echo "  ./scripts/demo-cpu-load.sh       # spike CPU and watch graphs"
echo "  ./scripts/demo-network-traffic.sh # generate download traffic"
