#!/usr/bin/env bash
# Demo: generate sustained CPU load so Observium graphs spike
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

DURATION="${1:-120}"
WORKERS="${2:-4}"

echo "==> CPU load demo on ubuntu-client"
echo "    Duration: ${DURATION}s | Workers: ${WORKERS}"
echo ""
echo "Open Observium -> Devices -> ubuntu-client -> Health -> Processor"
echo "Graphs update every ~5 minutes by default; force a poll with:"
echo "  docker compose exec observium /opt/observium/poller.php -h ubuntu-client"
echo ""

docker compose exec ubuntu-client stress-ng \
  --cpu "$WORKERS" \
  --cpu-method matrixprod \
  --timeout "${DURATION}s" \
  --metrics-brief

echo ""
echo "Load test finished. Run poll again to capture post-load values:"
echo "  docker compose exec observium /opt/observium/poller.php -h ubuntu-client"
