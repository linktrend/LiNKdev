# LiNKdev

**Continuous Multi-Agent Software Development Orchestration** — portable factory template.

Copy **only** `LiNKdev/` + `.cursor/` into product repos. **Principal** is the single human authority (Go, Continue, promotion to `staging`/`main`).

| Path | Purpose |
|------|---------|
| `LiNKdev/` | Factory, gstack skills, virgin `product/` stubs on first install |
| `.cursor/` | Bootstrap rule → `LiNKdev/AGENTS.md` |
| `install.sh` | First-time install into a repo |
| `upgrade.sh` / `scripts/sync-installations.sh` | Push factory updates to registered repos |
| `registry/installations.json` | Repos that receive auto-sync on **tag** |
| `VERSION` | Template semver |

**Releases:** [https://github.com/linktrend/LiNKdev/releases](https://github.com/linktrend/LiNKdev/releases)

## Principal launch (wire — three lines only)

See **`LiNKdev/factory/install/PRINCIPAL-LAUNCH.md`**.

| Step | Agent | One line |
|------|--------|----------|
| A | Cursor | `Execute the EXECUTE-WIRE-LINKDEV.md prompt in LiNKdev/factory/install/` |
| B | Codex | `Execute the EXECUTE-LINKDEV-UI-AUTOMATIONS.md prompt in LiNKdev/factory/install/` |
| C | Cursor | `Execute the EXECUTE-WIRE-LINKDEV-POST-UI.md prompt in LiNKdev/factory/install/` |

Agents run autonomously; you do not walk through the checklist.

## Install (first time)

```bash
git clone https://github.com/linktrend/LiNKdev.git
cd LiNKdev
./install.sh /path/to/your-product-repo
```

Add your repo to `registry/installations.json` and configure GitHub secret **`LINKDEV_SYNC_TOKEN`** on this repo for automatic upgrades.

## Auto-update installed repos

When you tag `v*` on **LiNKdev** `main`, the workflow **Sync LiNKdev to installations** runs `scripts/sync-installations.sh` and pushes factory + shim updates to every registered repo ( **`LiNKdev/product/` is never overwritten** ).

Details: [docs/SYNC-INSTALLATIONS.md](docs/SYNC-INSTALLATIONS.md).

Manual upgrade one repo:

```bash
./scripts/sync-installations.sh /path/to/product-repo
```

## Virgin `product/` (template only)

`product/grounding/` stubs, empty `programs/`, empty `reports/`. Factory bootstrap lives under `LiNKdev/factory/programs/bootstrap/`.

## Source

Canonical studio instance: `linktrend/LiNKtrend-System` on branch `development`.
