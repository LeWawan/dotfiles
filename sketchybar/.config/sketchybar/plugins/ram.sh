#!/bin/bash
# Get total RAM and used RAM in bytes
TOTAL_RAM=$(sysctl -n hw.memsize)
PAGE_SIZE=$(sysctl -n hw.pagesize)
PAGES_FREE=$(vm_stat | grep "Pages free:" | sed 's/[^0-9]*//g')
PAGES_INACTIVE=$(vm_stat | grep "Pages inactive:" | sed 's/[^0-9]*//g')
PAGES_SPECULATIVE=$(vm_stat | grep "Pages speculative:" | sed 's/[^0-9]*//g')

# Calculate free RAM in bytes
FREE_RAM=$(( (PAGES_FREE + PAGES_INACTIVE + PAGES_SPECULATIVE) * PAGE_SIZE ))

# Calculate used RAM percentage
RAM_PERCENT=$(echo "$FREE_RAM $TOTAL_RAM" | awk '{printf "%.0f\n", (1 - $1/$2)*100}')

# Update sketchybar
sketchybar --set $NAME label="$RAM_PERCENT%"
