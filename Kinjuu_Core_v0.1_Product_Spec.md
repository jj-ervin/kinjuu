# Kinjuu Core v0.1 — Product Specification

## 1. Purpose

**Kinjuu Core v0.1** is a mobile-first personal finance reminder application designed to help a user track obligations manually and receive timely reminders before bills, subscriptions, and card payments are due.

Kinjuu Core is the **foundational standalone product** in the broader Kinjuu product family.

It is intentionally scoped as a **manual-entry obligation tracker**, not a bank-connected financial application.

The goal of v0.1 is to create a stable, secure, low-risk core that is:
- useful on its own,
- simple enough to build and validate,
- structured to support future growth,
- and ready to become the base layer for **Kinjuu Connect** later.

---

## 2. Product statement

### Kinjuu Core v0.1 is:
- a manual-entry finance reminder app,
- a due-date and obligation tracker,
- a notification-driven personal organizer for recurring expenses,
- a mobile product centered on clarity, stability, and control.

### Kinjuu Core v0.1 is not:
- a budgeting app in the full planning/forecasting sense,
- a connected bank account aggregator,
- a payment processor,
- an accounting platform,
- a lender, credit product, or financial advisor,
- a storage system for full card numbers, CVV values, or banking credentials.

---

## 3. Core product goals

Kinjuu Core v0.1 must:

1. Let a user create and manage tracked obligations manually.
2. Help the user see what is due soon.
3. Send reminders on configured schedules.
4. Let the user mark obligations as paid, pending, or overdue.
5. Maintain a lightweight history trail of actions.
6. Store data with a security-conscious, privacy-minimized design.
7. Establish a stable data model that can later support imported and connected data sources.
8. Carry lightweight provenance for audit-bearing records through `time.loc` where appropriate.

---

## 4. Primary user

### Initial target user
A single user who wants a clean, dependable way to track:
- bills,
- subscriptions,
- card due dates,
- recurring obligations,
- and payment status,

without requiring bank connection or complex accounting workflows.

### User needs
The initial user needs to:
- know what is due and when,
- avoid missing due dates,
- remember recurring expenses,
- track whether something was paid,
- view upcoming obligations in one place,
- and feel in control of financial timing.

---

## 5. Scope

## 5.1 In scope for v0.1

### Data tracking
- accounts (manual references only)
- cards (manual references only)
- obligations
- subscriptions
- due dates
- statement dates
- expected amount
- minimum amount (where relevant)
- notes
- category/type
- recurrence pattern
- status tracking

### Core interactions
- create item
- edit item
- archive item
- mark paid
- mark pending
- view upcoming obligations
- review recent history

### Reminder behavior
- local device notifications
- configurable reminder offsets
- due-date alerts
- overdue alerts
- notification preferences

### Security/privacy
- local data-first architecture
- masked references only
- no full card data
- no banking credentials
- app lock support target
- deletion/export capability

## 5.2 Out of scope for v0.1

The following are explicitly excluded from Kinjuu Core v0.1:

### Financial connectivity
- bank account linking
- credit card account linking
- aggregator integrations
- open banking integrations
- live balance pulls
- live transaction imports
- credential storage for financial institutions

### Payment activity
- payment initiation
- ACH functionality
- bill pay
- card charging
- autopay management through financial institutions

### Sensitive credential storage
- full card numbers
- CVV/CVC values
- online banking usernames/passwords
- raw authentication secrets for financial providers

### Advanced analytics
- full budgeting engine
- cash-flow forecasting engine
- AI financial recommendations
- tax logic
- accounting-grade double-entry system
- credit scoring or underwriting logic

### Multi-user collaboration
- household sharing
- advisor mode
- team or business mode

These may be future expansion areas but are not part of the v0.1 build contract.

## 5.3 Budgeting boundary

Budgeting is a planned **post-MVP capability**, not part of the initial MVP build.

### MVP build focus
Kinjuu Core MVP should focus only on:
- manual obligation tracking
- due dates
- recurring reminders
- local/device notifications
- paid / pending / overdue status
- upcoming obligations view

### Budgeting position
Budgeting should be scoped now for future compatibility, but not implemented in the MVP.

### Post-MVP budgeting candidates
Once the obligation/reminder foundation is stable, later versions may add:
- monthly budget periods
- budget categories
- planned amounts by category
- committed vs flexible spending views
- manual spend entries
- planned vs actual comparisons

This preserves a clean MVP while keeping a path open for Kinjuu to grow into a broader financial planning tool.

---

## 6. Product architecture position

Kinjuu Core is the **foundation layer** of the Kinjuu family.

