#!/usr/bin/env bash
# Force Observium to poll all devices immediately (useful during demos)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "Running discovery..."
docker compose exec -T observium /opt/observium/discovery.php -h all

echo "Polling all devices..."
docker compose exec -T observium /opt/observium/poller.php -h all

echo "Done."
