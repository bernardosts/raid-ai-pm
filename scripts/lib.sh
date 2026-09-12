#!/usr/bin/env bash
# Shared helpers, sourced by the other scripts after they set SCRIPT_DIR.

# Resolve the root of the project that is USING this kit — not the kit's own
# repo root. When installed as a submodule, `--show-superproject-working-tree`
# (run from inside the submodule) returns the parent project's top level.
# Falls back to the kit's own toplevel (standalone dev/testing), then to cwd.
# Call: PROJECT_ROOT="$(project_root "$SCRIPT_DIR")"
project_root() {
  local script_dir="$1"
  local super_root
  super_root="$(git -C "$script_dir" rev-parse --show-superproject-working-tree 2>/dev/null || true)"
  if [[ -n "$super_root" ]]; then
    echo "$super_root"
    return
  fi
  git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null || pwd
}

# Write (or update in place) a marked, replaceable block inside a target file,
# without touching anything else in it. Creates the file with just the block
# if it doesn't exist yet. Idempotent — safe to re-run after the kit updates
# the template.
# Call: sync_marked_block <target_file> <template_file> <start_marker> <end_marker>
sync_marked_block() {
  local target_file="$1"
  local template_file="$2"
  local start_marker="$3"
  local end_marker="$4"

  local tmp
  tmp="$(mktemp)"
  trap 'rm -f "$tmp"' RETURN

  if [[ -f "$target_file" ]]; then
    awk -v start="$start_marker" -v end="$end_marker" '
      $0 == start {skip=1; next}
      $0 == end {skip=0; next}
      skip != 1 {print}
    ' "$target_file" > "$tmp"
  else
    : > "$tmp"
  fi

  if [[ -s "$tmp" ]]; then
    echo "" >> "$tmp"
  fi

  {
    echo "$start_marker"
    cat "$template_file"
    echo "$end_marker"
  } >> "$tmp"

  mv "$tmp" "$target_file"
}
