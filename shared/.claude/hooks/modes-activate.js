#!/usr/bin/env node
// modes — SessionStart hook.
//
// Works out which modes are active, records the state and the badge, then prints each
// active mode's full ruleset. Claude Code injects whatever lands on stdout as hidden
// session context.
//
// The whole ruleset goes in, examples included, not a two-line summary. Summaries do not
// hold: the model drifts back to its default voice mid-conversation, especially once
// context compression has pruned the original instruction away.

'use strict';

const { loadRegistry, resolveAll, writeState, writeBadge, renderRules } = require('./modes-lib');

let registry;
try {
  registry = loadRegistry();
} catch (error) {
  // No registry means no modes. Never a reason to hold up a session.
  process.stdout.write('OK');
  process.exit(0);
}

const levels = resolveAll(registry);
writeState(registry, levels);
writeBadge(registry, levels);

const rulesets = Object.entries(registry.modes)
  .map(([name, def]) => renderRules(name, def, levels[name]))
  .filter(Boolean);

process.stdout.write(rulesets.length ? rulesets.join('\n\n---\n\n') : 'OK');
