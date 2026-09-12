# raid-ai-pm

A small, tool-agnostic kit for in-repo task tracking, journaling, and session handover — meant to be reused across projects (as a git submodule) rather than re-scaffolded by hand each time.

See [`AGENTS.md`](./AGENTS.md) for the full system description, conventions, and script usage — that file is written to be read directly by an AI agent (Claude Code, a local model, or anything else) as well as by a human.

## Layout

```
scripts/
  lib.sh              shared project-root detection, sourced by the others
  init-project.sh     one-time bootstrap for a new consuming project
  task-new.sh         create a new task in docs/tasks/backlog/
  task-move.sh        move a task between backlog/in-progress/done
  journal-entry.sh    append a timestamped entry to today's journal file
  sync-agents-md.sh   create/update the project-management section of the project's root AGENTS.md
  sync-claude-md.sh   create/update a pointer-to-AGENTS.md section in the project's root CLAUDE.md
templates/
  task.md               task file template
  handover.md           HANDOVER.md template
  agents-section.md     the marked block sync-agents-md.sh writes into AGENTS.md
  claude-md-section.md  the marked block sync-claude-md.sh writes into CLAUDE.md
AGENTS.md              full usage doc, read this first
```

## Using this in a project

```
git submodule add <this-repo-url> .pm-kit
.pm-kit/scripts/init-project.sh
```

Then point your agent/tool instructions (a Claude Code skill, an AGENTS.md reference, whatever your setup uses) at `.pm-kit/AGENTS.md`.
