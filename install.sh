#!/usr/bin/env bash
# LiNKdev template installer — copies LiNKdev/ and .cursor/ into a target repository.
set -euo pipefail

TEMPLATE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_FILE="${TEMPLATE_ROOT}/VERSION"
SRC_LINKDEV="${TEMPLATE_ROOT}/LiNKdev"
SRC_CURSOR="${TEMPLATE_ROOT}/.cursor"

usage() {
  cat <<'EOF'
Usage: install.sh <target-repo-root> [--force]

Copies LiNKdev/ and .cursor/ from this template into the target repository.

  <target-repo-root>  Absolute or relative path to an existing git repo root
  --force             Overwrite existing LiNKdev/ and .cursor/ (destructive)

Examples:
  ./install.sh ../my-app
  ./install.sh /Users/me/Projects/my-app --force

After install:
  1. Open the target repo in Cursor
  2. Follow LiNKdev/factory/install/CHECKLIST.md (wire flow)
  3. Principal says Go when wire + automations are ready

EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

TARGET="${1:-}"
FORCE=false
if [[ "${2:-}" == "--force" ]]; then
  FORCE=true
fi

if [[ -z "$TARGET" ]]; then
  usage >&2
  exit 1
fi

TARGET="$(cd "$TARGET" 2>/dev/null && pwd)" || {
  echo "error: target directory does not exist: $1" >&2
  exit 1
}

if [[ ! -d "$SRC_LINKDEV" || ! -d "$SRC_CURSOR" ]]; then
  echo "error: template missing LiNKdev/ or .cursor/ under ${TEMPLATE_ROOT}" >&2
  exit 1
fi

if [[ -e "${TARGET}/LiNKdev" || -e "${TARGET}/.cursor" ]]; then
  if [[ "$FORCE" != true ]]; then
    echo "error: ${TARGET} already has LiNKdev/ or .cursor/. Re-run with --force to replace." >&2
    exit 1
  fi
  rm -rf "${TARGET}/LiNKdev" "${TARGET}/.cursor"
fi

echo "Installing LiNKdev from template $(cat "$VERSION_FILE" 2>/dev/null || echo unknown) → ${TARGET}"

cp -R "$SRC_LINKDEV" "${TARGET}/LiNKdev"
cp -R "$SRC_CURSOR" "${TARGET}/.cursor"

echo "Done."
echo "  LiNKdev/  → ${TARGET}/LiNKdev"
echo "  .cursor/  → ${TARGET}/.cursor"
echo "Next: LiNKdev/factory/install/CHECKLIST.md"