### Kinjuu family structure
- **Kinjuu Core** — standalone manual-entry app
- **Kinjuu Connect** — future premium connected finance layer

### Design rule
Kinjuu Core must not assume bank connectivity.

Instead, it must normalize obligations through a source-aware data model so that future sources can be added later without redesigning the product.

---

## 7. Data model v0.1

## 7.1 Design principles

1. Every financial reminder item should be representable without a bank connection.
2. The reminder engine should work from normalized obligation records.
3. Entities should support future expansion without breaking the v0.1 schema.
4. Sensitive data should be minimized by design.
5. Audit-bearing records should support lightweight provenance through `time.loc`.

## 7.2 Core entities

### `account`
Represents a user-defined financial container reference.

Fields:
- `id`
- `name`
- `institution_name`
- `account_type`
- `masked_reference`
- `notes`
- `is_archived`
- `created_at`
- `updated_at`

### `card`
Represents a manually tracked payment card reference.

Fields:
- `id`
- `name`
- `issuer`
- `card_type`
- `masked_reference`
- `statement_day`
- `due_day`
- `notes`
- `is_archived`
- `created_at`
- `updated_at`

### `obligation`
Represents a tracked payment or expense obligation.

Fields:
- `id`
- `title`
- `obligation_type`
- `source_type`
- `linked_account_id` (optional)
- `linked_card_id` (optional)
- `expected_amount` (optional)
- `minimum_amount` (optional)
- `currency_code`
- `due_date`
- `statement_date` (optional)
- `recurrence_rule`
- `status`
- `autopay_expected`
- `category`
- `notes`
- `created_at`
- `updated_at`

Allowed `source_type` in v0.1:
- `manual`

### `subscription`
Represents a recurring service commitment.

Fields:
- `id`
- `title`
- `provider_name`
- `source_type`
- `billing_cycle`
- `expected_amount`
- `renewal_date`
- `linked_account_id` (optional)
- `linked_card_id` (optional)
- `status`
- `notes`
- `created_at`
- `updated_at`

### `payment_event`
Represents a user-recorded payment action or status change.

Fields:
- `id`
- `obligation_id`
- `event_type`
- `event_date`
- `amount` (optional)
- `note` (optional)
- `created_at`
- `time_loc` (optional, recommended)

### `notification_rule`
Represents reminder settings.

Fields:
- `id`
- `target_type`
- `target_id` (optional)
- `days_before`
- `trigger_on_due_date`
- `trigger_if_overdue`
- `overdue_interval_days` (optional)
- `is_enabled`
- `quiet_hours_start` (optional)
- `quiet_hours_end` (optional)
- `created_at`
- `updated_at`

### `audit_entry`
Represents basic activity history.

Fields:
- `id`
- `entity_type`
- `entity_id`
- `action_type`
- `summary`
- `created_at`
- `time_loc` (recommended)

### `time_loc_record`
Represents the canonical temporal/location provenance stamp when attached to audit-bearing records.

MVP position:
- optional in ordinary UI flows
- recommended for audit-bearing records
- required for exported provenance-bearing logs if implemented

---

## 7.3 Required future-proof field

### `source_type`
This field is mandatory in v0.1 even though only `manual` is allowed initially.

Future permitted values may include:
- `manual`
- `imported`
- `connected`
- `system_derived`

This field is the key bridge from Kinjuu Core to Kinjuu Connect.

---

## 7.4 `time.loc` adoption boundary

Kinjuu adopts `time.loc` as its canonical provenance primitive for build/process records and selected app audit records.

### Mandatory in repo/process layer
`time.loc` should be included in:
- PASS headers
- PASSCHANGELOG entries
- handoff files
- handshake files

### Recommended in Kinjuu app layer
`time.loc` should be attached where provenance matters, such as:
- `payment_event`
- `audit_entry`
- export metadata
- reminder execution records if implemented
- import/sync records later

### Not required in ordinary UI rendering
`time.loc` does not need to appear in:
- standard list rows
- basic dashboard rendering
- every widget interaction
- every transient local state mutation

### MVP guidance
For Kinjuu MVP, prefer the baseline `time.loc` usage pattern for documentation, PASS, changelog, and audit-bearing events.
Do not require GPS-heavy behavior for normal reminder use.

---

## 8. Core user flows

### First-run flow
1. User opens app.
2. User sees a brief explanation of purpose.
3. User sets basic notification permission preferences.
4. User optionally enables app lock or biometric.
5. User adds a first tracked item.

### Add obligation flow
1. User taps add.
2. User selects type: bill, subscription, card payment, loan, or other.
3. User enters title.
4. User enters due date.
5. User enters recurrence.
6. User optionally enters amount.
7. User optionally links an account or card reference.
8. User sets a reminder pattern.
9. User saves.

