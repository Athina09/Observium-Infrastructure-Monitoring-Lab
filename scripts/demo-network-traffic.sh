#!/usr/bin/env bash
# Demo: download a large file to generate network traffic on ubuntu-client
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# Default: ~100 MB test file from speedtest.tele2.net (reliable public mirror)
URL="${1:-http://speedtest.tele2.net/100MB.zip}"
OUT="/tmp/lab-download.bin"

echo "==> Network traffic demo on ubuntu-client"
echo "    Download: ${URL}"
echo ""
echo "Open Observium -> Devices -> ubuntu-client -> Ports"
echo "Watch 'Traffic' graphs for inbound octets increasing."
echo ""
echo "Tip: force an immediate poll while downloading:"
echo "  docker compose exec observium /opt/observium/poller.php -h ubuntu-client"
echo ""

docker compose exec ubuntu-client bash -c "
  set -e
  echo 'Starting download...'
  curl -L --progress-bar -o '${OUT}' '${URL}'
  ls -lh '${OUT}'
  rm -f '${OUT}'
  echo 'Download complete.'
"

echo ""
echo "Done. Poll again to refresh graphs:"
echo "  docker compose exec observium /opt/observium/poller.php -h ubuntu-client"
