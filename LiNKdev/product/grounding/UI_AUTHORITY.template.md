# UI authority (fill during wire)

Stable reference for **where UI rules live in this host repo**. Planner or wire agent copies this file to `UI_AUTHORITY.md` and fills placeholders after the first product UI pass.

## Surfaces

| Surface | Audience | Authority |
|---------|----------|-----------|
| **Operator UI** | Internal operators / staff | Host product rule + ui-system doc + token module (below) |
| **Customer UI** | End customers (published sites, apps, etc.) | Separate app/template rules in the customer-facing repo or suite — **not** operator shell standards |

Do not apply operator shell chrome, `{host-app}/src/lib/ui-standards.ts` tokens, or operator table/form families to customer marketing sites unless an issue explicitly requires it.

## Operator UI authority chain

Read in order when implementing or reviewing operator UI:

1. **Product Cursor rule** — `{host}/.cursor/rules/08-*.mdc`
2. **UI system index** — `{host-app}/docs/ui-system.md` (layer map, component library, component families)
3. **Token module** — `{host-app}/src/lib/ui-standards.ts` (or documented equivalent path)

Replace `{host}` and `{host-app}` with this repository’s real paths during wire.

## Component families (operator UI hosts)

When the host ships operator web UI, prefer documented component families before inventing inline patterns:

| Family | Use for | Host skill (copy to `LiNKdev/skills/host/` on wire) |
|--------|---------|-----------------------------------------------------|
| **Data table** | Columnar settings/session lists | `data-table` |
| **Action queue** | Attention feeds, inbox rows | `action-queue` |
| **Summary metric cards** | Dashboard KPI / stream tiles | `summary-metric-cards` |
| **Personal information forms** | Name, address, phone, email | `personal-information-forms` |

Skills are **host-local** — they reference this repo’s component paths, not portable factory paths.

## Wire checklist

- [ ] `UI_AUTHORITY.md` filled with real paths (this file renamed and completed)
- [ ] Host `.cursor/rules/08-*` present or documented N/A for non-web products
- [ ] Operator UI skills copied to `LiNKdev/skills/host/` when operator UI exists
- [ ] Issue `read_first` lists specific UI files — agents do not glob the whole app tree

## Related factory docs

- Portable rule: `LiNKdev/factory/rules/08-ui-and-frontend-standards.mdc`
- Skills routing: `LiNKdev/skills/host/README.md`, `LiNKdev/factory/install/SKILLS-ALLOWLIST.md`
