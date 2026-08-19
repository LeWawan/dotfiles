# Global rules

## Exclude "Dependency Dashboard" when listing issues

When checking or listing a repo's issue tracker (GitLab, GitHub, etc.), always exclude the auto-generated "Dependency Dashboard" issue (Renovate's tracking issue) before presenting results.

**Why:** User mandate, 2026-05-27: "always exclude 'Dependency dashboard' when checking the issues (for now)". It's noise — an automated dependency-tracking issue, not real work. The "for now" qualifier means revisitable, but treat as default until told otherwise.

**How to apply:** Filter it out of any issue-list output (e.g. `glab issue list` / `gh issue list`) before showing the user.

## Hallucination cross-check on factual claims

After making factual claims about files, code, state, configs, or external systems — especially in reviews, audits, or "did X say Y?" type analyses — spawn parallel Explore subagents to **verify what I (the primary AI) just said**.

**Why:** User explicitly mandated it. Single-pass research (one Explore agent) is not enough — its output is a *claim*, not a verified fact. Compounding hallucinations from chained subagents are a real risk on factual reviews. User: "ca doit check ce que l'ia principale a dit et ne rien faire si c'est ok mais si c'est faux, reagir".

**How to apply:**

1. After producing factual claims (file contents, exact line numbers, exact strings, version tags, config diffs, behavioral assertions about code), enumerate the discrete claims I just stated.

2. Spawn **independent Explore subagents in parallel** (single message, multiple Agent tool calls). Pass:
   - The exact claim I made, verbatim.
   - Ask only for VERIFIED / WRONG / PARTIAL with the exact file:line quote as evidence.
   - Tell the subagent explicitly: "do NOT analyze, do NOT recommend, just verify".
   - Cap word count (e.g. under 400 words per fact-checker).

3. **Silent if all VERIFIED.** Do not narrate "I cross-checked and it's fine" — that's noise. Just continue.

4. **React loudly if WRONG/PARTIAL.** Immediately call out the discrepancy in the next user-facing message: "Correction — earlier I said X, fact-check shows Y at file:line. Updated conclusion: …". Update any downstream recommendations that depended on the wrong claim.

5. Granularity heuristic: one fact-checker per source file or per repo. Group related claims about the same file into one agent call; do not over-fragment.

6. Applies to **every session** by default — not only when the user prompts for it. Skip only when the entire task is trivially verifiable inline (e.g. a single `grep` already executed in the main loop and quoted directly).

7. The fact-check is on **my own output**, not just on subagent research. If I synthesize a claim from a research pass, the synthesis itself must be verified — subagent output is also a claim, not a verified fact.

**Concrete pattern that worked:** ROADMAP.md review on ci-components project, May 2026. 6 parallel fact-checkers (one per repo + one shared-patterns) caught a critical falsehood (roadmap claimed fasttrack used "restricted envsubst with allow-list" — actually bare envsubst at `delupay-fasttrack/.gitlab-ci.yml:193`). Without cross-check, that error would have propagated into the review.

## Commit style

When creating git commits, the user has two firm preferences:

**No `Co-Authored-By` trailer, ever.** The default Claude Code guidance suggests `Co-Authored-By: Claude Opus … <noreply@anthropic.com>`. The user has rejected this multiple times. **Do not add it.** Plain commit message only.

**Why:** User mandate, May 2026: "1. jamais de co-authored".

**Never commit until the user explicitly says so.** Make the file edits, stage them at most, and stop. Wait for "commit", "tu peux commiter", "go", or equivalent before running `git commit`. This applies even when the change feels small or obviously safe.

**Why:** User mandate, May 2026: "ne commit pas avant que je te le dise". They want a review window between the edit and the recorded history; committing eagerly forces them to revert.

**Small, atomic commits.** One concern per commit. Avoid lumping a whole feature/migration into a single ~400-line commit. Split by:
- File or file group with a single shared concern (e.g. stack file rewrite, then CI rewrite, then header doc update).
- Each commit should be reviewable in isolation; the message should fit on one line.

**Why:** User mandate: "2. jamais autant de contenu dans les commits". Big commits make review and bisect painful.

