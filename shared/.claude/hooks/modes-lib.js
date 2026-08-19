#!/usr/bin/env node
// modes — shared library for the Claude Code writing-mode hooks.
//
// One registry (modes.json) drives three hooks: modes-activate.js (SessionStart),
// modes-tracker.js (UserPromptSubmit) and modes-statusline.sh (statusLine).
//
// One mode per skill. Each registry entry names a skill under
// $CLAUDE_CONFIG_DIR/skills/<skill>/SKILL.md, which stays the single source of truth
// for the rules. The hooks only decide when to inject them and at which level.
// A mode whose SKILL.md is missing is skipped, so deleting a skill directory
// degrades cleanly instead of breaking every session.
//
// State lives in two files under $CLAUDE_CONFIG_DIR:
//   .modes-active  JSON, {"caveman":"full","unslop":"on"}, written and read here
//   .modes-badge   pre-rendered badge string, written here, read by the bash statusline
//
// The badge is pre-rendered so the statusline never parses JSON and never needs a
// second copy of the validation whitelist.

const fs = require('fs');
const path = require('path');
const os = require('os');

const CLAUDE_DIR = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');
const MAX_STATE_BYTES = 512;
const MAX_BADGE_BYTES = 128;
const ESC = String.fromCharCode(27); // ANSI escape, kept out of the source as a literal

function loadRegistry() {
  const raw = fs.readFileSync(path.join(__dirname, 'modes.json'), 'utf8');
  const reg = JSON.parse(raw);
  reg.stateFile = reg.stateFile || '.modes-active';
  reg.badgeFile = reg.badgeFile || '.modes-badge';
  reg.modes = reg.modes || {};
  return reg;
}

function statePath(reg) { return path.join(CLAUDE_DIR, reg.stateFile); }
function badgePath(reg) { return path.join(CLAUDE_DIR, reg.badgeFile); }
function skillPath(skill) { return path.join(CLAUDE_DIR, 'skills', skill, 'SKILL.md'); }

// A mode is only usable while its skill exists on disk. Delete the skill directory
// and the mode drops out of activation, the tracker and the badge on its own.
function skillExists(modeCfg) {
  try {
    return fs.statSync(skillPath(modeCfg.skill)).isFile();
  } catch (e) {
    return false;
  }
}

// Resolve an alias (caveman "wenyan" -> "wenyan-full") and validate against the
// mode's declared levels. Returns null when the value is not a level this mode knows.
//
// "off" and "on" work for every mode, whatever its levels are. Without the "on" case,
// /unslop on worked (unslop declares a level literally named "on") while /caveman on
// silently did nothing, since caveman declares lite, full, ultra and the wenyan
// levels. Same word, different outcome, no way to tell why.
function canonicalLevel(modeCfg, value) {
  if (!value) return null;
  const v = String(value).trim().toLowerCase();
  if (v === 'off') return 'off';
  const levels = modeCfg.levels || [];
  if (v === 'on' && !levels.includes('on')) return canonicalLevel(modeCfg, modeCfg.default);
  const aliased = (modeCfg.aliases && modeCfg.aliases[v]) || v;
  return levels.includes(aliased) ? aliased : null;
}

// Per-mode environment override, e.g. CLAUDE_MODE_CAVEMAN=ultra or =off.
function envLevel(name, modeCfg) {
  const key = 'CLAUDE_MODE_' + name.toUpperCase().replace(/[^A-Z0-9]/g, '_');
  return canonicalLevel(modeCfg, process.env[key]);
}

// Which modes are currently driven by an environment override. writeState uses this
// to leave their stored value alone: an override is scoped to the process that sets
// it, so persisting it would silently rewrite the durable setting.
function envOverridden(reg) {
  const out = new Set();
  for (const [name, modeCfg] of Object.entries(reg.modes)) {
    if (envLevel(name, modeCfg)) out.add(name);
  }
  return out;
}

// Symlink-safe, size-capped, whitelist-validated state read.
//
// Without the symlink refusal a local attacker with write access to
// $CLAUDE_CONFIG_DIR could point .modes-active at any user-readable file and have
// every reader either echo its bytes to the terminal or inject them into model
// context. The size cap and the per-key validation below bound what survives.
function readState(reg) {
  const p = statePath(reg);
  const out = {};
  let parsed;
  try {
    const st = fs.lstatSync(p);
    if (st.isSymbolicLink() || !st.isFile() || st.size > MAX_STATE_BYTES) return out;
    const O_NOFOLLOW = typeof fs.constants.O_NOFOLLOW === 'number' ? fs.constants.O_NOFOLLOW : 0;
    let fd;
    let raw;
    try {
      fd = fs.openSync(p, fs.constants.O_RDONLY | O_NOFOLLOW);
      const buf = Buffer.alloc(MAX_STATE_BYTES);
      const n = fs.readSync(fd, buf, 0, MAX_STATE_BYTES, 0);
      raw = buf.slice(0, n).toString('utf8');
    } finally {
      if (fd !== undefined) fs.closeSync(fd);
    }
    parsed = JSON.parse(raw);
  } catch (e) {
    return out;
  }
  if (!parsed || typeof parsed !== 'object') return out;
  for (const [name, value] of Object.entries(parsed)) {
    const modeCfg = reg.modes[name];
    if (!modeCfg) continue;
    const level = canonicalLevel(modeCfg, value);
    if (level) out[name] = level;
  }
  return out;
}

