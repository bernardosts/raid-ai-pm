#!/usr/bin/env bash
# Create or update the consuming project's root CLAUDE.md so it points at
# AGENTS.md instead of duplicating instructions. Marked with HTML comments
# so it can be safely re-run without touching any other content someone
# adds to the file. If CLAUDE.md doesn't exist, it's created with just
# this pointer.
# Usage: sync-claude-md.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

PROJECT_ROOT="$(project_root "$SCRIPT_DIR")"
CLAUDE_FILE="$PROJECT_ROOT/CLAUDE.md"
SECTION_TEMPLATE="$SCRIPT_DIR/../templates/claude-md-section.md"

sync_marked_block "$CLAUDE_FILE" "$SECTION_TEMPLATE" \
  "<!-- raid-ai-pm:claude:start -->" "<!-- raid-ai-pm:claude:end -->"

echo "$CLAUDE_FILE"
