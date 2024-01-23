#!/bin/bash

IPV4_SANITIZADO=$(curl ifconfig.me -4 | sed 's/\./-/g')
HOST_METADATA=$(grep "^HostMetadata\s*=\s*" /etc/zabbix/zabbix_agent2.conf | awk -F "=" '{print $2}' | tr -d '[:space:]')
# HOST_METADATA=$(grep "^HostMetadata\s*=\s*" ./temp/zabbix_agent2.conf | awk -F "=" '{print $2}' | tr -d '[:space:]')

HOSTNAME_CTL="$HOST_METADATA-$IPV4_SANITIZADO"

echo "$HOST_METADATA-$IPV4_SANITIZADO"

hostnamectl set-hostname $HOSTNAME_CTL