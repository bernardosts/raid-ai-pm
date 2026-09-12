#!/usr/bin/env bash
# Shared helper: locate the consuming project's root regardless of whether
# this kit is used as a git submodule (typical), a plain copy, or run standalone.
# Source this after setting SCRIPT_DIR, then call: PROJECT_ROOT="$(project_root "$SCRIPT_DIR")"

# Resolve the root of the project that is USING this kit — not the kit's own
# repo root. When installed as a submodule, `--show-superproject-working-tree`
# (run from inside the submodule) returns the parent project's top level.
# Falls back to the kit's own toplevel (standalone dev/testing), then to cwd.
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
