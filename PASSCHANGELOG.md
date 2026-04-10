# PASSCHANGELOG

## PASS 0001 — Contract Freeze

### time.loc
version: 1
stamp.local: 2026-04-10T13:12:35-07:00
stamp.local.day: 2026-04-10
stamp.utc: 2026-04-10T20:12:35Z
stamp.utc.day: 2026-04-10
geo.city:
geo.region:
geo.country: USA
geo.source: environment_estimate
seq: pass-0001-log-realigned
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

Date:
Agent/Model:

### Completed
- Locked the Kinjuu Core MVP product boundary.
- Locked the scaffold boundary and non-goals.

### Files created/updated
- `Kinjuu_Core_v0.1_Product_Spec.md`
- `Kinjuu_Core_MVP_Tech_Scaffold_Spec.md`

### Decisions made
- Flutter + SQLite is the target direction.
- Kinjuu Core MVP remains manual-entry only.

### Explicitly not done
- No app scaffold or implementation work.
- No budgeting or connected finance work.

### Open issues
- PASS 0002 scaffold work remained next.

### Handoff notes
- Keep future passes inside the narrow MVP boundary.

## PASS 0002 — Repo and App Scaffold

### time.loc
version: 1
stamp.local: 2026-04-10T13:12:35-07:00
stamp.local.day: 2026-04-10
stamp.utc: 2026-04-10T20:12:35Z
stamp.utc.day: 2026-04-10
geo.city:
geo.region:
geo.country: USA
geo.source: environment_estimate
seq: pass-0002-log-realigned
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

Date: 2026-04-10
Agent/Model: Codex (GPT-5-based)

### Completed
- Created a Flutter-oriented repository scaffold with app entrypoint, theme shell, and test shell.
- Added placeholder screens and named routes for every required MVP screen.

### Files created/updated
- `.gitignore`
- `analysis_options.yaml`
- `pubspec.yaml`
- `README.md`
- `lib/main.dart`
- `lib/app/app.dart`
- `lib/app/routes/app_routes.dart`
- `lib/app/routes/app_router.dart`
- `lib/app/theme/app_theme.dart`
- `lib/core/constants/app_strings.dart`
- `lib/features/dashboard/presentation/dashboard_screen.dart`
- `lib/features/obligations/presentation/obligations_list_screen.dart`
- `lib/features/obligations/presentation/add_edit_obligation_screen.dart`
- `lib/features/accounts_cards/presentation/accounts_cards_screen.dart`
- `lib/features/calendar/presentation/calendar_screen.dart`
- `lib/features/history/presentation/history_screen.dart`
- `lib/features/settings/presentation/settings_screen.dart`
- `lib/shared/widgets/kinjuu_app_scaffold.dart`
- `lib/shared/widgets/feature_placeholder_card.dart`
- `test/widget_test.dart`

### Decisions made
- Used a simple named-route `MaterialApp` shell to keep navigation compile-safe and easy to extend later.
- Kept the folder structure ready for `data`, `domain`, and `services` without implementing those layers yet.

### Explicitly not done
- No database schema, entities, repository contracts, or notification logic.
- No bank connectivity, budgeting, payment functionality, or premium/connect work.

### Open issues
- Flutter CLI was not available on `PATH`, so build/test verification was not run.
- PASS 0003 still needed to populate the data foundation.

### Handoff notes
- Route map is `/`, `/obligations`, `/obligations/edit`, `/accounts-cards`, `/calendar`, `/history`, `/settings`.

## PASS 0003 — Data Foundation

### time.loc
version: 1
stamp.local: 2026-04-10T13:12:35-07:00
stamp.local.day: 2026-04-10
stamp.utc: 2026-04-10T20:12:35Z
stamp.utc.day: 2026-04-10
geo.city:
geo.region:
geo.country: USA
geo.source: environment_estimate
seq: pass-0003-log-1
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

