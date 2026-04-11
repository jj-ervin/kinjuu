# Kinjuu — PASS Packet Set (MVP Build)

## 1. Purpose

This packet set defines a simple PASS-driven execution structure for building **Kinjuu Core MVP**.

The goal is to preserve:
- scope control,
- clean handoffs,
- low drift,
- recoverability across passes and agents,
- and consistent provenance through `time.loc`.

This packet set is intentionally lightweight.
It is not meant to create unnecessary bureaucracy.
It is meant to keep the build coherent.

---

## 2. Governing rule

All passes must obey the locked build boundary.

### Kinjuu Core MVP includes
- manual obligation tracking
- due dates
- recurring reminders
- local/device notifications
- paid / pending / overdue status
- upcoming obligations view

### Kinjuu Core MVP excludes
- bank connectivity
- budgeting engine
- forecasting
- payment processing
- ACH/bill pay
- premium/connect features
- full card numbers
- CVV/CVC storage
- banking credentials
- multi-user collaboration

If ambiguity arises, every pass must resolve it in favor of the **narrower MVP**.

---

## 3. `time.loc` rule

Kinjuu adopts `time.loc` as the canonical provenance primitive for build/process records.

### Required in process docs
Every PASS-related file should carry a `time.loc` record or designated placeholder block:
- PASS headers
- PASSCHANGELOG entries
- handoff files
- handshake files

### Guidance
- use the canonical `time.loc` structure
- prefer the baseline form for repo/build use
- do not silently invent alternate timestamp formats
- if signing is unavailable in the current environment, make that explicit rather than faking it

---

## 4. Packet structure

Each PASS packet should contain:
- pass id
- pass title
- objective
- in-scope work
- out-of-scope work
- required inputs
- required outputs
- completion criteria
- handoff requirements
- handshake requirements
- `time.loc` header block

---

## 5. PASS sequence

## PASS 0001 — Contract Freeze

### Objective
Lock the product and scaffold contract so implementation does not drift.

### In scope
- finalize product spec
- finalize MVP tech scaffold spec
- lock scope boundaries
- confirm entities, screens, statuses, notifications, and tech direction
- confirm `time.loc` usage boundary

### Out of scope
- code generation
- UI polish
- financial connectivity
- budgeting design

### Required inputs
- product direction for Kinjuu
- Kinjuu Core v0.1 product spec
- Kinjuu Core MVP tech scaffold spec

### Required outputs
- locked product spec
- locked scaffold spec
- frozen MVP boundary
- list of non-goals

### Completion criteria
- specs exist in markdown
- in-scope and out-of-scope are explicit
- MVP meaning is unambiguous

### Handoff forward
Pass forward:
- locked specs
- list of required screens
- list of required entities
- allowed and forbidden features

### Handshake requirement
Receiving agent must explicitly confirm:
- specs were read
- scope is understood
- no forbidden features will be added

---

## PASS 0002 — Repo and App Scaffold

### Objective
Create the Flutter project shell and app structure for Kinjuu Core MVP.

### In scope
- folder structure
- app entrypoint
- app theme shell
- navigation/routing shell
- placeholder feature structure
- placeholder screen files

### Out of scope
- full logic implementation
- notifications logic
- SQLite CRUD completion
- feature expansion

### Required inputs
- locked product spec
- locked scaffold spec

### Required outputs
- Flutter app scaffold
- file/folder structure
- route map
- screen stubs for all required screens

### Completion criteria
- app builds as scaffold
- routes compile
- screen placeholders exist
- structure is readable and consistent

### Handoff forward
Pass forward:
- created file tree
- route decisions
- architecture assumptions
- unresolved TODOs

### Handshake requirement
Receiving agent must confirm:
- scaffold structure was reviewed
- route and screen list match contract
- no extra features were introduced

---

## PASS 0003 — Data Foundation

### Objective
Define the local data model and storage layer contract.

### In scope
- model classes
- enums/value objects
- SQLite table definitions or migration setup
- repository interfaces
- source_type constraint
- status model support
- `time.loc` placeholders/boundary for audit-bearing records

### Out of scope
- connected provider models
- budgeting tables
- sync tokens
- cloud storage

### Required inputs
- locked product spec
- scaffold structure from PASS 0002

