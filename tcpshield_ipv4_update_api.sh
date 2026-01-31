#!/bin/bash

help_file="/tmp/IP_old.txt"

IP=$(curl -s http://ipv4.icanhazip.com)

if [[ -f "$help_file" ]]; then
    IP_old=$(cat "$help_file")
else
    touch "$help_file"
fi

if [[ "$IP" == "$IP_old" ]]; then
    echo "No update necessary. Interrupting script execution."
    exit 0
fi

echo "New IPv4 detected $IP_old --> $IP"

curl -X PATCH "<INSERT TCPSHIELD API-URL HERE>" \
     -H "X-API-Key: <INSERT YOUR API-KEY HERE>" \
     -H "Content-Type: application/json" \
     -d "{\"name\":\"Backend-01\",\"backends\":[\"$IP:25560\"],\"proxy_protocol\":false,\"vulcan_ac_enabled\":false,\"load_balancing_mode\":0}"

rm "$help_file"
touch "$help_file"
echo "$IP" > "$help_file"

echo "IPv4 was updated successfully."