Date: 2026-04-10
Agent/Model: Codex (GPT-5-based)

### Completed
- Added typed domain enums and entity definitions for all required MVP data records.
- Added persistence models, SQLite schema/bootstrap scaffolding, repository contracts, and local repository implementation shells with explicit TODO boundaries.
- Realigned the pass to the updated canon by adding selective `time.loc` support for audit-bearing records and `time.loc` blocks to PASS process records.

### Files created/updated
- `HANDSHAKE_PASS_0003.md`
- `HANDOFF_PASS_0001.md`
- `HANDSHAKE_PASS_0002.md`
- `HANDOFF_PASS_0002.md`
- `HANDOFF_PASS_0003.md`
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
- `lib/domain/entities/account.dart`
- `lib/domain/entities/tracked_card.dart`
- `lib/domain/entities/obligation.dart`
- `lib/domain/entities/subscription.dart`
- `lib/domain/entities/payment_event.dart`
- `lib/domain/entities/notification_rule.dart`
- `lib/domain/entities/audit_entry.dart`
- `lib/domain/entities/time_loc_record.dart`
- `lib/domain/repositories/account_repository.dart`
- `lib/domain/repositories/card_repository.dart`
- `lib/domain/repositories/obligation_repository.dart`
- `lib/domain/repositories/subscription_repository.dart`
- `lib/domain/repositories/payment_event_repository.dart`
- `lib/domain/repositories/notification_rule_repository.dart`
- `lib/domain/repositories/audit_repository.dart`
- `lib/data/models/model_utils.dart`
- `lib/data/models/account_model.dart`
- `lib/data/models/tracked_card_model.dart`
- `lib/data/models/obligation_model.dart`
- `lib/data/models/subscription_model.dart`
- `lib/data/models/payment_event_model.dart`
- `lib/data/models/notification_rule_model.dart`
- `lib/data/models/audit_entry_model.dart`
- `lib/data/models/time_loc_record_model.dart`
- `lib/data/database/app_database_schema.dart`
- `lib/data/database/local_database.dart`
- `lib/data/database/database_bootstrap.dart`
- `lib/data/repositories/local_repository_base.dart`
- `lib/data/repositories/local_account_repository.dart`
- `lib/data/repositories/local_card_repository.dart`
- `lib/data/repositories/local_obligation_repository.dart`
- `lib/data/repositories/local_subscription_repository.dart`
- `lib/data/repositories/local_payment_event_repository.dart`
- `lib/data/repositories/local_notification_rule_repository.dart`
- `lib/data/repositories/local_audit_repository.dart`
- `PASSCHANGELOG.md`

### Decisions made
- Kept domain entities separate from persistence models so later SQLite wiring can evolve without leaking table-shape concerns into the domain layer.
- Chose a SQL-first schema scaffold with `CREATE TABLE` and index statements plus a package-agnostic `LocalDatabase` abstraction.
- Constrained `source_type` to `manual` in both the domain enum and the SQLite schema.
- Kept `time.loc` usage narrow in the app layer by adding optional support only to `payment_event` and `audit_entry`.

### Explicitly not done
- No concrete SQLite package integration or executable CRUD behavior was added yet.
- No notification scheduling logic, bank connectivity, budgeting models, payment features, cloud sync, or premium/connect architecture was introduced.
- No prohibited sensitive data fields were added; only masked references are represented.

### Open issues
- Repository implementations are intentionally stubbed and will throw until a concrete SQLite adapter is wired in a later pass.
- PASS 0004 still needs to define notification abstractions, reminder defaults, recurrence helpers, and status derivation behavior.

### Handoff notes
- Required tables are scaffolded as `accounts`, `cards`, `obligations`, `subscriptions`, `payment_events`, `notification_rules`, and `audit_entries`.
- `TrackedCard` was used as the Dart entity name to avoid UI/widget naming collisions while still representing the required `card` entity cleanly.
