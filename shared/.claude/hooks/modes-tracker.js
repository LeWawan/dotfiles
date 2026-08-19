#!/usr/bin/env node
// modes — UserPromptSubmit hook.
//
// Runs on every prompt and does two things:
//   1. Applies any mode switch the prompt asks for.
//   2. Re-emits one short reminder per active mode.
//
// The reminder is what makes the modes stick. modes-activate.js injects the full ruleset
// once at session start, context compression eventually prunes it, and the model drifts
// back to its default voice. A nudge on every prompt keeps the rules anchored for a few
// dozen tokens.
//
// Switch syntax:
//   /mode                    report every mode and its level
//   /mode <name>             back to that mode's registry default
//   /mode <name> on          same thing, spelled out
//   /mode <name> <level>     a declared level, or "off"
// plus the natural-language phrases each mode lists under "on" and "off".
//
// The command is /mode, not /caveman, for two reasons found the hard way. Every mode is
// named after a skill, so "/caveman off" made Claude Code load caveman's SKILL.md and
// answer, the opposite of switching it off. Blocking that prompt removed the waste and
// broke something else: a blocked prompt produces no turn, so nothing redrew the
// statusline and the badge went stale. A command named after no skill avoids both. It
// does need commands/mode.md to exist, since Claude Code rejects an unregistered slash
// command before the prompt is ever submitted.

'use strict';

const {
  loadRegistry, resolveAll, writeState, writeBadge, renderReminder,
  usableModes, skillExists, acceptedValues, canonicalLevel, stripLiteralSpans,
} = require('./modes-lib');

// /mode [name] [level], alone on its line. Anchored so a command mentioned mid-sentence
// does not switch anything.
const MODE_COMMAND = /(?:^|\n)[ \t]*\/mode(?:[ \t]+([a-z0-9_-]+))?(?:[ \t]+([a-z0-9-]+))?[ \t]*(?=$|\n)/i;

function parseCommand(text) {
  const match = text.match(MODE_COMMAND);
  if (!match) return null;

  return {
    name: match[1] ? match[1].toLowerCase() : null,
    level: match[2] ? match[2].toLowerCase() : 'on',
  };
}

// Every mode and its accepted values, for a bare /mode.
function describeModes(registry, levels) {
  const rows = Object.entries(registry.modes).map(([name, def]) => {
    if (!skillExists(def)) return '  ' + name + ': skill missing';
    return '  ' + name + ': ' + levels[name] + '   (' + acceptedValues(def).join(' | ') + ')';
  });
  return 'Writing modes\n' + rows.join('\n');
}

// Apply one /mode command. Mutates levels, returns the line to show the model. Every
// failure path says what went wrong: silently ignoring a typo is worse than refusing it.
function applyCommand(registry, levels, command) {
  if (!command.name) return describeModes(registry, levels);

  const def = registry.modes[command.name];
  if (!def) {
    return 'No mode named "' + command.name + '". Known: '
      + usableModes(registry).map(([name]) => name).join(', ') + '.';
  }
  if (!skillExists(def)) {
    return 'Mode "' + command.name + '" has no skill at skills/' + def.skill
      + '/SKILL.md, so it cannot be switched on.';
  }

  const level = canonicalLevel(def, command.level);
  if (!level) {
    return '"' + command.level + '" is not a level for ' + command.name + '. Accepted: '
      + acceptedValues(def).join(', ') + '.';
  }

  levels[command.name] = level;
  return 'Mode switched: ' + command.name + ' is now ' + level
    + '. Acknowledge in one short line, nothing else.';
}

// Apply the registry's natural-language phrases, e.g. "stop caveman". Mutates levels.
// The mode already handled by an explicit command is skipped.
function applyPhrases(registry, levels, text, handledName) {
  const lower = text.toLowerCase();
  const mentions = phrases => (phrases || []).some(p => lower.includes(p.toLowerCase()));

  for (const [name, def] of usableModes(registry)) {
    if (name === handledName) continue;

    // "off" is tested first: "stop caveman" contains "caveman", so an "on" phrase would
    // otherwise win on the same sentence.
    if (mentions(def.off)) {
      levels[name] = 'off';
    } else if (mentions(def.on)) {
      levels[name] = canonicalLevel(def, def.default) || 'off';
    }
  }
}

function readPrompt(stdin) {
  try {
    return String(JSON.parse(stdin).prompt || '');
  } catch (error) {
    return '';
  }
}

let stdin = '';
process.stdin.on('data', chunk => { stdin += chunk; });
process.stdin.on('end', () => {
  let registry;
  try {
    registry = loadRegistry();
  } catch (error) {
    process.exit(0);
  }

  // Match against the prompt with code blocks and inline spans blanked out, so a command
  // quoted as an example is not executed.
  const prompt = stripLiteralSpans(readPrompt(stdin));

  const before = resolveAll(registry);
  const levels = { ...before };
  const command = parseCommand(prompt);

  const notes = [];
  if (command) notes.push(applyCommand(registry, levels, command));
  applyPhrases(registry, levels, prompt, command && command.name);

  const switched = Object.keys(levels).some(name => levels[name] !== before[name]);
  if (switched) {
    writeState(registry, levels);
    writeBadge(registry, levels);
  }

  const reminders = Object.entries(registry.modes)
    .map(([name, def]) => renderReminder(name, def, levels[name]))
    .filter(Boolean);

  const output = notes.concat(reminders);
  if (output.length) process.stdout.write(output.join('\n'));
});
