#!/usr/bin/env bash
# Create or update the project-management section of the consuming project's
# root AGENTS.md, marked with HTML comments so it can be safely re-run
# (e.g. after a kit update) without duplicating content or touching the rest
# of the file. If AGENTS.md doesn't exist, it's created with just this
# section — the project is free to add its own content around it.
# Usage: sync-agents-md.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

PROJECT_ROOT="$(project_root "$SCRIPT_DIR")"
AGENTS_FILE="$PROJECT_ROOT/AGENTS.md"
SECTION_TEMPLATE="$SCRIPT_DIR/../templates/agents-section.md"
START_MARKER="<!-- raid-ai-pm:start -->"
END_MARKER="<!-- raid-ai-pm:end -->"

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

if [[ -f "$AGENTS_FILE" ]]; then
  awk -v start="$START_MARKER" -v end="$END_MARKER" '
    $0 == start {skip=1; next}
    $0 == end {skip=0; next}
    skip != 1 {print}
  ' "$AGENTS_FILE" > "$TMP"
else
  : > "$TMP"
fi

if [[ -s "$TMP" ]]; then
  echo "" >> "$TMP"
fi

{
  echo "$START_MARKER"
  cat "$SECTION_TEMPLATE"
  echo "$END_MARKER"
} >> "$TMP"

mv "$TMP" "$AGENTS_FILE"
echo "$AGENTS_FILE"
