#!/bin/bash

NETWORK_NAME=$(ipconfig getsummary $(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}') | awk -F ' SSID : ' '/ SSID : / {print $2}')

# Check if network name is empty
if [ -z "$NETWORK_NAME" ]; then
    sketchybar --set wifi label="Disconnected"
else
    sketchybar --set wifi label="$NETWORK_NAME"
fi
