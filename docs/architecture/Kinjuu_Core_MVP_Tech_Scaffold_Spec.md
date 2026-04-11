# Kinjuu Core MVP — Technical Scaffold Specification

## 1. Purpose

This document defines the implementation scaffold for **Kinjuu Core MVP**.

The goal is to give VS Code / Copilot / Codex a narrow, build-ready technical contract for the first implementation phase.

This spec is for the **MVP scaffold**, not the full application.

---

## 2. MVP boundary

### In scope
- manual obligation tracking
- due dates
- recurring reminders
- local/device notifications
- paid / pending / overdue status
- upcoming obligations view
- local-first data storage
- screen stubs and navigation shell

### Out of scope
- bank connectivity
- budgeting engine
- payment processing
- ACH/bill pay
- forecasting
- AI recommendations
- premium/connect functionality
- cloud sync
- full card data storage
- CVV/CVC storage
- banking credentials

If anything is ambiguous, resolve it in favor of the narrower MVP.

---

## 3. Recommended stack

- **Flutter**
- **SQLite**
- local notification package
- secure platform storage for app lock or sensitive settings if needed

---

## 4. Project structure

Recommended structure:

```text
lib/
  app/
    app.dart
    routes/
    theme/
  core/
    constants/
    utils/
    errors/
  data/
    database/
    models/
    repositories/
  domain/
    entities/
    enums/
    repositories/
    services/
  features/
    dashboard/
    obligations/
    accounts_cards/
    calendar/
    history/
    settings/
  services/
    notifications/
    security/
  shared/
    widgets/
```

A similarly clean equivalent structure is acceptable if it preserves separation of concerns.

---

## 5. Required screens

Create stub screens for:
1. Dashboard
2. Obligations List
3. Add / Edit Obligation
4. Accounts & Cards
5. Calendar / Upcoming View
6. History / Activity
7. Settings

Each screen should compile and route correctly even if it initially contains placeholder content.

---

## 6. Required domain entities

Implement scaffold support for:

### `account`
- id
- name
- institution_name
- account_type
- masked_reference
- notes
- is_archived
- created_at
- updated_at

### `card`
- id
- name
- issuer
- card_type
- masked_reference
- statement_day
- due_day
- notes
- is_archived
- created_at
- updated_at

### `obligation`
- id
- title
- obligation_type
- source_type
- linked_account_id
- linked_card_id
- expected_amount
- minimum_amount
- currency_code
- due_date
- statement_date
- recurrence_rule
- status
- autopay_expected
- category
- notes
- created_at
- updated_at

Allowed `source_type` in MVP:
- `manual`

### `subscription`
- id
- title
- provider_name
- source_type
- billing_cycle
- expected_amount
- renewal_date
- linked_account_id
- linked_card_id
- status
- notes
- created_at
- updated_at

### `payment_event`
- id
- obligation_id
- event_type
- event_date
- amount
- note
- created_at

### `notification_rule`
- id
- target_type
- target_id
- days_before
- trigger_on_due_date
- trigger_if_overdue
- overdue_interval_days
- is_enabled
- quiet_hours_start
- quiet_hours_end
- created_at
- updated_at

### `audit_entry`
- id
- entity_type
- entity_id
- action_type
- summary
- created_at

---

## 7. Required enums and value concepts

At minimum, define clean enum or constrained value support for:
- obligation status
- obligation type
- account type
- card type
- target type for notifications
- source type
- recurrence rule style

Required obligation statuses:
- `upcoming`
- `due_today`
- `pending`
- `paid`
- `overdue`
- `archived`

---

## 8. Database scaffold

Create SQLite schema support for the required entities.

Recommended deliverables:
- table definitions
- migration/bootstrap entrypoint
- repository-facing database access layer
- TODO markers where implementation details remain

Required tables:
- `accounts`
- `cards`
- `obligations`
- `subscriptions`
- `payment_events`
- `notification_rules`
- `audit_entries`

Minimum expectations:
- primary keys
- created/updated timestamps where applicable
- foreign key relationships where useful
- no prohibited sensitive data fields

---

## 9. Repository interfaces

Create clean repository contracts for:
- account repository
- card repository
- obligation repository
- subscription repository
- payment event repository
- notification rule repository
- audit repository

The MVP does not require all implementations to be feature-complete, but interfaces and local implementations should be scaffolded coherently.

---

## 10. Notification service abstraction

Create a local notification service abstraction that supports:
- scheduling reminders by day offsets
- due-date notifications
- overdue reminders
- global defaults
- per-item override compatibility
- quiet hours configuration shape

Default reminder support should include:
- 7 days before due date
- 3 days before due date
- 1 day before due date
- due date
- optional overdue reminder

This pass only needs the abstraction and implementation path scaffold if full logic is not yet complete.

---

## 11. State and routing expectations

Create:
- app entrypoint
- navigation shell
- named routes or equivalent route structure
- basic state wiring suitable for MVP growth

Use a simple, maintainable state approach.
Do not overbuild the state architecture in the scaffold phase.

---

## 12. Security expectations

The MVP scaffold should reflect these minimum expectations:
- no full card numbers
- no CVV/CVC
- no banking credentials
- masked references only
- placeholder support for app lock or biometric settings
- deletion/export surfaces planned in settings

---

## 13. Delivery phases

### Phase 1 — Structure
Create:
- folder/file structure
- app entrypoint
- theme shell
- route shell
- placeholder screens

### Phase 2 — Data foundation
Create:
- model classes
- enums
- SQLite schema/migration setup
- repository interfaces

### Phase 3 — Service and feature scaffold
Create:
- notification service abstraction
- basic local repository implementations or stubs
- TODO markers
- compile-safe feature wiring

After each phase, summarize:
- what was created
- what remains
- what assumptions were made

---

## 14. Success criteria

The scaffold is successful if:
- the app compiles as a structured shell,
- required screens exist,
- required entities exist,
- the database layer is scaffolded,
- notification architecture is defined,
- and no out-of-scope functionality has been introduced.

---

## 15. Final constraint

This is a **stable MVP scaffold**, not an invitation to invent product direction.

Do not expand into:
- Kinjuu Connect
- budgeting
- payment capability
- connected finance
- cloud-first architecture

Keep the scaffold narrow, typed, reviewable, and ready for iterative implementation.