### Daily use flow
1. User opens dashboard.
2. User reviews due soon, due today, and overdue.
3. User opens item.
4. User marks paid, pending, or edits details.
5. Audit/history updates.

### Notification flow
1. Reminder triggers on configured schedule.
2. User taps notification.
3. App opens relevant obligation.
4. User can mark paid, mark pending, or later snooze if supported.

---

## 9. Screen list v0.1

Required screens:
1. Dashboard
2. Obligations List
3. Add / Edit Obligation
4. Accounts & Cards
5. Calendar / Upcoming View
6. History / Activity
7. Settings

---

## 10. Notification rules v0.1

Default reminder behavior should support:
- 7 days before due date
- 3 days before due date
- 1 day before due date
- on due date
- 1 day overdue (optional default, configurable)

Users should be able to enable or disable reminder offsets per item or via global defaults.

Notification content should be useful without exposing excessive sensitive information.

Good examples:
- `Electric bill due tomorrow`
- `Spotify renews today`
- `Credit payment due in 3 days`

Avoid on lock screen by default:
- full account identifiers
- unnecessary dollar amounts if privacy setting disables them
- sensitive note contents

---

## 11. Status model v0.1

Required statuses:
- `upcoming`
- `due_today`
- `pending`
- `paid`
- `overdue`
- `archived`

---

## 12. Security minimums

Kinjuu Core v0.1 handles personal financial reminder data and must use a security-conscious baseline even without connected banking features.

### Data minimization rules
- do not store full card numbers
- do not store CVV/CVC values
- do not store online banking credentials
- do not require unnecessary personal data
- only store data necessary for reminder and tracking functions

### Local storage rules
- prefer encrypted local storage where feasible
- separate app settings from tracked data storage logically
- avoid plaintext exposure of sensitive references where better platform storage exists

### Access protection
- support app lock target
- support biometric unlock where platform support is available
- require explicit confirmation before destructive actions where appropriate

### User control
- export user data
- delete user data
- archive instead of hard-delete where helpful for UX
- keep privacy policy and data-use explanation clear

---

## 13. Compliance posture for v0.1

Kinjuu Core v0.1 should be positioned as a **manual-entry personal finance reminder application**, not as a connected financial institution interface.

Practical posture:
- low-risk data boundary
- privacy-first disclosures
- accurate app-store privacy disclosures
- no avoidable expansion into payment-card or banking credential scope

---

## 14. Recommended technical direction

Recommended build direction:
- **Flutter**
- **SQLite**
- local notification framework
- secure platform storage for sensitive app settings/secrets if needed

This supports:
- mobile-first development
- local-first architecture
- real notification support
- future premium evolution
- one codebase for Android and iOS

---

## 15. Future boundary to Kinjuu Connect

Future connected features may include:
- account linking
- transaction import
- balance snapshots
- connection tokens
- sync events
- provider adapters
- reconciliation logic

**Kinjuu Connect** should feed normalized obligation and account insight into the Kinjuu model.

Kinjuu Core should not be rewritten when Kinjuu Connect arrives.

---

## 16. Version goals

### v0.1 success criteria
Kinjuu Core v0.1 is successful if the user can:
- manually create obligations,
- receive reminders,
- view upcoming due items,
- track paid vs unpaid status,
- review basic history,
- and use the app without needing connected financial services.

### v0.1 non-goals
Kinjuu Core v0.1 does not need to:
- sync with banks,
- predict budgets,
- manage money movement,
- or operate as a full accounting system.

---

## 17. Immediate build sequence

### Phase 1 — Contract freeze
- lock this product spec
- lock schema v0.1
- lock status model
- lock notification model
- lock `time.loc` usage boundary

### Phase 2 — Technical scaffold
- create repo
- create Flutter app shell
- configure local storage
- define models
- define notification service

### Phase 3 — Core implementation
- accounts/cards CRUD
- obligations CRUD
- dashboard
- calendar/upcoming view
- mark paid/pending flow
- audit/history
- provenance-bearing event support where appropriate

### Phase 4 — Security and polish
- app lock/biometric support
- export/delete flow
- privacy copy
- UX refinement

---

## 18. Final build contract summary

Kinjuu Core v0.1 is a **manual-entry obligation and reminder tracker**.

It is the **standalone foundation** of the Kinjuu product family.

It must:
- remain low-risk,
- remain useful on its own,
- establish the normalized data model,
- create the stable base for Kinjuu Connect later,
- and use `time.loc` consistently in process records and selectively in audit-bearing app records.
