#!/bin/bash
# modes — statusline badge for Claude Code.
#
# Prints the badge string modes-lib.js already rendered, colours included. Which
# modes exist and what they look like is decided there, against the registry, so this
# script needs no second copy of the mode list.
#
# Wiring in $CLAUDE_CONFIG_DIR/settings.json:
#   "statusLine": { "type": "command", "command": "bash /path/to/modes-statusline.sh" }

BADGE="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.modes-badge"

[ -L "$BADGE" ] && exit 0
[ -f "$BADGE" ] || exit 0

# Cap the read and drop control bytes other than the escape (octal 033) that opens the
# colour codes. Keeping 033 out of the stripped set is the whole point: include it and
# the raw "[38;5;172m" text gets printed instead of colouring the badge.
head -c 256 "$BADGE" 2>/dev/null | tr -d '\000-\032\034-\037\177'