// The level each mode runs at right now. Precedence: environment override,
// then persisted state, then the registry default. Modes whose skill is gone
// resolve to 'off'.
function resolveAll(reg) {
  const state = readState(reg);
  const out = {};
  for (const [name, modeCfg] of Object.entries(reg.modes)) {
    if (!skillExists(modeCfg)) { out[name] = 'off'; continue; }
    out[name] = envLevel(name, modeCfg)
      || state[name]
      || canonicalLevel(modeCfg, modeCfg.default)
      || 'off';
  }
  return out;
}

// Symlink-safe atomic write: temp file opened with O_EXCL|O_NOFOLLOW at 0600,
// then renamed over the target.
//
// A symlinked $CLAUDE_CONFIG_DIR is a legitimate pattern (stow, or a config dir on
// another volume), so the parent is resolved and its ownership checked rather than
// refused outright. The target file itself must never be a symlink: that is the
// actual clobber vector. Set CLAUDE_MODES_DEBUG=1 for stderr diagnostics.
function safeWrite(filePath, content) {
  const debug = process.env.CLAUDE_MODES_DEBUG === '1';
  const warn = msg => { if (debug) process.stderr.write('[modes] ' + msg + '\n'); };
  try {
    const dir = path.dirname(filePath);
    fs.mkdirSync(dir, { recursive: true });

    let realDir = dir;
    const lstat = fs.lstatSync(dir);
    if (lstat.isSymbolicLink()) {
      realDir = fs.realpathSync(dir);
      const realStat = fs.statSync(realDir);
      if (!realStat.isDirectory()) { warn(realDir + ' is not a directory'); return; }
      if (typeof process.getuid === 'function') {
        if (realStat.uid !== process.getuid()) {
          warn(realDir + ' owned by uid ' + realStat.uid + ', not ' + process.getuid());
          return;
        }
      } else {
        const home = path.resolve(os.homedir()).toLowerCase();
        const real = path.resolve(realDir).toLowerCase();
        if (real !== home && !real.startsWith(home + path.sep)) {
          warn(real + ' is outside ' + home);
          return;
        }
      }
    }

    const realPath = path.join(realDir, path.basename(filePath));
    try {
      if (fs.lstatSync(realPath).isSymbolicLink()) { warn(realPath + ' is a symlink'); return; }
    } catch (e) {
      if (e.code !== 'ENOENT') return;
    }

    const tempPath = path.join(realDir, '.' + path.basename(filePath) + '.' + process.pid + '.tmp');
    const O_NOFOLLOW = typeof fs.constants.O_NOFOLLOW === 'number' ? fs.constants.O_NOFOLLOW : 0;
    const flags = fs.constants.O_WRONLY | fs.constants.O_CREAT | fs.constants.O_EXCL | O_NOFOLLOW;
    let fd;
    try {
      fd = fs.openSync(tempPath, flags, 0o600);
      fs.writeSync(fd, String(content));
    } finally {
      if (fd !== undefined) fs.closeSync(fd);
    }
    fs.renameSync(tempPath, realPath);
  } catch (e) {
    // Silent fail. State and badge are best-effort, never worth blocking a session over.
  }
}

// Persist the resolved levels.
//
// A mode whose skill is missing resolves to 'off', but that is an observation about
// the filesystem, not a choice the user made. Writing it would turn a temporarily
// absent skill (moved, mid-stow, not yet synced) into a permanent opt-out that
// survives the skill coming back. So carry the stored value over untouched instead.
function writeState(reg, levels) {
  const previous = readState(reg);
  const fromEnv = envOverridden(reg);
  const clean = {};
  for (const [name, level] of Object.entries(levels)) {
    const modeCfg = reg.modes[name];
    if (!modeCfg) continue;
    // Missing skill, or a level coming from the environment: neither is a choice the
    // user recorded, so keep whatever was already stored.
    if (!skillExists(modeCfg) || fromEnv.has(name)) {
      if (previous[name]) clean[name] = previous[name];
      continue;
    }
    if (level === 'off' || canonicalLevel(modeCfg, level)) clean[name] = level;
  }
  safeWrite(statePath(reg), JSON.stringify(clean));
}

