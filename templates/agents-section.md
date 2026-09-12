## Project management

This project tracks tasks, a running journal, and session handover in-repo rather than with an external tracker, using the shared **raid-ai-pm** kit (vendored here as a git submodule at `.pm-kit/`). Read `.pm-kit/AGENTS.md` for the full system: task file format and conventions, when to move a task between backlog/in-progress/done, the difference between the journal and the handover doc, and full script usage.

Quick reference:

```
.pm-kit/scripts/task-new.sh <slug> "<title>"                    # create a task in docs/tasks/backlog/
.pm-kit/scripts/task-move.sh <id> <backlog|in-progress|done>    # move a task, updates its frontmatter
.pm-kit/scripts/journal-entry.sh "<entry text>"                 # append a dated journal entry
```

Before starting work in this repo: read `docs/HANDOVER.md` first, then check `docs/tasks/in-progress/` for anything already underway. Update `docs/HANDOVER.md` and log a journal entry at natural checkpoints and at the end of any session that changed project state — see `.pm-kit/AGENTS.md` for what belongs in which.
