#!/usr/bin/env node
// modes — hardened filesystem helpers.
//
// The hooks keep two small files at predictable paths under $CLAUDE_CONFIG_DIR: the mode
// state and the rendered badge. Both get read on every prompt and every statusline
// redraw, so a symlink planted at either path would pull an unrelated file into model
// context or print it to the terminal. Every read and write here refuses to follow a
// symlink at the target, and reads are size-capped.
//
// $CLAUDE_CONFIG_DIR itself may legitimately be a symlink, which stow and split-disk
// setups rely on. So the parent directory gets resolved and its owner checked, rather
// than refused outright.
//
// Nothing here throws. A hook must never break a session over a best-effort state file.
// Set CLAUDE_MODES_DEBUG=1 to see on stderr why an operation was refused.

'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const O_NOFOLLOW = typeof fs.constants.O_NOFOLLOW === 'number' ? fs.constants.O_NOFOLLOW : 0;

function debug(message) {
  if (process.env.CLAUDE_MODES_DEBUG === '1') {
    process.stderr.write('[modes] ' + message + '\n');
  }
}

// True when the current user owns dir. Falls back to a home-prefix check on Windows,
// where uids do not exist.
function isOwnedByUser(dir, stat) {
  if (typeof process.getuid === 'function') {
    if (stat.uid === process.getuid()) return true;
    debug(dir + ' belongs to uid ' + stat.uid + ', not ' + process.getuid());
    return false;
  }
  const home = path.resolve(os.homedir()).toLowerCase();
  const target = path.resolve(dir).toLowerCase();
  if (target === home || target.startsWith(home + path.sep)) return true;
  debug(target + ' sits outside ' + home);
  return false;
}

// The real directory to write into, or null if it is not safe to. A symlinked parent is
// followed only when the resolved target is a directory the user owns.
function resolveOwnedDir(dir) {
  try {
    fs.mkdirSync(dir, { recursive: true });
    if (!fs.lstatSync(dir).isSymbolicLink()) return dir;

    const real = fs.realpathSync(dir);
    const stat = fs.statSync(real);
    if (!stat.isDirectory()) {
      debug(real + ' is not a directory');
      return null;
    }
    return isOwnedByUser(real, stat) ? real : null;
  } catch (error) {
    debug('cannot resolve ' + dir + ': ' + error.code);
    return null;
  }
}

// File contents as a string, or null. Refuses symlinks and anything over maxBytes rather
// than truncating, since a file that large is not one we wrote.
function readCapped(filePath, maxBytes) {
  let handle;
  try {
    const stat = fs.lstatSync(filePath);
    if (stat.isSymbolicLink() || !stat.isFile()) {
      debug(filePath + ' is not a regular file');
      return null;
    }
    if (stat.size > maxBytes) {
      debug(filePath + ' is ' + stat.size + ' bytes, over the ' + maxBytes + ' cap');
      return null;
    }

    handle = fs.openSync(filePath, fs.constants.O_RDONLY | O_NOFOLLOW);
    const buffer = Buffer.alloc(maxBytes);
    const read = fs.readSync(handle, buffer, 0, maxBytes, 0);
    return buffer.slice(0, read).toString('utf8');
  } catch (error) {
    if (error.code !== 'ENOENT') debug('cannot read ' + filePath + ': ' + error.code);
    return null;
  } finally {
    if (handle !== undefined) fs.closeSync(handle);
  }
}

// Write content in one step: a fresh temp file at 0600, then rename over the target. A
// reader therefore sees either the old contents or the new ones, never a half-written
// file. Returns whether it worked.
function writeAtomic(filePath, content) {
  const dir = resolveOwnedDir(path.dirname(filePath));
  if (!dir) return false;

  const target = path.join(dir, path.basename(filePath));
  try {
    // A symlink at the target is the actual clobber vector, so it is always refused.
    if (fs.lstatSync(target).isSymbolicLink()) {
      debug(target + ' is a symlink');
      return false;
    }
  } catch (error) {
    if (error.code !== 'ENOENT') return false;
  }

  const temp = path.join(dir, '.' + path.basename(filePath) + '.' + process.pid + '.tmp');
  let handle;
  try {
    const flags = fs.constants.O_WRONLY | fs.constants.O_CREAT | fs.constants.O_EXCL | O_NOFOLLOW;
    handle = fs.openSync(temp, flags, 0o600);
    fs.writeSync(handle, String(content));
    fs.closeSync(handle);
    handle = undefined;
    fs.renameSync(temp, target);
    return true;
  } catch (error) {
    debug('cannot write ' + target + ': ' + error.code);
    if (handle !== undefined) {
      try { fs.closeSync(handle); } catch (ignored) { /* already closing down */ }
    }
    try { fs.unlinkSync(temp); } catch (ignored) { /* nothing to clean up */ }
    return false;
  }
}

module.exports = { readCapped, writeAtomic, debug };
