#!/bin/bash
source ./icons.sh

SPACE_LABELS=("1:DEV" "2:WEB" "3:ITERM" "4:ALL")
SPACE_ICONS=($DEV_ICON $WEB_ICON $TERM_ICON $ALL_ICON)

SPACE=(
  label.padding_right=33
  label.color=$WHITE
  label.font="$FONT:ExtraBold:14.0"
  label.highlight_color=$SKY
  background.padding_left=-8
  background.padding_right=-8
  background.color=$BG_SEC_COLR
  background.highlight_color=$SKY
  background.corner_radius=10
)

sketchybar --add event aerospace_workspace_change

sid=0
for i in "${!SPACE_LABELS[@]}"
do
  sid=$(($i+1))
  sketchybar --add item space.$sid left \
             --subscribe space.$sid aerospace_workspace_change \
             --set space.$sid "${SPACE[@]}" \
                  script="$PLUGIN_DIR/space.sh $sid" \
                  click_script="aerospace workspace $sid & sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$sid" \
             --set space.$sid label=${SPACE_LABELS[i]} icon=${SPACE_ICONS[i]} icon.color=$WHITE icon.padding_left=4
done

sketchybar --add item space_separator_left left \
           --set space_separator_left icon=󰅂 \
                                 icon.font="$FONT:Bold:16.0" \
                                 background.padding_left=16 \
                                 background.padding_right=10 \
                                 label.drawing=off \
                                 icon.color=$DARK_WHITE
