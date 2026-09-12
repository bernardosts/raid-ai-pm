#!/usr/bin/env bash
# Create a new task file in <project>/docs/tasks/backlog with the next sequential id.
# Usage: task-new.sh <slug> "<title>"
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

if [[ $# -lt 2 ]]; then
  echo "Usage: task-new.sh <slug> \"<title>\"" >&2
  exit 1
fi

SLUG="$1"
TITLE="$2"

if [[ ! "$SLUG" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "Slug must be lowercase-kebab-case (e.g. generalize-frs-niches)" >&2
  exit 1
fi

PROJECT_ROOT="$(project_root "$SCRIPT_DIR")"
TASKS_DIR="$PROJECT_ROOT/docs/tasks"
TEMPLATE="$SCRIPT_DIR/../templates/task.md"

mkdir -p "$TASKS_DIR/backlog" "$TASKS_DIR/in-progress" "$TASKS_DIR/done"

MAX_ID=0
for f in "$TASKS_DIR"/backlog/*.md "$TASKS_DIR"/in-progress/*.md "$TASKS_DIR"/done/*.md; do
  [[ -e "$f" ]] || continue
  base="$(basename "$f")"
  id="${base%%-*}"
  if [[ "$id" =~ ^[0-9]+$ ]]; then
    id_num=$((10#$id))
    if (( id_num > MAX_ID )); then
      MAX_ID=$id_num
    fi
  fi
done

NEXT_ID=$(printf "%04d" $((MAX_ID + 1)))
TODAY="$(date +%F)"
DEST="$TASKS_DIR/backlog/${NEXT_ID}-${SLUG}.md"

sed \
  -e "s/^id: NNNN/id: ${NEXT_ID}/" \
  -e "s/^title: <short title>/title: ${TITLE}/" \
  -e "s/^created: YYYY-MM-DD/created: ${TODAY}/" \
  -e "s/^updated: YYYY-MM-DD/updated: ${TODAY}/" \
  "$TEMPLATE" > "$DEST"

echo "$DEST"
