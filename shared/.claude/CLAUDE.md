# Global rules

Personal mandates for every project and every session. Each rule carries the reason it
exists, because a rule without its reason gets re-litigated or quietly dropped.

Rules are ordered by how often they apply.

## Writing and coding modes: caveman, unslop, ponytail

Three modes run permanently, enforced by hooks rather than left to my judgement.
`caveman` compresses how I speak. `unslop` governs word choice and punctuation. `ponytail`
governs what I build: laziest solution that works, YAGNI first, reuse before writing.

**Why:** User mandate, 2026-08-19. Skills are model-invoked, so a matching description
never guarantees one fires. And a rule stated once at session start gets pruned by context
compression on a long conversation. The hooks make all three deterministic.

**Division of labour.** Caveman handles compression and stops at artefacts, its own rule
being "code/commits/PRs: write normal". Unslop covers word choice and punctuation
everywhere, artefacts included. Ponytail covers code shape, not prose, it pairs with
caveman rather than competing with it. In chat all three run. In commit messages, MR
descriptions and docs, unslop runs alone. On coding tasks, ponytail runs alongside
whichever of the other two applies.

**Unslop rules that bite most often:** no em dashes, no colon as a mid-sentence connector,
sentence case headings, no decorative emojis, active voice, plain words over
"utilize"/"leverage"/"delve"/"crucial". Exempt: code, exact error strings, quoted
third-party text, file paths.

**Switching:** `/mode <name> <level>`, for instance `/mode caveman ultra` or
`/mode unslop off`. `/mode <name>` alone means that mode's default, same as `on`. `/mode`
alone reports every mode and its accepted values. Natural phrases work too, such as "stop
caveman". Single-session override: `CLAUDE_MODE_CAVEMAN=ultra`. Acknowledge a switch in
one short line.

The command is `/mode`, never `/caveman` or `/unslop`. Those are skill names, so typing
one loads its SKILL.md and starts a turn, the opposite of switching a mode off.

**How it works:** `hooks/modes.json` lists one mode per skill. `modes-activate.js` injects
the full ruleset at SessionStart, filtered to the active level. `modes-tracker.js` re-emits
a short reminder on every prompt and applies switches. `modes-statusline.sh` prints the
badge. State sits in `~/.claude/.modes-active`. The hook headers carry the design detail,
including why `commands/mode.md` has to exist.

**Adding or removing a mode:** drop a `SKILL.md` under `skills/<name>/` and add an entry
to `modes.json`. Deleting the skill directory retires the mode. It gets skipped instead of
breaking the hooks, and its stored level is kept in case the skill comes back.

## Cross-check my own factual claims

After stating facts about files, code, state, configs or external systems, verify what I
just said. This applies to every session by default, not only when asked.

**Why:** User mandate: "ca doit check ce que l'ia principale a dit et ne rien faire si
c'est ok mais si c'est faux, reagir". A single research pass produces a claim, not a
verified fact, and chained subagents compound each other's inventions.

It caught a real error once. Reviewing ROADMAP.md on ci-components in May 2026, six
parallel fact-checkers found the roadmap claiming fasttrack used "restricted envsubst with
an allow-list" when `delupay-fasttrack/.gitlab-ci.yml:193` ran bare envsubst. Without the
cross-check that falsehood would have shipped inside the review.

**What counts as a claim:** file contents, exact line numbers, exact strings, version
tags, config diffs, assertions about how code behaves.

**How to apply:**

1. Enumerate the discrete claims I just stated.
2. Spawn independent Explore subagents in parallel, one message with several Agent calls.
   Give each the exact claim verbatim. Ask only for VERIFIED, WRONG or PARTIAL with a
   `file:line` quote as evidence. Say explicitly: do not analyse, do not recommend, just
   verify. Cap the answer, roughly 400 words.
3. One fact-checker per source file or per repo. Group claims about the same file into one
   call rather than fragmenting.
4. **Silent when everything is VERIFIED.** Announcing a clean cross-check is noise.
5. **Loud on WRONG or PARTIAL.** Say it in the next message: "Correction, earlier I said
   X, the fact-check shows Y at file:line. Updated conclusion: ...". Then fix every
   downstream recommendation that leaned on the wrong claim.

The check covers my own output, not just subagent research. A synthesis built from a
research pass is itself a claim.

**When subagents are unavailable.** Some sessions forbid the Agent tool. The mandate then
still holds, so verify inline instead: re-read the file, re-run the grep, quote the line.
Never skip verification because the preferred mechanism is off, and never call Agent where
the session forbids it.

**When to skip:** the whole task is verifiable inline and already was, for example a
single grep run in this turn and quoted directly.

## Never commit until told

Make the edits, stage them at most, then stop. Wait for "commit", "tu peux commiter", "go"
or equivalent before running `git commit`. This holds even when the change looks small and
obviously safe.

**Why:** User mandate, May 2026: "ne commit pas avant que je te le dise". They want a
review window between the edit and recorded history. Committing eagerly forces them to
revert.

## Commit style

**No `Co-Authored-By` trailer, ever.** Default Claude Code guidance suggests one. The user
has rejected it repeatedly. Plain commit message only.

**Why:** User mandate, May 2026: "1. jamais de co-authored".

**Small, atomic commits.** One concern each. Never lump a whole feature or migration into
one 400-line commit. Split by file or file group sharing a single concern, for instance the
stack file rewrite, then the CI rewrite, then the header doc update. Each commit should be
reviewable on its own and its message should fit on one line.

**Why:** User mandate: "2. jamais autant de contenu dans les commits". Big commits make
review and bisect painful.

**How to apply:** one commit is fine for a single-concern change. For multi-concern work,
commit incrementally as it progresses, or plan the split before amending if it is already
lumped. When unsure, prefer more commits.

## Never push to remote

I do not run `git push`, on any branch, any remote, any tag. Same for `git push --tags`,
`gh release create` and anything else that sends commits or tags upstream. Pushing is the
user's act, always.

**Why:** User mandate, May 2026: "par-contre tu push jamais, c'est que moi qui fait ca".
They keep full control over what reaches the remote, commits, tags and pipelines alike.

**Opening a merge or pull request is allowed.** Refined 2026-05-27: "je veux pas que tu
push des commits mais une MR c'est ok". `glab mr create` and `gh pr create` open a review
on a branch the user already pushed, they push nothing themselves.

**How to apply:**

- Commit locally as authorised in the conversation.
- Prepare branches, tags and MR descriptions freely.
- Stop before any push. Say the local state is ready and name what to push.
- When a workflow seems to need a push, such as "try the pipeline", set everything up
  locally and give the exact commands to run.
- The only exception: the user types the push command themselves, for instance through a
  `!`-prefixed shell. That is them pushing, not me.

## Skip the Dependency Dashboard issue

When listing a repo's issues on GitLab or GitHub, filter out the auto-generated "Dependency
Dashboard" issue before showing results.

**Why:** User mandate, 2026-05-27: "always exclude 'Dependency dashboard' when checking the
issues (for now)". Renovate's tracking issue is noise, not real work. The "for now" makes
it revisitable, so treat it as the default until told otherwise.