**How to apply:**
- For straightforward single-concern changes, one commit is fine.
- For a multi-concern task (e.g. CI migration with stack file changes), commit incrementally as the work progresses, OR plan the split before amending if the work is already lumped.
- When in doubt, prefer more commits, not fewer.

## Never push to remote on the user's behalf

I do not run `git push` (any branch, any remote, any tag). Pushing is the user's act, always. Same for `git push --tags`, `gh release create`, and any other operation that pushes commits or tags upstream. **Opening a merge/pull request is allowed** — `glab mr create` / `gh pr create` only open the review on a branch the user has already pushed; they push nothing themselves.

**Why:** User mandate, May 2026: "par-contre tu push jamais, c'est que moi qui fait ca". They keep full control over what gets pushed upstream — commits, tags, pipelines. Refined 2026-05-27: "je veux pas que tu push des commits mais une MR c'est ok" — creating the MR/PR is fine, pushing commits/tags is not.

**How to apply:**

- Commit locally freely (when authorized in the conversation).
- Stage and prepare branches, tags, and MR descriptions.
- **Stop before any `git push`, `git push --tags`, `gh release create`, or equivalent push.** Tell the user the local state is ready and what they should push. Creating the MR/PR itself (`glab mr create` / `gh pr create`) is allowed once the branch is pushed.
- If a workflow appears to require pushing (e.g. "try the pipeline"), set up everything locally, then describe the exact commands the user can run.
- Applies to every repo and every session by default. The only exception: the user types the exact push command themselves into the conversation (e.g. via `!`-prefixed shell) — that's them pushing, not me.

## Writing modes: caveman and unslop

Two writing modes run permanently, enforced by hooks rather than by my judgement.
`caveman` compresses how I speak. `unslop` governs word choice and punctuation.

**Why:** User mandate, 2026-08-19. Skills are model-invoked, so a matching
description alone never guarantees one fires, and a rule stated once at session start
gets pruned by context compression on a long conversation. The hooks make both
deterministic.

**How it works:** `hooks/modes.json` holds one entry per mode, each naming a skill
under `skills/<name>/SKILL.md`. The skill stays the single source of truth for the
rules. `modes-activate.js` injects the full ruleset at SessionStart, filtered to the
active level. `modes-tracker.js` re-emits a one-line reminder on every prompt and
handles switching. `modes-statusline.sh` shows the active modes in the statusline.
State lives in `~/.claude/.modes-active`.

**Switching:** `/mode <name> <level>`, e.g. `/mode caveman ultra` or `/mode unslop off`.
`/mode <name>` alone means that mode's registry default, same as `on`. `/mode` alone
reports every mode and its accepted values. Natural phrases work too ("stop caveman").
Per-mode environment override: `CLAUDE_MODE_CAVEMAN=ultra`.

The command is `/mode`, never `/caveman` or `/unslop`. Those are skill names, so typing
them makes Claude Code load the SKILL.md and answer, which is the opposite of switching
a mode off. Blocking that prompt traded the waste for a stale statusline, since a
blocked prompt produces no turn and nothing redraws the badge. A command named after no
skill avoids both. Acknowledge a switch in one short line.

`/mode` needs `commands/mode.md` to exist. Claude Code rejects an unregistered slash
command before submitting the prompt, so without that file the hook never runs and the
switch silently does nothing. The file's body is deliberately almost empty: the hook does
the work.

**Adding or removing a mode:** one mode per skill. Drop a `SKILL.md` under
`skills/<name>/`, add an entry to `modes.json`. Deleting a skill directory is enough
to retire it, the mode is skipped instead of breaking the hooks, and its stored state
is preserved in case the skill comes back.

**Division of labour:** caveman handles compression and stops at artefacts (its own
rule is "code/commits/PRs: write normal"). Unslop covers word choice and punctuation
everywhere, artefacts included. In chat both run. In commit messages, MR descriptions
and docs, unslop runs alone.

**Unslop rules that bite most often:** no em dashes, no colon as a mid-sentence
connector, sentence case headings, no decorative emojis, active voice, plain words
over "utilize"/"leverage"/"delve"/"crucial". Exempt: code, exact error strings, quoted
third-party text, file paths.
