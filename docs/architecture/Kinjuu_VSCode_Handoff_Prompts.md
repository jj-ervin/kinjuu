# Kinjuu VS Code Handoff Prompts

## Short Codex takeover prompt

Scaffold **Kinjuu Core MVP** in this repo.

Read and follow these markdown specs first:
- `Kinjuu_Core_v0.1_Product_Spec.md`
- `Kinjuu_Core_MVP_Tech_Scaffold_Spec.md`

Your task is to build **only the MVP scaffold**, not the full product.

### MVP scope
Build scaffold/support for:
- manual obligation tracking
- due dates
- recurring reminders
- local/device notifications
- paid / pending / overdue status
- upcoming obligations view

### Out of scope
Do **not** add:
- bank connectivity
- budgeting
- payment processing
- ACH/bill pay
- forecasting
- AI recommendation features
- premium/connect features
- full card numbers
- CVV/CVC
- banking credentials
- multi-user collaboration

### Required outputs
Create:
- folder/file structure
- Flutter app shell
- routes/navigation
- model classes
- SQLite schema/migrations
- repository interfaces
- notification service abstraction
- placeholder screen widgets
- TODO markers for unfinished implementation

### Required screens
- Dashboard
- Obligations List
- Add/Edit Obligation
- Accounts & Cards
- Calendar / Upcoming View
- History / Activity
- Settings

### Required behavior
Work in phases:
1. scaffold structure
2. add models + database definitions
3. add repository/service interfaces + screen stubs

After each phase, summarize:
- what you created
- what remains
- any assumptions made

If anything is ambiguous, choose the narrower MVP interpretation.

---

## PASS-style build packet prompt

You are executing a scoped build packet for **Kinjuu Core MVP**.

### PASS FRAME
- **Asset**: mobile app scaffold
- **Mode**: assembly / implementation
- **Tier**: controlled scaffold
- **Performance mode**: disciplined, no scope expansion
- **Primary objective**: create a stable Flutter + SQLite MVP scaffold for Kinjuu Core

### Canon
You must follow these specs as the source of truth:
- `Kinjuu_Core_v0.1_Product_Spec.md`
- `Kinjuu_Core_MVP_Tech_Scaffold_Spec.md`

Do not override the spec.
Do not invent product direction.
Do not expand scope.

### Product boundary
Kinjuu Core MVP is:
- manual-entry obligation tracking
- due dates
- recurring reminders
- local notifications
- paid / pending / overdue tracking
- upcoming obligations visibility

Kinjuu Core MVP is not:
- bank-connected
- budgeting-enabled
- payment-capable
- forecasting-driven
- premium/connect-enabled

### Required entities
Implement scaffold support for:
- account
- card
- obligation
- subscription
- payment_event
- notification_rule
- audit_entry

Respect the required status model:
- upcoming
- due_today
- pending
- paid
- overdue
- archived

Respect the required `source_type` rule:
- MVP allowed value: `manual`

### Required technical direction
Use:
- Flutter
- SQLite
- local-first architecture
- local notification abstraction

### Required deliverables
Produce these in sequence:

#### Pass 1 — Structure
- folders
- app entrypoint
- theme shell
- route shell
- feature/module layout

#### Pass 2 — Data foundation
- model classes
- enums/value objects where appropriate
- SQLite schema or migration setup
- repository contracts

#### Pass 3 — App surfaces
- stub screens
- service interfaces
- notification abstraction
- TODO markers for unfinished logic

### Constraints
- keep code typed and clean
- prefer maintainable naming
- keep comments useful but minimal
- no fake integrations
- no speculative premium architecture unless required as a boundary comment
- no hidden feature expansion

### Output contract
After each pass, report:
- files created
- key decisions
- remaining work
- any assumptions resolved in favor of the narrower MVP

Success means:
a stable, reviewable scaffold that matches the Kinjuu MVP contract and is ready for iterative implementation.
