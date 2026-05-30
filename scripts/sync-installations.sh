#!/usr/bin/env bash
# Push LiNKdev template updates to repos listed in registry/installations.json
set -euo pipefail

TEMPLATE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export TEMPLATE_ROOT
REGISTRY="${TEMPLATE_ROOT}/registry/installations.json"
VERSION="$(tr -d '[:space:]' < "${TEMPLATE_ROOT}/VERSION")"
SRC_LINKDEV="${TEMPLATE_ROOT}/LiNKdev"
SRC_CURSOR_SHIM="${TEMPLATE_ROOT}/LiNKdev/factory/install/portable-cursor/.cursor"
DRY_RUN="${LINKDEV_SYNC_DRY_RUN:-0}"

usage() {
  cat <<EOF
Usage:
  sync-installations.sh              # sync all repos in registry/installations.json
  sync-installations.sh /path/to/repo  # sync one local checkout (no git push)

Environment:
  LINKDEV_SYNC_DRY_RUN=1   print actions only
  GITHUB_TOKEN             required for git push in CI (uses gh auth if unset)

EOF
}

sync_to_path() {
  local target="$1"
  if [[ ! -d "${target}/LiNKdev" ]]; then
    echo "ERROR: ${target} has no LiNKdev/ — run install.sh first" >&2
    return 1
  fi

  rsync -a --delete "${SRC_LINKDEV}/factory/" "${target}/LiNKdev/factory/"
  rsync -a --delete "${SRC_LINKDEV}/skills/" "${target}/LiNKdev/skills/"
  cp "${SRC_LINKDEV}/AGENTS.md" "${target}/LiNKdev/AGENTS.md"
  cp "${SRC_LINKDEV}/README.md" "${target}/LiNKdev/README.md"

  cat > "${target}/LiNKdev/TEMPLATE_VERSION.md" <<EOF
# Installed LiNKdev template

| Field | Value |
|-------|-------|
| Template repo | https://github.com/linktrend/LiNKdev |
| Version | ${VERSION} |
| Tag | v${VERSION} |
| Last sync | $(date -u +%Y-%m-%dT%H:%MZ) |
| Synced by | scripts/sync-installations.sh |

\`LiNKdev/product/\` is owned by this repo and is **not** overwritten on sync.
EOF

  mkdir -p "${target}/.cursor/rules" "${target}/.cursor/commands" "${target}/.cursor/skills" "${target}/.cursor/agents"
  rsync -a "${SRC_CURSOR_SHIM}/commands/" "${target}/.cursor/commands/"
  rsync -a "${SRC_CURSOR_SHIM}/rules/00-linkdev-bootstrap.mdc" "${target}/.cursor/rules/"
  rsync -a "${SRC_CURSOR_SHIM}/skills/README.md" "${target}/.cursor/skills/"
  rsync -a "${SRC_CURSOR_SHIM}/agents/README.md" "${target}/.cursor/agents/"
}

sync_remote() {
  local repo="$1"
  local branch="$2"
  local work
  work="$(mktemp -d)"

  echo "== sync ${repo}@${branch} (template v${VERSION}) =="

  if [[ "$DRY_RUN" == "1" ]]; then
    echo "DRY_RUN: clone https://github.com/${repo}.git -b ${branch} and sync"
    rm -rf "$work"
    return 0
  fi

  git clone --depth 1 --branch "$branch" "https://github.com/${repo}.git" "${work}/repo"
  sync_to_path "${work}/repo"

  (
    cd "${work}/repo"
    git add LiNKdev/factory LiNKdev/skills LiNKdev/AGENTS.md LiNKdev/README.md LiNKdev/TEMPLATE_VERSION.md \
      .cursor/commands .cursor/rules/00-linkdev-bootstrap.mdc .cursor/skills/README.md .cursor/agents/README.md
    if git diff --staged --quiet; then
      echo "No changes for ${repo}"
      exit 0
    fi
    git commit -m "chore(linkdev): sync template v${VERSION} from linktrend/LiNKdev"
    git push origin "$branch"
  )
  rm -rf "$work"
  echo "OK: pushed ${repo}@${branch}"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ -n "${1:-}" ]]; then
  target="$(cd "$1" && pwd)"
  sync_to_path "$target"
  echo "OK: local sync → ${target} (commit and push yourself)"
  exit 0
fi

if [[ ! -f "$REGISTRY" ]]; then
  echo "ERROR: missing $REGISTRY" >&2
  exit 1
fi

while IFS=$'\t' read -r repo branch; do
  [[ -n "$repo" ]] || continue
  sync_remote "$repo" "${branch:-development}"
done < <(python3 - "$REGISTRY" <<'PY'
import json, sys
for row in json.load(open(sys.argv[1]))["installations"]:
    print(row["repo"] + "\t" + row.get("branch", "development"))
PY
)

echo "== all installations synced =="
