#!/usr/bin/env bash
# Upgrade all registered LiNKdev installations from this template checkout.
set -euo pipefail
exec "$(dirname "$0")/scripts/sync-installations.sh" "$@"
