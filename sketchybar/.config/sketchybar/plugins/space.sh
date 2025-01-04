#!/bin/bash


source ./colors.sh

BG_COLOR=$BG_SEC_COLR
LABEL_COLOR=$WHITE

BG_SELECTED_COLOR=$ACCENT_COLR
LABEL_SELECTED_COLOR=$BLACK

sketchybar --animate tanh 10 --set $NAME
# label.highlight=$SELECTED \
# background.highlight=$SELECTED \
# label.width=$WIDTH

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.color=$BG_SELECTED_COLOR label.color=$LABEL_SELECTED_COLOR icon.color=$LABEL_SELECTED_COLOR
else
  sketchybar --set $NAME background.color=$BG_COLOR label.color=$LABEL_COLOR icon.color=$LABEL_COLOR
fi




