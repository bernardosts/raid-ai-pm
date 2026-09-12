#!/usr/bin/env bash
# One-time bootstrap for a project newly consuming this kit: creates
# docs/tasks/{backlog,in-progress,done}, docs/journal/, docs/HANDOVER.md,
# and the project-management section of AGENTS.md, if they don't already
# exist. Safe to re-run — never overwrites existing docs/HANDOVER.md, and
# the AGENTS.md section is a marked, replaceable block (see sync-agents-md.sh).
# Usage: init-project.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

PROJECT_ROOT="$(project_root "$SCRIPT_DIR")"
TASKS_DIR="$PROJECT_ROOT/docs/tasks"
JOURNAL_DIR="$PROJECT_ROOT/docs/journal"
HANDOVER="$PROJECT_ROOT/docs/HANDOVER.md"

mkdir -p "$TASKS_DIR/backlog" "$TASKS_DIR/in-progress" "$TASKS_DIR/done" "$JOURNAL_DIR"
touch "$TASKS_DIR/backlog/.gitkeep" "$TASKS_DIR/in-progress/.gitkeep" "$TASKS_DIR/done/.gitkeep"

if [[ ! -f "$HANDOVER" ]]; then
  sed "s/YYYY-MM-DD/$(date +%F)/" "$SCRIPT_DIR/../templates/handover.md" > "$HANDOVER"
  echo "Created $HANDOVER"
else
  echo "$HANDOVER already exists — left untouched"
fi

AGENTS_FILE="$("$SCRIPT_DIR/sync-agents-md.sh")"
echo "Synced project-management section into $AGENTS_FILE"

echo "Project scaffolding ready under $PROJECT_ROOT/docs/"
