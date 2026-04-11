# HANDOFF — PASS 0003

## time.loc
version: time.loc/1.0
stamp.local: 2026-04-10T13:12:35-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T20:12:35Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFQ3BV0PXJ4VG7M6CDM0008
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

## What was completed
- Implemented the local data foundation for the MVP with typed domain entities, constrained enums, persistence models, repository contracts, and SQLite schema scaffolding.
- Added a local database access structure and compile-safe repository placeholders with TODO markers where concrete storage behavior is intentionally deferred.
- Added selective `time.loc` support for audit-bearing `payment_event` and `audit_entry` records, plus required `time.loc` blocks for PASS records.

## What was created/changed
- Handshake:
  - `HANDSHAKE_PASS_0003.md`
- Domain enums:
  - `lib/domain/enums/account_type.dart`
  - `lib/domain/enums/card_type.dart`
  - `lib/domain/enums/notification_target_type.dart`
  - `lib/domain/enums/obligation_status.dart`
  - `lib/domain/enums/obligation_type.dart`
  - `lib/domain/enums/recurrence_rule_style.dart`
  - `lib/domain/enums/source_type.dart`
  - `lib/domain/enums/payment_event_type.dart`
  - `lib/domain/enums/audit_entity_type.dart`
  - `lib/domain/enums/audit_action_type.dart`
- Domain entities:
  - `lib/domain/entities/account.dart`
  - `lib/domain/entities/tracked_card.dart`
  - `lib/domain/entities/obligation.dart`
  - `lib/domain/entities/subscription.dart`
- `lib/domain/entities/payment_event.dart`
- `lib/domain/entities/notification_rule.dart`
- `lib/domain/entities/audit_entry.dart`
- `lib/domain/entities/time_loc_record.dart`
- Repository contracts:
  - `lib/domain/repositories/account_repository.dart`
  - `lib/domain/repositories/card_repository.dart`
  - `lib/domain/repositories/obligation_repository.dart`
  - `lib/domain/repositories/subscription_repository.dart`
  - `lib/domain/repositories/payment_event_repository.dart`
  - `lib/domain/repositories/notification_rule_repository.dart`
  - `lib/domain/repositories/audit_repository.dart`
- Persistence models:
  - `lib/data/models/model_utils.dart`
  - `lib/data/models/account_model.dart`
  - `lib/data/models/tracked_card_model.dart`
  - `lib/data/models/obligation_model.dart`
  - `lib/data/models/subscription_model.dart`
- `lib/data/models/payment_event_model.dart`
- `lib/data/models/notification_rule_model.dart`
- `lib/data/models/audit_entry_model.dart`
- `lib/data/models/time_loc_record_model.dart`
- Database scaffold:
- `lib/data/database/app_database_schema.dart`
- `lib/data/database/local_database.dart`
- `lib/data/database/database_bootstrap.dart`
- Local repository shells:
  - `lib/data/repositories/local_repository_base.dart`
  - `lib/data/repositories/local_account_repository.dart`
  - `lib/data/repositories/local_card_repository.dart`
  - `lib/data/repositories/local_obligation_repository.dart`
  - `lib/data/repositories/local_subscription_repository.dart`
  - `lib/data/repositories/local_payment_event_repository.dart`
  - `lib/data/repositories/local_notification_rule_repository.dart`
  - `lib/data/repositories/local_audit_repository.dart`
- Updated:
- `PASSCHANGELOG.md`

## What remains
- PASS 0004 reminder and status foundation:
  - notification service abstraction
  - reminder defaults
  - overdue / due-today / upcoming derivation approach
  - recurrence helper design
  - quiet-hours configuration behavior
- Concrete SQLite package integration and actual repository CRUD implementation in later passes
- Tool-based build verification once a local Flutter/Dart toolchain is available

## Assumptions made
- A SQL-first scaffold plus a package-agnostic `LocalDatabase` abstraction is sufficient for PASS 0003 without prematurely locking in package-specific code.
- `Subscription.status` can safely reuse the same constrained `ObligationStatus` enum during the MVP scaffold.
- `TrackedCard` is a better Dart type name than `Card` to avoid collisions with Flutter UI classes while preserving the required card entity.
- Quiet hours are represented as nullable strings for now, with a likely future `HH:mm` interpretation once notification logic is implemented.
- `time.loc` is required in PASS/process docs and is selectively represented in the app layer only for audit-bearing records in this pass.

## Risks / caution points
- Repository methods intentionally throw `UnimplementedError` until concrete storage wiring is added; they are scaffolds, not runnable CRUD yet.
- `DatabaseBootstrap.initialize()` depends on a future concrete database adapter and should not be treated as fully operational in this pass.
- Do not expand the schema into connected-provider, budgeting, cloud-sync, or payment tables in follow-up passes.

## Must-not-drift reminders
- Do not add bank connectivity.
- Do not add budgeting to MVP.
- Do not add payment processing.
- Do not store prohibited financial data.
