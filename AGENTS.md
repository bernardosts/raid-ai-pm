# raid-ai-pm — in-repo project management for AI-driven work

This is a tool-agnostic task-tracking, journal, and handover system meant to be dropped into any project (typically as a git submodule at `.pm-kit/`) so an AI agent — or a human — can track work, log reasoning, and resume cold across sessions without an external tracker and without re-deriving context from git history alone.

It has no dependency on any specific agent/tool — the same scripts and conventions work whether you're using Claude Code, a local model, or anything else that can run bash and read markdown.

Three pieces, each with a distinct job — don't blend them:

- **`docs/tasks/`** (in the consuming project) — what to do. Durable, one file per unit of work.
- **`docs/journal/`** (in the consuming project) — what happened, and why, in narrative form. Append-only, dated, never edited after the fact.
- **`docs/HANDOVER.md`** (in the consuming project) — where things stand *right now*. Overwritten each session, not appended.

The kit itself (this repo) only provides the scripts and templates that generate/maintain those three things — it does not hold any project's actual tasks/journal/handover content.

## First-time setup in a new project

After adding this repo as a submodule (conventionally at `.pm-kit/`), run:

```
.pm-kit/scripts/init-project.sh
```

This creates `docs/tasks/{backlog,in-progress,done}/`, `docs/journal/`, and `docs/HANDOVER.md` (from the template) in the consuming project if they don't already exist. Safe to re-run.

## Starting a session

1. Read `docs/HANDOVER.md` first — it's the fastest path back to current context.
2. Skim recent `docs/journal/YYYY-MM-DD.md` files if `HANDOVER.md` references something that needs more detail.
3. Check `docs/tasks/in-progress/` for anything already underway before starting new work.

## Tasks (`docs/tasks/{backlog,in-progress,done}/`)

Each task is one markdown file, named `NNNN-slug.md`, with YAML frontmatter (`id`, `title`, `status`, `created`, `updated`, `links`) plus Goal / Context / Acceptance criteria / Notes sections (see `templates/task.md`). The file's folder location *is* its status — moving the file between folders and updating its frontmatter are the same action.

Use the scripts for both — they're mechanical (id allocation, frontmatter fields, file location) and doing them by hand risks id collisions or a stale `status:` field that disagrees with the folder:

```
.pm-kit/scripts/task-new.sh <slug> "<title>"                    # creates docs/tasks/backlog/NNNN-slug.md, prints the path
.pm-kit/scripts/task-move.sh <id> <backlog|in-progress|done>    # moves + updates status/updated, prints the new path
```

After creating a task with `task-new.sh`, fill in Goal/Context/Acceptance criteria by hand — that part isn't mechanical. Use `[[docs/path.md]]` or `[[NNNN]]` to link to related docs/tasks instead of re-explaining background that already lives elsewhere.

Move a task to `in-progress` when you actually start it, not when you plan to. Move it to `done` only once its acceptance criteria are met — if scope changed along the way, update the criteria first so `done` stays honest.

## Journal (`docs/journal/YYYY-MM-DD.md`)

One file per calendar day, append-only. This is *why* something happened — decisions, dead ends, things ruled out and why — the detail a commit message won't carry and `HANDOVER.md` is too terse for. Append an entry:

```
.pm-kit/scripts/journal-entry.sh "short description of what happened or was decided"
```

Write entries as you go at natural checkpoints (a decision made, a task moved, an approach abandoned), not just at session end — the point is to capture things before they're forgotten, not to reconstruct them later.

## Handover (`docs/HANDOVER.md`)

Single file, always current, sections: **Current focus**, **Recent decisions**, **Open threads**, **Next steps**. No script for this one — writing it requires judgment about what's actually load-bearing for the next session, so edit it directly at the end of any session that changed project state (new decisions, tasks moved, direction shifted). Don't let it grow into a log — that's the journal's job. If a line in "Recent decisions" or "Open threads" is no longer relevant, remove it rather than leaving it to accumulate.

## How the scripts find the right project

Every script auto-detects the *consuming* project's root, not the kit's own — so the same scripts work whether invoked from `.pm-kit/scripts/...` in any project. Detection order: if run from inside a git submodule, the parent (superproject) root; otherwise the kit's own repo root; otherwise the current directory. You never need to configure a path by hand.

## Maintaining this kit

Changes to the scripts/templates/this doc happen in this repo, independent of any consuming project. Projects that use this kit as a submodule pick up changes only when they explicitly update the submodule pointer (`cd .pm-kit && git pull && cd .. && git add .pm-kit && git commit`) — so an update here never silently changes behavior in a project that hasn't opted in.