### Required outputs
- Dart model definitions
- local schema definitions
- repository abstractions
- storage TODO notes if needed

### Completion criteria
- all required entities are represented
- schema matches spec fields
- source_type is present and constrained to manual for MVP
- status model is represented cleanly

### Handoff forward
Pass forward:
- entities implemented
- schema implemented
- repository contracts
- open questions on recurrence or history modeling

### Handshake requirement
Receiving agent must confirm:
- schema matches spec
- no forbidden financial data is stored
- no connect/premium assumptions were added

---

## PASS 0004 — Reminder and Status Foundation

### Objective
Create the notification and recurring-obligation logic foundation.

### In scope
- notification service abstraction
- default reminder schedule support
- due/upcoming/overdue derivation support
- recurrence helper design
- quiet-hours configuration shape

### Out of scope
- cloud messaging
- push backend services
- connected sync triggers
- advanced forecasting logic

### Required inputs
- scaffold from PASS 0002
- data foundation from PASS 0003

### Required outputs
- notification service interface
- reminder scheduling structure
- recurrence helper structure
- status derivation approach

### Completion criteria
- reminder defaults can be represented
- notification architecture is local-first
- overdue/upcoming logic is clearly modeled
- recurrence logic has a defined implementation path

### Handoff forward
Pass forward:
- notification abstraction
- recurrence assumptions
- status derivation rules
- TODOs for actual scheduling implementation

### Handshake requirement
Receiving agent must confirm:
- reminders stay local/device-based
- no cloud dependency was silently introduced
- recurrence logic remains MVP-appropriate

---

## PASS 0005 — CRUD and Activity Flows

### Objective
Implement the essential user-facing data interactions.

### In scope
- create/edit/archive obligation flows
- account/card CRUD support
- mark paid / pending flows
- activity/history logging hooks
- dashboard and list data wiring at a basic level
- selective `time.loc` support for audit-bearing events

### Out of scope
- polished final UI
- analytics dashboards
- budgeting UI
- connected finance flows

### Required inputs
- scaffold from PASS 0002
- data foundation from PASS 0003
- reminder/status foundation from PASS 0004

### Required outputs
- basic create/edit/update flows
- status change actions
- activity log behavior
- minimal working data loop

### Completion criteria
- user can create tracked items
- user can edit and archive tracked items
- user can mark paid/pending
- history entries are recorded

### Handoff forward
Pass forward:
- implemented flows
- known edge cases
- UI roughness notes
- remaining TODOs

### Handshake requirement
Receiving agent must confirm:
- CRUD flows remain within MVP
- no extra product surfaces were introduced
- history actions are aligned with the audit model

---

## PASS 0006 — Review, Trim, and Stabilize

### Objective
Review all work against the contract, remove drift, and prepare for next-stage implementation.

### In scope
- compare implementation to specs
- remove out-of-scope additions
- clean naming
- improve TODO inventory
- identify blockers and next passes
- verify `time.loc` handling consistency

### Out of scope
- major new features
- connected finance work
- budgeting implementation
- design overhauls

### Required inputs
- all prior pass outputs
- locked product/spec documents

### Required outputs
- review summary
- drift correction notes
- cleaned scaffold
- next-step recommendation list

### Completion criteria
- implementation matches contract
- forbidden scope is absent
- remaining work is clearly documented

### Handoff forward
Pass forward:
- current project state
- recommended next build passes
- blocker list
- remaining TODO inventory

### Handshake requirement
Receiving agent must confirm:
- review was performed against the contract, not against assumptions
- all scope-expansion candidates were either removed or explicitly deferred

---

## 6. PASSCHANGELOG template

Use one running markdown file: `PASSCHANGELOG.md`

Recommended format:

