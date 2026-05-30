#!/bin/bash
set -euo pipefail

COMMUNITY="${SNMP_COMMUNITY:-public}"

# Apply community string from environment
sed -i "s/^rocommunity .*/rocommunity ${COMMUNITY}  default    -V all/" /etc/snmp/snmpd.conf

echo "Starting SNMP agent (community: ${COMMUNITY})..."
/usr/sbin/snmpd -f -Lo -C -c /etc/snmp/snmpd.conf
