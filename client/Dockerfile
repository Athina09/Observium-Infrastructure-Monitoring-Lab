FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    snmpd \
    snmp \
    stress-ng \
    curl \
    wget \
    ca-certificates \
    procps \
    && rm -rf /var/lib/apt/lists/*

COPY snmpd.conf /etc/snmp/snmpd.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 161/udp

ENTRYPOINT ["/entrypoint.sh"]
