#!/usr/bin/env node
// modes — the writing-mode domain, shared by the three hooks.
//
// A mode is a named set of writing rules that stays on across a whole session. Each one
// is defined by an entry in modes.json and a skill file that holds the actual rules:
//
//   modes.json                    which modes exist, their levels, badge and reminder
//   skills/<skill>/SKILL.md       the rules themselves, the single source of truth
//   .modes-active                 the level each mode currently runs at
//   .modes-badge                  what the statusline should print
//
// One mode per skill, on purpose. Deleting a skill directory retires its mode: the mode
// is skipped everywhere instead of breaking the hooks, and its stored level is kept in
// case the skill comes back.

'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');
const { readCapped, writeAtomic } = require('./modes-fs');

const CLAUDE_DIR = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');
const ESC = String.fromCharCode(27); // ANSI escape, never a literal control byte in source

// Both files hold a handful of short values. The caps exist so a planted file cannot
// grow into something worth reading.
const MAX_STATE_BYTES = 512;
const MAX_BADGE_BYTES = 128;

// ---------------------------------------------------------------------------- registry

// modes.json, with the optional fields filled in. Throws if it is missing or malformed,
// which each hook catches and treats as "no modes configured".
function loadRegistry() {
  const registry = JSON.parse(fs.readFileSync(path.join(__dirname, 'modes.json'), 'utf8'));
  return {
    stateFile: registry.stateFile || '.modes-active',
    badgeFile: registry.badgeFile || '.modes-badge',
    modes: registry.modes || {},
  };
}

function statePath(registry) { return path.join(CLAUDE_DIR, registry.stateFile); }
function badgePath(registry) { return path.join(CLAUDE_DIR, registry.badgeFile); }
function skillPath(skill) { return path.join(CLAUDE_DIR, 'skills', skill, 'SKILL.md'); }

// [name, definition] for every mode whose skill is actually on disk.
function usableModes(registry) {
  return Object.entries(registry.modes).filter(([, def]) => skillExists(def));
}

function skillExists(def) {
  try {
    return fs.statSync(skillPath(def.skill)).isFile();
  } catch (error) {
    return false;
  }
}

// ------------------------------------------------------------------------------ levels

// A mode runs at one level, or at "off". Levels are declared per mode in the registry,
// so caveman has six of them and unslop has one.

// The level a raw value means, or null when the mode does not know it.
//
// "off" and "on" work for every mode whatever its levels are. Without the "on" case,
// `/mode unslop on` worked (unslop declares a level literally named "on") while
// `/mode caveman on` silently did nothing, since caveman declares lite, full, ultra and
// the wenyan levels. Same word, two outcomes, no way to tell why.
function canonicalLevel(def, value) {
  if (!value) return null;

  const wanted = String(value).trim().toLowerCase();
  if (wanted === 'off') return 'off';

  const levels = def.levels || [];
  if (wanted === 'on' && !levels.includes('on')) return canonicalLevel(def, def.default);

  const resolved = (def.aliases && def.aliases[wanted]) || wanted;
  return levels.includes(resolved) ? resolved : null;
}

// Every value a mode accepts, in registry order, without repeating "on" for a mode that
// already declares a level by that name.
function acceptedValues(def) {
  return [...new Set((def.levels || []).concat('on', 'off'))];
}

// A single-session override, e.g. CLAUDE_MODE_CAVEMAN=ultra or =off.
function envLevel(name, def) {
  const variable = 'CLAUDE_MODE_' + name.toUpperCase().replace(/[^A-Z0-9]/g, '_');
  return canonicalLevel(def, process.env[variable]);
}

function envOverriddenModes(registry) {
  return new Set(
    Object.entries(registry.modes)
      .filter(([name, def]) => envLevel(name, def))
      .map(([name]) => name)
  );
}

// ------------------------------------------------------------------------------- state

// The stored level per mode. Unknown mode names and unknown levels are dropped rather
// than trusted, which is what keeps a hand-edited or corrupted file harmless.
function readState(registry) {
  const raw = readCapped(statePath(registry), MAX_STATE_BYTES);
  if (!raw) return {};

  let stored;
  try {
    stored = JSON.parse(raw);
  } catch (error) {
    return {};
  }
  if (!stored || typeof stored !== 'object') return {};

  const state = {};
  for (const [name, value] of Object.entries(stored)) {
    const def = registry.modes[name];
    if (!def) continue;
    const level = canonicalLevel(def, value);
    if (level) state[name] = level;
  }
  return state;
}

// The level every mode runs at right now: environment override first, then the stored
// state, then the registry default. A mode whose skill is gone is off.
function resolveAll(registry) {
  const state = readState(registry);
  const levels = {};

  for (const [name, def] of Object.entries(registry.modes)) {
    if (!skillExists(def)) {
      levels[name] = 'off';
      continue;
    }
    levels[name] = envLevel(name, def)
      || state[name]
      || canonicalLevel(def, def.default)
      || 'off';
  }
  return levels;
}

