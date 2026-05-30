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

  <target-repo-root>  Path to an existing git repo root
  --force             Overwrite existing LiNKdev/ and .cursor/ (destructive to pack; never deletes product/ if you merge manually)

After install:
  1. Register the repo in linktrend/LiNKdev registry/installations.json for auto-sync on future tags
  2. Principal launch lines: LiNKdev/factory/install/PRINCIPAL-LAUNCH.md

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

TARGET="$(cd "$TARGET" && pwd)"

if [[ ! -d "$SRC_LINKDEV" || ! -d "$SRC_CURSOR" ]]; then
  echo "error: template missing LiNKdev/ or .cursor/" >&2
  exit 1
fi

if [[ -e "${TARGET}/LiNKdev" || -e "${TARGET}/.cursor" ]]; then
  if [[ "$FORCE" != true ]]; then
    echo "error: target already has LiNKdev/ or .cursor/. Use --force or run scripts/sync-installations.sh <target> to upgrade factory only." >&2
    exit 1
  fi
  rm -rf "${TARGET}/LiNKdev" "${TARGET}/.cursor"
fi

VER="$(cat "$VERSION_FILE" 2>/dev/null || echo unknown)"
echo "Installing LiNKdev v${VER} → ${TARGET}"

cp -R "$SRC_LINKDEV" "${TARGET}/LiNKdev"
cp -R "$SRC_CURSOR" "${TARGET}/.cursor"

cat > "${TARGET}/LiNKdev/TEMPLATE_VERSION.md" <<EOF
# Installed LiNKdev template

| Field | Value |
|-------|-------|
| Template repo | https://github.com/linktrend/LiNKdev |
| Version | ${VER} |
| Tag | v${VER} |
| Installed | $(date -u +%Y-%m-%dT%H:%MZ) |

Register this repo in LiNKdev \`registry/installations.json\` to receive automatic sync on future template tags.
EOF

echo "Done. Next: LiNKdev/factory/install/PRINCIPAL-LAUNCH.md"
