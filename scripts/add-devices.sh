#!/usr/bin/env bash
# Register SNMP devices with Observium and run initial discovery/poll
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck disable=SC1091
source .env 2>/dev/null || true

COMMUNITY="${SNMP_COMMUNITY:-public}"
OBSERVIUM="${OBSERVIUM_CONTAINER:-observium-lab-observium-1}"

wait_for_observium() {
  for i in $(seq 1 30); do
    if docker compose exec -T observium test -f /opt/observium/add_device.php 2>/dev/null; then
      return 0
    fi
    sleep 5
  done
  echo "ERROR: Observium container not ready."
  exit 1
}

add_device() {
  local hostname="$1"
  echo "Adding device: ${hostname} (SNMP v2c, community: ${COMMUNITY})"
  docker compose exec -T observium \
    /opt/observium/add_device.php "$hostname" "$COMMUNITY" v2c || true
}

wait_for_observium

# Ubuntu client (always present in this lab)
add_device "ubuntu-client"

echo "Running discovery and poll..."
docker compose exec -T observium /opt/observium/discovery.php -h all
docker compose exec -T observium /opt/observium/poller.php -h all

echo "Devices registered. Open http://localhost:${OBSERVIUM_PORT:-8888} -> Devices"
