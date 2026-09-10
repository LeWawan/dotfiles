---
description: Switch a writing mode (caveman, unslop, ponytail) on, off, or to a level
argument-hint: [mode] [level|on|off]
---

The modes hook already read this prompt, applied the switch and reported the new level.
Nothing is left to do.

Acknowledge in one short line. Do not explain the modes system, do not read the state
file, do not call any tool.

This file exists only so Claude Code accepts `/mode` as a command. An unregistered slash
command is rejected before the prompt is submitted, so the UserPromptSubmit hook never
runs and the switch silently does nothing.