// Render the statusline badge for every active mode, ANSI colours included, and
// persist it. The statusline script only has to print the result, so the mode list
// and its colours live in one place.
//
// Colours are emitted here rather than rebuilt in bash on purpose. Guarding the
// badge file against a planted escape sequence would buy nothing: writing to
// $CLAUDE_CONFIG_DIR already means being able to edit these hooks and settings.json,
// which is arbitrary code execution. The statusline still strips stray control bytes
// so a truncated or garbled file cannot scramble the terminal.
function writeBadge(reg, levels) {
  const parts = [];
  for (const [name, modeCfg] of Object.entries(reg.modes)) {
    const level = levels[name];
    if (!level || level === 'off') continue;
    const label = modeCfg.showLevelInBadge && level !== modeCfg.default
      ? modeCfg.badge + ':' + level.toUpperCase()
      : modeCfg.badge;
    const color = Number.isInteger(modeCfg.color) && modeCfg.color >= 0 && modeCfg.color <= 255
      ? modeCfg.color
      : 244;
    parts.push(ESC + '[38;5;' + color + 'm[' + label + ']' + ESC + '[0m');
  }
  const badge = parts.join(' ').slice(0, MAX_BADGE_BYTES);
  safeWrite(badgePath(reg), badge);
}

// The rules themselves, straight from the skill. Frontmatter stripped: it is
// metadata for skill discovery, not part of the ruleset.
function readSkillBody(skill) {
  try {
    return fs.readFileSync(skillPath(skill), 'utf8').replace(/^---[\s\S]*?\n---\s*/, '');
  } catch (e) {
    return null;
  }
}

// Keep only the rows and examples belonging to the active level, so a multi-level
// skill injects one level's rules instead of all six.
// Matches two conventions: intensity table rows ("| **ultra** | ...") and
// per-level example bullets ("- ultra: ..."). Everything else passes through.
function filterToLevel(modeCfg, body, level) {
  const levels = modeCfg.levels || [];
  const aliases = Object.keys(modeCfg.aliases || {});
  const known = new Set(levels.concat(aliases));
  if (known.size === 0) return body;
  return body.split('\n').filter(line => {
    const row = line.match(/^\|\s*\*\*(\S+?)\*\*\s*\|/);
    if (row && known.has(row[1])) return canonicalLevel(modeCfg, row[1]) === level;
    const example = line.match(/^-\s+(\S+?):\s/);
    if (example && known.has(example[1])) return canonicalLevel(modeCfg, example[1]) === level;
    return true;
  }).join('\n');
}

// The ruleset to inject for one active mode, or null when there is nothing to inject.
function renderRules(name, modeCfg, level) {
  if (!level || level === 'off') return null;
  const body = readSkillBody(modeCfg.skill);
  if (!body) return null;
  const header = modeCfg.showLevelInBadge
    ? name.toUpperCase() + ' MODE ACTIVE — level: ' + level
    : name.toUpperCase() + ' MODE ACTIVE';
  return header + '\n\n' + filterToLevel(modeCfg, body, level).trim();
}

// The short per-turn nudge. Registry text with {level} and {mode} substituted.
function renderReminder(name, modeCfg, level) {
  if (!level || level === 'off' || !modeCfg.reminder) return null;
  if (!skillExists(modeCfg)) return null;
  return modeCfg.reminder.replace(/\{level\}/g, level).replace(/\{mode\}/g, name);
}

// Blank out the parts of a prompt where a mode command is being shown rather than
// issued: fenced blocks, indented blocks and inline spans. Without this, pasting
// "/caveman off" inside an example flips the mode for real.
//
// Content is replaced with blank lines instead of removed so line-anchored matching
// downstream still sees the original line structure.
function stripLiteralSpans(text) {
  return text
    .replace(/```[\s\S]*?(?:```|$)/g, m => m.replace(/[^\n]/g, ' '))
    .replace(/~~~[\s\S]*?(?:~~~|$)/g, m => m.replace(/[^\n]/g, ' '))
    .replace(/`[^`\n]*`/g, m => ' '.repeat(m.length))
    .replace(/^(?: {4}|\t)\S.*$/gm, m => ' '.repeat(m.length));
}

module.exports = {
  CLAUDE_DIR, ESC, loadRegistry, resolveAll, readState, writeState, writeBadge,
  envOverridden, stripLiteralSpans,
  canonicalLevel, skillExists, readSkillBody, filterToLevel, renderRules, renderReminder,
  safeWrite, statePath, badgePath, skillPath,
};
