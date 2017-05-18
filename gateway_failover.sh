#!/bin/bash

# For FreeBSD

ALT_GATEWAYS=(
    "192.168.45.45" \
    "192.168.45.46" \
    "192.168.45.3"
    )

# Get gateway IP
GATEWAY_IP=$( netstat -nr | grep 'default' | awk '{print $2}' )
#GATEWAY_IP="1.1.1.1"
echo "GATEWAY_IP: $GATEWAY_IP"

# Ping gateway IP
ping -c 1 $GATEWAY_IP >/dev/null
if [[ $? -ne 0 ]]; then
    echo "$GATEWAY_IP is down!" >&2
    # Change gateway IP
    for ALT_GATEWAY in "${ALT_GATEWAYS[@]}"; do
        echo "ALT_GATEWAY: $ALT_GATEWAY"
        if [[ $GATEWAY_IP != $ALT_GATEWAY ]]; then
            echo "Changing to $ALT_GATEWAY..." >&2
            route delete default
            route add default $ALT_GATEWAY
            break
        fi
    done
fi
