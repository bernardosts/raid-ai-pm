#!/usr/bin/env bash
# Move a task file between backlog/in-progress/done and update its frontmatter.
# Usage: task-move.sh <id> <backlog|in-progress|done>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

VALID_STATUSES=("backlog" "in-progress" "done")

if [[ $# -ne 2 ]]; then
  echo "Usage: task-move.sh <id> <backlog|in-progress|done>" >&2
  exit 1
fi

ID="$1"
TO="$2"

if [[ ! " ${VALID_STATUSES[*]} " =~ " ${TO} " ]]; then
  echo "Invalid status '$TO'. Must be one of: ${VALID_STATUSES[*]}" >&2
  exit 1
fi

PROJECT_ROOT="$(project_root "$SCRIPT_DIR")"
TASKS_DIR="$PROJECT_ROOT/docs/tasks"

SRC=""
for status in "${VALID_STATUSES[@]}"; do
  match=$(find "$TASKS_DIR/$status" -maxdepth 1 -name "${ID}-*.md" -print -quit 2>/dev/null)
  if [[ -n "$match" ]]; then
    SRC="$match"
    break
  fi
done

if [[ -z "$SRC" ]]; then
  echo "No task found with id '$ID'" >&2
  exit 1
fi

BASE="$(basename "$SRC")"
DEST="$TASKS_DIR/$TO/$BASE"
TODAY="$(date +%F)"

sed -i \
  -e "s/^status: .*/status: ${TO}/" \
  -e "s/^updated: .*/updated: ${TODAY}/" \
  "$SRC"

mv "$SRC" "$DEST"
echo "$DEST"
