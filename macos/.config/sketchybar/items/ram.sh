#!/bin/bash
RAM=(
  update_freq=2
  icon.font="$FONT:Regular:16.0"
  icon=􀫦
  icon.color=$RED
  background.color=$BG_SEC_COLR
  script="$PLUGIN_DIR/ram.sh"
)

sketchybar --add item ram right \
           --set ram "${RAM[@]}"