// Persist the levels, skipping the ones that are not the user's recorded choice.
//
// A missing skill and an environment override both resolve to a level, but neither is a
// decision worth remembering: writing them would turn a temporarily absent skill or a
// one-off `CLAUDE_MODE_CAVEMAN=ultra` into the durable setting. Their stored value is
// carried over untouched instead.
function writeState(registry, levels) {
  const previous = readState(registry);
  const fromEnv = envOverriddenModes(registry);
  const next = {};

  for (const [name, level] of Object.entries(levels)) {
    const def = registry.modes[name];
    if (!def) continue;

    if (!skillExists(def) || fromEnv.has(name)) {
      if (previous[name]) next[name] = previous[name];
    } else if (canonicalLevel(def, level)) {
      next[name] = level;
    }
  }
  writeAtomic(statePath(registry), JSON.stringify(next));
}

// ------------------------------------------------------------------------------- badge

// One coloured tag per active mode, e.g. "[CAVEMAN] [UNSLOP]". The level shows only when
// it differs from the default, so the common case stays short.
//
// The colour codes get written here rather than rebuilt by the statusline script, which
// only has to print the result. Guarding this file against a planted escape sequence
// would buy nothing: writing to $CLAUDE_CONFIG_DIR already means being able to edit these
// hooks, which is arbitrary code execution.
function writeBadge(registry, levels) {
  const tags = [];

  for (const [name, def] of Object.entries(registry.modes)) {
    const level = levels[name];
    if (!level || level === 'off') continue;

    const label = def.showLevelInBadge && level !== def.default
      ? def.badge + ':' + level.toUpperCase()
      : def.badge;
    const colour = Number.isInteger(def.color) && def.color >= 0 && def.color <= 255
      ? def.color
      : 244;

    tags.push(ESC + '[38;5;' + colour + 'm[' + label + ']' + ESC + '[0m');
  }
  writeAtomic(badgePath(registry), tags.join(' ').slice(0, MAX_BADGE_BYTES));
}

// --------------------------------------------------------------------------- rendering

// The rules for one mode, read from its skill. Frontmatter is metadata for skill
// discovery, not part of the ruleset, so it goes.
function readSkillBody(skill) {
  try {
    return fs.readFileSync(skillPath(skill), 'utf8').replace(/^---[\s\S]*?\n---\s*/, '');
  } catch (error) {
    return null;
  }
}

// Drop the rows and examples that belong to other levels, so a six-level skill injects
// one level's rules instead of all six. Two conventions are recognised: intensity table
// rows ("| **ultra** | ...") and per-level example bullets ("- ultra: ..."). Lines that
// name no level pass through untouched.
function filterToLevel(def, body, level) {
  const known = new Set((def.levels || []).concat(Object.keys(def.aliases || {})));
  if (known.size === 0) return body;

  const keep = line => {
    const tableRow = line.match(/^\|\s*\*\*(\S+?)\*\*\s*\|/);
    if (tableRow && known.has(tableRow[1])) return canonicalLevel(def, tableRow[1]) === level;

    const bullet = line.match(/^-\s+(\S+?):\s/);
    if (bullet && known.has(bullet[1])) return canonicalLevel(def, bullet[1]) === level;

    return true;
  };
  return body.split('\n').filter(keep).join('\n');
}

// The full ruleset to inject at session start, or null when there is nothing to inject.
function renderRules(name, def, level) {
  if (!level || level === 'off') return null;

  const body = readSkillBody(def.skill);
  if (!body) return null;

  const header = def.showLevelInBadge
    ? name.toUpperCase() + ' MODE ACTIVE — level: ' + level
    : name.toUpperCase() + ' MODE ACTIVE';

  return header + '\n\n' + filterToLevel(def, body, level).trim();
}

// The short per-prompt nudge, with {level} and {mode} filled in.
function renderReminder(name, def, level) {
  if (!level || level === 'off' || !def.reminder) return null;
  if (!skillExists(def)) return null;

  return def.reminder.replace(/\{level\}/g, level).replace(/\{mode\}/g, name);
}

// ------------------------------------------------------------------------ prompt text

// Blank out the parts of a prompt where a command is being shown rather than issued:
// fenced blocks, indented blocks and inline spans. Without this, pasting
// "/mode caveman off" inside an example switches the mode for real.
//
// Content is replaced with spaces rather than removed, so line-anchored matching
// downstream still sees the original line structure.
function stripLiteralSpans(text) {
  const blank = match => match.replace(/[^\n]/g, ' ');

  return text
    .replace(/```[\s\S]*?(?:```|$)/g, blank)
    .replace(/~~~[\s\S]*?(?:~~~|$)/g, blank)
    .replace(/`[^`\n]*`/g, blank)
    .replace(/^(?: {4}|\t)\S.*$/gm, blank);
}

module.exports = {
  CLAUDE_DIR,
  loadRegistry,
  usableModes,
  skillExists,
  acceptedValues,
  canonicalLevel,
  resolveAll,
  readState,
  writeState,
  writeBadge,
  renderRules,
  renderReminder,
  stripLiteralSpans,
};
