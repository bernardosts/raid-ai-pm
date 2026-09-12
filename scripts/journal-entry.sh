#!/usr/bin/env bash
# Append a timestamped entry to today's journal file, creating it if needed.
# Usage: journal-entry.sh "<entry text>"
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

if [[ $# -lt 1 ]]; then
  echo "Usage: journal-entry.sh \"<entry text>\"" >&2
  exit 1
fi

TEXT="$1"
PROJECT_ROOT="$(project_root "$SCRIPT_DIR")"
JOURNAL_DIR="$PROJECT_ROOT/docs/journal"
mkdir -p "$JOURNAL_DIR"

TODAY="$(date +%F)"
TIME="$(date +%H:%M)"
FILE="$JOURNAL_DIR/${TODAY}.md"

if [[ ! -f "$FILE" ]]; then
  echo "# Journal — ${TODAY}" > "$FILE"
  echo "" >> "$FILE"
fi

echo "- **${TIME}** — ${TEXT}" >> "$FILE"

echo "$FILE"
