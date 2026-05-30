#!/usr/bin/env bash
# Verify SNMP is responding from the Ubuntu client
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck disable=SC1091
source .env 2>/dev/null || true
COMMUNITY="${SNMP_COMMUNITY:-public}"

echo "==> SNMP walk from Observium -> ubuntu-client"
echo ""

docker compose exec -T observium snmpwalk -v2c -c "$COMMUNITY" ubuntu-client system 2>/dev/null | head -5
echo "..."

echo ""
echo "CPU load (hrProcessorLoad):"
docker compose exec -T observium snmpwalk -v2c -c "$COMMUNITY" ubuntu-client HOST-RESOURCES-MIB::hrProcessorLoad 2>/dev/null || \
  docker compose exec -T observium snmpwalk -v2c -c "$COMMUNITY" ubuntu-client .1.3.6.1.2.1.25.3.3.1.2 2>/dev/null

echo ""
echo "Memory (hrStorage):"
docker compose exec -T observium snmpwalk -v2c -c "$COMMUNITY" ubuntu-client HOST-RESOURCES-MIB::hrStorage 2>/dev/null | head -10 || \
  docker compose exec -T observium snmpwalk -v2c -c "$COMMUNITY" ubuntu-client .1.3.6.1.2.1.25.2.3.1 2>/dev/null | head -10

echo ""
echo "Network interfaces (ifDescr):"
docker compose exec -T observium snmpwalk -v2c -c "$COMMUNITY" ubuntu-client IF-MIB::ifDescr 2>/dev/null || \
  docker compose exec -T observium snmpwalk -v2c -c "$COMMUNITY" ubuntu-client .1.3.6.1.2.1.2.2.1.2 2>/dev/null

echo ""
echo "SNMP check complete."