```md
# PASSCHANGELOG

## PASS 0001 — Contract Freeze

### time.loc
version: time.loc/1.0
stamp.local:                 # ISO-8601/RFC3339 with explicit offset, e.g. 2026-04-10T13:00:00-07:00
stamp.local.day:             # English weekday name, capitalized, e.g. Friday
stamp.utc:                   # ISO-8601/RFC3339 UTC with Z, e.g. 2026-04-10T20:00:00Z
stamp.utc.day:               # English weekday name, capitalized, e.g. Friday
geo.city:
geo.region:
geo.country:                 # ISO-3166-1 alpha-2, e.g. US
geo.source:                  # declared | ip | gps | unavailable
seq:                         # ULID (26-char Crockford base32), e.g. 01JRFQ3BV0PXJ4VG7M6CDM0001
sig:                         # unsigned | unavailable | <signature>
geo.lat:
geo.lon:
geo.alt:

Date:
Agent/Model:

### Completed
-
-

### Files created/updated
-
-

### Decisions made
-
-

### Explicitly not done
-
-

### Open issues
-
-

### Handoff notes
-
-
```

### Rules for PASSCHANGELOG
- every pass updates it
- record what changed and what did not
- record assumptions explicitly
- record unresolved questions without silently solving them outside the contract
- include `time.loc` for every entry

---

## 7. Handoff template

Use this at the end of each pass.

```md
# HANDOFF — PASS 000X

## time.loc
version: time.loc/1.0
stamp.local:                 # ISO-8601/RFC3339 with explicit offset, e.g. 2026-04-10T13:00:00-07:00
stamp.local.day:             # English weekday name, capitalized, e.g. Friday
stamp.utc:                   # ISO-8601/RFC3339 UTC with Z, e.g. 2026-04-10T20:00:00Z
stamp.utc.day:               # English weekday name, capitalized, e.g. Friday
geo.city:
geo.region:
geo.country:                 # ISO-3166-1 alpha-2, e.g. US
geo.source:                  # declared | ip | gps | unavailable
seq:                         # ULID (26-char Crockford base32), e.g. 01JRFQ3BV0PXJ4VG7M6CDM0001
sig:                         # unsigned | unavailable | <signature>
geo.lat:
geo.lon:
geo.alt:

## What was completed
-
-

## What was created/changed
-
-

## What remains
-
-

## Assumptions made
-
-

## Risks / caution points
-
-

## Must-not-drift reminders
- Do not add bank connectivity
- Do not add budgeting to MVP
- Do not add payment processing
- Do not store prohibited financial data
```

---

## 8. Handshake template

Use this at the beginning of the next pass.

```md
# HANDSHAKE — PASS 000X

## time.loc
version: time.loc/1.0
stamp.local:                 # ISO-8601/RFC3339 with explicit offset, e.g. 2026-04-10T13:00:00-07:00
stamp.local.day:             # English weekday name, capitalized, e.g. Friday
stamp.utc:                   # ISO-8601/RFC3339 UTC with Z, e.g. 2026-04-10T20:00:00Z
stamp.utc.day:               # English weekday name, capitalized, e.g. Friday
geo.city:
geo.region:
geo.country:                 # ISO-3166-1 alpha-2, e.g. US
geo.source:                  # declared | ip | gps | unavailable
seq:                         # ULID (26-char Crockford base32), e.g. 01JRFQ3BV0PXJ4VG7M6CDM0001
sig:                         # unsigned | unavailable | <signature>
geo.lat:
geo.lon:
geo.alt:

I confirm that I have reviewed:
- the locked product spec
- the MVP scaffold spec
- the prior handoff
- the PASSCHANGELOG

I understand that this pass is limited to:
-
-

I will not introduce:
- bank connectivity
- budgeting features
- payment functionality
- premium/connect features
- prohibited sensitive data storage

Any ambiguity will be resolved in favor of the narrower MVP.
```

---

## 9. Recommended operating rule for agents/models

Use stronger models for:
- PASS 0001
- PASS 0003
- PASS 0004
- PASS 0006

Use smaller/faster models for:
- PASS 0002
- PASS 0005
- repetitive file generation
- cleanup and boilerplate

### Suggested mapping
- `gpt-5.4` / Codex for architecture, schema, notification logic, review
- `gpt-5.4-mini` for scaffold generation, repetitive stubs, cleanup passes

---

## 10. Final guidance

Do not overcomplicate the PASS system for this build.

Kinjuu Core MVP is a **moderate build**, not a giant platform program.

The purpose of this packet set is to keep the build:
- coherent,
- narrow,
- reviewable,
- recoverable,
- and consistently stamped with `time.loc`.

That is enough.

The system should feel like a stable build grammar, not paperwork for its own sake.
