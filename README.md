# LiNKdev

**Continuous Multi-Agent Software Development Orchestration** — portable factory template (v1.0.0).

LiNKdev is the productized name for the LiNKdev factory: a copyable pack that wires Cursor, Codex, and peer executors into a governed **Programs → Modules → Phases → Issues** loop with proof, gates, and progressive disclosure for agents.

## What you get

| Path | Purpose |
|------|---------|
| `LiNKdev/` | Factory (`factory/`), universal skills (`skills/gstack/`), virgin `product/` stubs |
| `.cursor/` | Portable Cursor bootstrap (entry rule → `LiNKdev/AGENTS.md`) |
| `install.sh` | Copy `LiNKdev/` and `.cursor/` into a target repository |
| `VERSION` | Template semver (`1.0.0`) |

There is **no** root `AGENTS.md`. Agents start from `.cursor/rules/00-linkdev-bootstrap.mdc`, then `LiNKdev/AGENTS.md` and `LiNKdev/factory/SPEC.md`.

## Human authority: Principal (not Chairman)

This template uses **Principal** for the single human authority who approves Go, Continue, Release OK, and promotion to `staging` / `main`. LiNKtrend-hosted repos may still say Principal in older factory copy; new installs should standardize on Principal in product grounding and program docs.

## Install into a product repo

From this template directory (or after cloning the published LiNKdev template repo):

```bash
./install.sh /path/to/your-product-repo
```

Then open the target repo in Cursor and run the wire flow: `LiNKdev/factory/install/WIRE-PROMPT.md` and `LiNKdev/factory/install/CHECKLIST.md`.

## Virgin `product/`

- **grounding/** — `VISION.md`, `SHIP_CRITERIA.md`, `INTENT.md`, `CONSTRAINTS.md`, `GLOSSARY.md` (minimal stubs)
- **programs/** — empty except `README.md` (Planner creates `<program-id>/` after Principal **Go**)
- **reports/** — empty except `README.md`

Factory bootstrap history remains under `LiNKdev/factory/programs/bootstrap/` (not under `product/`).

## First run (summary)

1. `install.sh` → target repo
2. Wire — checklist + GitHub labels + automations
3. Principal **Go** → cloud Planner → program under `LiNKdev/product/programs/`
4. Autonomous issue loop per `LiNKdev/factory/SPEC.md`

## Source

Built from `LiNKdev/` in LiNKtrend-System; published as a standalone template without LiNKtrend product grounding or `archive/`.
