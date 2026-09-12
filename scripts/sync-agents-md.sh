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

sync_marked_block "$AGENTS_FILE" "$SECTION_TEMPLATE" \
  "<!-- raid-ai-pm:start -->" "<!-- raid-ai-pm:end -->"

echo "$AGENTS_FILE"
