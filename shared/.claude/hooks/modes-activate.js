#!/usr/bin/env node
// modes — SessionStart hook.
//
// Resolves the level of every registered mode, persists the state and the
// statusline badge, then prints each active mode's ruleset. Claude Code injects
// whatever this writes to stdout as hidden session context.
//
// Full rules with examples go in, not a two-line summary. Summaries are too weak:
// the model drifts back to its default voice mid-conversation, especially once
// context compression has pruned the original instruction away.

const { loadRegistry, resolveAll, writeState, writeBadge, renderRules } = require('./modes-lib');

let reg;
try {
  reg = loadRegistry();
} catch (e) {
  // An unreadable or malformed registry must not block the session.
  process.stdout.write('OK');
  process.exit(0);
}

const levels = resolveAll(reg);
writeState(reg, levels);
writeBadge(reg, levels);

const blocks = [];
for (const [name, modeCfg] of Object.entries(reg.modes)) {
  const rules = renderRules(name, modeCfg, levels[name]);
  if (rules) blocks.push(rules);
}

process.stdout.write(blocks.length ? blocks.join('\n\n---\n\n') : 'OK');
