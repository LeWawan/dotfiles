#!/bin/bash

NETWORK_NAME=$(system_profiler SPAirPortDataType | awk '/Current Network Information:/ { getline; print substr($0, 13, (length($0) - 13)); exit }')

# Check if network name is empty
if [ -z "$NETWORK_NAME" ]; then
    sketchybar --set wifi label="Disconnected"
else
    sketchybar --set wifi label="$NETWORK_NAME"
fi
