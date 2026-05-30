# LiNKdev

Portable **Continuous Multi-Agent Software Development Orchestration** pack. Copy with **`.cursor/`** + **`LiNKdev/`** into a product repository (or use repo-root `install.sh` from the template).

## Structure

```
LiNKdev/
  AGENTS.md              # Agent entry (read after .cursor bootstrap)
  factory/               # Same on every repo (SPEC, STATE, install, bootstrap program)
  product/               # Filled per repo (virgin stubs in template)
    grounding/           # Vision, ship criteria, intent, constraints, glossary
    programs/            # Active program trees (empty until Go)
    reports/             # Per-issue agent reports (empty until execution)
  skills/
    gstack/              # Required universal skills
    host/                # This repo only (empty in virgin template)
```

No `archive/` in the published template (smaller pack; factory bootstrap history is under `factory/programs/bootstrap/`).

## First run

1. Wire — `factory/install/WIRE-PROMPT.md` + `factory/install/CHECKLIST.md`
2. Automations — `factory/install/automations/` guides for Cursor and Codex
3. **Go** — Principal approves; cloud Planner per `factory/prompts/planner/ROLE.md`

See `factory/SPEC.md`.
