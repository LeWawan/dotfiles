---
name: mr-create
description: Create a GitLab merge request with glab on delupay repos — default assignee @erwan.kreutz, reviewer @vincent.pichot, target edge, with a branch-state guard. Use when the user says "create the MR", "open an MR", "submit this for review", invokes /mr-create, or asks to turn the current branch into a merge request.
---

# mr-create

Create a GitLab MR with `glab`. Delupay repos live on GitLab — `gh` does not work here.

**Hard rule: never push.** The user pushes branches themselves (`git push`, `git push -u`). This skill only runs `glab mr create` once the branch is already on origin. If a push is needed, print the exact command and stop — do not run it.

## Workflow

1. **Current branch** — `git rev-parse --abbrev-ref HEAD`.

2. **Branch-state guard:**
   - **On an integration branch** (`edge`, `preprod`, `prod`): STOP. You cannot MR from these as source. Suggest a feature branch named from the commit subject (`feat/<slug>`, `fix/<slug>`, `chore/<slug>`) and print, then wait:
     ```
     git switch -c feat/<slug>
     git push -u origin feat/<slug>
     ```
   - **On a feature branch** — check it is pushed and in sync: `git status -sb` (first line) vs `@{upstream}`.
     - No upstream, or local ahead of origin (unpushed commits): STOP, print `git push -u origin <branch>`, tell the user to push. Do not push.
     - Pushed and in sync: proceed.

3. **Target branch** — `edge` if origin has it (`git ls-remote --heads origin edge`), else the repo default (`git symbolic-ref --short refs/remotes/origin/HEAD`).

4. **People** — defaults: assignee `erwan.kreutz`, reviewer `vincent.pichot`. Override either if the user names someone in the prompt (e.g. "reviewer @alice").

5. **Title + description** — title from the latest commit subject (or the branch's commit range). Description: short `## What` / `## Why` / `## Notes`. **No Claude / "Generated with" attribution** in the body (user dislikes attribution noise).

6. **Create:**
   ```bash
   glab mr create \
     --source-branch <branch> \
     --target-branch <target> \
     --title "<commit subject>" \
     --description "<## What / ## Why / ## Notes>" \
     --assignee erwan.kreutz \
     --reviewer vincent.pichot \
     --yes
   ```

7. **Return the MR URL** that glab prints.

## Checklist

- [ ] Not on `edge`/`preprod`/`prod` (else ask for a feature branch, stop)
- [ ] Source branch pushed + in sync with origin (else print push cmd, stop — never push)
- [ ] Target resolved (`edge` or repo default)
- [ ] Assignee/reviewer = defaults unless overridden
- [ ] No attribution trailer in the description
- [ ] MR URL returned
