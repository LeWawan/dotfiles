#!/usr/bin/env node
// modes — UserPromptSubmit hook.
//
// Two jobs, both on every prompt:
//   1. Read the prompt for mode switches, persist the new state and badge.
//   2. Re-emit one short reminder per active mode.
//
// The reminder is the part that matters over a long session. modes-activate.js
// injects the full ruleset once at SessionStart, and context compression eventually
// prunes it, at which point the model drifts back to its default voice. A short
// nudge every turn keeps the rules anchored for a few dozen tokens.
//
// Switch syntax:
//   /mode                    report every mode and its level
//   /mode <name>             back to that mode's registry default
//   /mode <name> on          same thing, spelled out
//   /mode <name> <level>     a declared level, or "off"
// plus the natural-language phrases each mode lists under "on" and "off".
//
// The command is /mode, not /<name>, on purpose. Every mode is named after a skill, so
// "/caveman off" made Claude Code load caveman's SKILL.md and answer, which is the
// opposite of switching it off. Blocking the prompt fixed the waste and broke something
// else: a blocked prompt produces no turn, so the statusline never redrew and the badge
// stayed stale. Naming the command after nothing removes both problems. The turn runs
// normally, the statusline refreshes, and no skill gets loaded.

const {
  loadRegistry, resolveAll, writeState, writeBadge, renderReminder, skillExists, canonicalLevel,
  stripLiteralSpans,
} = require('./modes-lib');

// Every value a mode accepts, in registry order, without repeating "on" for a mode that
// already declares a level by that name.
function acceptedValues(modeCfg) {
  return [...new Set((modeCfg.levels || []).concat('on', 'off'))];
}

function usable(reg) {
  return Object.entries(reg.modes).filter(([, cfg]) => skillExists(cfg));
}

function report(reg, levels) {
  const rows = Object.entries(reg.modes).map(([name, cfg]) => {
    if (!skillExists(cfg)) return '  ' + name + ': skill missing';
    return '  ' + name + ': ' + levels[name] + '   (' + acceptedValues(cfg).join(' | ') + ')';
  });
  return 'Writing modes\n' + rows.join('\n');
}

let input = '';
process.stdin.on('data', chunk => { input += chunk; });
process.stdin.on('end', () => {
  let reg;
  try {
    reg = loadRegistry();
  } catch (e) {
    process.exit(0);
  }

  let raw = '';
  try {
    raw = String(JSON.parse(input).prompt || '');
  } catch (e) {
    raw = '';
  }
  // Match against the prompt with code blocks and inline spans blanked out, so a
  // command quoted as an example is not executed.
  const prompt = stripLiteralSpans(raw);
  const lower = prompt.toLowerCase();

  const levels = resolveAll(reg);
  let changed = false;
  const notes = [];

  // /mode [name] [level], on its own line.
  const cmd = prompt.match(
    /(?:^|\n)[ \t]*\/mode(?:[ \t]+([a-z0-9_-]+))?(?:[ \t]+([a-z0-9-]+))?[ \t]*(?=$|\n)/i
  );
  if (cmd) {
    const name = cmd[1] ? cmd[1].toLowerCase() : null;
    const requested = cmd[2] ? cmd[2].toLowerCase() : 'on';
    if (!name) {
      notes.push(report(reg, levels));
    } else if (!reg.modes[name]) {
      notes.push('No mode named "' + name + '". Known: '
        + usable(reg).map(([n]) => n).join(', ') + '.');
    } else if (!skillExists(reg.modes[name])) {
      notes.push('Mode "' + name + '" has no skill at skills/'
        + reg.modes[name].skill + '/SKILL.md, so it cannot be switched on.');
    } else {
      const next = canonicalLevel(reg.modes[name], requested);
      if (!next) {
        notes.push('"' + requested + '" is not a level for ' + name + '. Accepted: '
          + acceptedValues(reg.modes[name]).join(', ') + '.');
      } else {
        if (next !== levels[name]) { levels[name] = next; changed = true; }
        notes.push('Mode switched: ' + name + ' is now ' + next
          + '. Acknowledge in one short line, nothing else.');
      }
    }
  }

  // Natural-language toggles, for modes not already handled by the command above.
  for (const [name, modeCfg] of usable(reg)) {
    if (cmd && cmd[1] && cmd[1].toLowerCase() === name) continue;
    // Checked off first: "stop caveman" contains "caveman", so an "on" phrase would
    // otherwise win on the same sentence.
    const hit = list => (list || []).some(phrase => lower.includes(phrase.toLowerCase()));
    if (hit(modeCfg.off)) {
      if (levels[name] !== 'off') { levels[name] = 'off'; changed = true; }
    } else if (hit(modeCfg.on)) {
      const next = canonicalLevel(modeCfg, modeCfg.default) || 'off';
      if (levels[name] !== next) { levels[name] = next; changed = true; }
    }
  }

  if (changed) {
    writeState(reg, levels);
    writeBadge(reg, levels);
  }

  const out = notes.slice();
  for (const [name, modeCfg] of Object.entries(reg.modes)) {
    const line = renderReminder(name, modeCfg, levels[name]);
    if (line) out.push(line);
  }

  if (out.length) process.stdout.write(out.join('\n'));
});
