# Sync LiNKdev to installed repos

When you improve [linktrend/LiNKdev](https://github.com/linktrend/LiNKdev), registered product repos can receive **automatic pushes** of the factory pack (not their `LiNKdev/product/` trees).

## How it works

1. You merge improvements to **LiNKdev** `main` and bump **`VERSION`**.
2. You tag a release, e.g. `v1.1.0`.
3. GitHub Action **Sync LiNKdev to installations** runs on tag push.
4. `scripts/sync-installations.sh` updates each repo in **`registry/installations.json`**:
   - Overwrites: `LiNKdev/factory/`, `LiNKdev/skills/`, portable `.cursor` shim files
   - Preserves: `LiNKdev/product/` and product `.cursor/rules/01`–`08`
   - Does **not** copy `.github/workflows/` — after sync, copy dispatch workflows once per repo (see `LiNKdev/factory/docs/DISPATCH.md`) and ensure **`CURSOR_API_KEY`** is set in each repo's GitHub Actions secrets

## Register a repo

Add to `registry/installations.json`:

```json
{
  "repo": "linktrend/your-product-repo",
  "branch": "development",
  "preserve_product": true
}
```

Commit on LiNKdev `main` before the next tag.

## Secrets (one-time studio setup)

In **LiNKdev** GitHub → Settings → Secrets:

| Secret | Purpose |
|--------|---------|
| `LINKDEV_SYNC_TOKEN` | PAT or GitHub App token with **write** access to every registered repo |

Without this secret, tags still publish the template but installations are not auto-pushed.

## Per-repo dispatch (not synced automatically)

Each **product** repository wired for LiNKdev needs:

| Item | Where |
|------|--------|
| `CURSOR_API_KEY` | GitHub Actions secrets on that repo |
| `linkdev-dispatch.yml`, `linkdev-guard.yml`, `branch-source-policy.yml` | Copy from `LiNKdev/factory/install/github/` to `.github/workflows/` |

Template version **1.2.0+** ships dispatch v2 scripts and workflow stubs in `LiNKdev/factory/`.

## Manual sync

From a LiNKdev clone:

```bash
# All registered remotes
./scripts/sync-installations.sh

# One local checkout (no push)
./scripts/sync-installations.sh /path/to/LiNKtrend-System

# Dry run
LINKDEV_SYNC_DRY_RUN=1 ./scripts/sync-installations.sh
```

## First install vs upgrade

| Action | Command |
|--------|---------|
| First time | `./install.sh /path/to/repo` |
| Upgrade factory | Tag LiNKdev → CI sync, or `./upgrade.sh` |

Installations do **not** auto-update unless the repo is in the registry **and** the sync workflow has a valid token.
