#!/bin/bash

WIFI_INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')
NETWORK_INFO=$(networksetup -getairportnetwork $WIFI_INTERFACE 2>/dev/null)

if [[ "$NETWORK_INFO" == *"You are not associated with an AirPort network"* ]]; then
    sketchybar --set wifi label="Disconnected"
else
    NETWORK_NAME=$(echo "$NETWORK_INFO" | sed 's/Current Wi-Fi Network: //')
    # Check if network name is empty
    if [ -z "$NETWORK_NAME" ]; then
        sketchybar --set wifi label="Disconnected"
    else
        sketchybar --set wifi label="$NETWORK_NAME"
    fi
fi
