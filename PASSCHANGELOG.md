# PASSCHANGELOG

## PASS 0001 — Contract Freeze

### time.loc
version: time.loc/1.0
stamp.local: 2026-04-10T13:12:35-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T20:12:35Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFQ3BV0PXJ4VG7M6CDM0001
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
version: time.loc/1.0
stamp.local: 2026-04-10T13:12:35-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T20:12:35Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFQ3BV0PXJ4VG7M6CDM0003
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
version: time.loc/1.0
stamp.local: 2026-04-10T13:12:35-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T20:12:35Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFQ3BV0PXJ4VG7M6CDM0006
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

## PASS 0004 — Reminder and Status Foundation

### time.loc
version: time.loc/1.0
stamp.local: 2026-04-10T14:59:33-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T21:59:34Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFQKHJY9XVZS4HK58PQN009
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

Date: 2026-04-10
Agent/Model: Codex (GPT-5-based)

### Completed
- Added a local-first notification abstraction, reminder planning value types, and default reminder schedule support for 7/3/1 days before, due date, and overdue reminders.
- Added recurrence and obligation-status service contracts plus local implementations for upcoming/due-today/overdue derivation and recurring date generation.
- Verified the pass with `flutter analyze` and `flutter test`.

### Files created/updated
- `HANDSHAKE_PASS_0004.md`
- `lib/domain/enums/reminder_event_type.dart`
- `lib/domain/entities/quiet_hours_window.dart`
- `lib/domain/entities/reminder_plan_entry.dart`
- `lib/domain/services/notification_service.dart`
- `lib/domain/services/obligation_status_service.dart`
- `lib/domain/services/recurrence_service.dart`
- `lib/services/notifications/notification_defaults.dart`
- `lib/services/notifications/local_notification_service.dart`
- `lib/services/notifications/obligation_status_service_impl.dart`
- `lib/services/notifications/recurrence_service_impl.dart`
- `test/services/notifications/notification_foundation_test.dart`
- `lib/app/theme/app_theme.dart`
- `lib/data/repositories/local_audit_repository.dart`
- `lib/data/repositories/local_card_repository.dart`
- `lib/data/repositories/local_notification_rule_repository.dart`
- `lib/data/repositories/local_obligation_repository.dart`
- `lib/data/repositories/local_payment_event_repository.dart`
- `lib/data/repositories/local_subscription_repository.dart`
- `PASSCHANGELOG.md`

### Decisions made
- Kept notification work package-agnostic by building reminder plans in Dart and deferring the actual plugin bridge to TODOs in the local notification service.
- Represented quiet hours as a typed window value object and applied it only during reminder schedule planning.
- Preserved manual-only, local-first MVP scope by limiting this pass to planning, derivation, and service abstractions rather than delivery infrastructure.

### Explicitly not done
- No platform notification plugin integration or actual device scheduling behavior.
- No cloud messaging, connected sync triggers, budgeting logic, payment actions, or non-MVP analytics work.
- No expansion of `time.loc` beyond the existing selective audit-bearing boundary.

### Open issues
- The local notification service still needs a concrete package adapter in a later pass.
- Custom recurrence rules remain intentionally deferred.
- PASS 0005 still needs to connect CRUD/activity flows to these status and reminder foundations.

### Handoff notes
- Default reminder rule support now exists in code for 7, 3, and 1 days before due date, plus due-date and overdue reminders.
- Status derivation preserves `paid`, `pending`, and `archived`, and derives `due_today`, `overdue`, and `upcoming` from due dates for the remaining cases.

## PASS 0005 — CRUD and Activity Flows

### time.loc
version: time.loc/1.0
stamp.local: 2026-04-10T15:30:14-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T22:30:14Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFQTNJGQFD0BKAP2X7H5012
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

Date: 2026-04-10
Agent/Model: Codex (GPT-5-based)

### Completed
- Implemented a working local CRUD loop for obligations, accounts, and cards using the existing repository contracts.
- Wired dashboard, obligations list, obligation editor, accounts/cards screen, and history screen to live app state.
- Added audit entry creation for create, edit, archive, mark paid, and mark pending actions, with selective `time.loc` support on audit-bearing records.
- Verified the pass with `flutter analyze` and `flutter test`.

### Files created/updated
- `HANDSHAKE_PASS_0005.md`
- `lib/app/app.dart`
- `lib/app/routes/app_router.dart`
- `lib/app/state/kinjuu_app_controller.dart`
- `lib/app/state/kinjuu_app_scope.dart`
- `lib/app/state/obligation_editor_args.dart`
- `lib/core/utils/time_loc_factory.dart`
- `lib/data/database/in_memory_local_store.dart`
- `lib/data/repositories/local_repository_base.dart`
- `lib/data/repositories/local_account_repository.dart`
- `lib/data/repositories/local_card_repository.dart`
- `lib/data/repositories/local_obligation_repository.dart`
- `lib/data/repositories/local_payment_event_repository.dart`
- `lib/data/repositories/local_audit_repository.dart`
- `lib/features/dashboard/presentation/dashboard_screen.dart`
- `lib/features/obligations/presentation/add_edit_obligation_screen.dart`
- `lib/features/obligations/presentation/obligations_list_screen.dart`
- `lib/features/accounts_cards/presentation/accounts_cards_screen.dart`
- `lib/features/history/presentation/history_screen.dart`
- `test/app/state/kinjuu_app_controller_test.dart`
- `PASSCHANGELOG.md`

### Decisions made
- Used a small `ChangeNotifier`-based app controller and inherited scope rather than introducing a heavier state package in the MVP.
- Implemented the repository-backed working loop with an in-memory local store for this pass so CRUD and activity flows are functional now while preserving the repository contracts.
- Kept `time.loc` limited to audit-bearing records and payment events, not ordinary UI state or rendering.

### Explicitly not done
- No budgeting, bank connectivity, payment processing, cloud sync, or premium/connect work.
- No large UI redesign or extra feature surfaces beyond the existing scaffold.
- No concrete SQLite adapter replacement yet; the working loop currently uses local in-memory repository backing.

### Open issues
- Data does not persist across app restarts yet because the SQLite adapter is still deferred behind the repository contracts.
- Calendar and settings remain lightly wired compared with dashboard, obligations, accounts/cards, and history.
- PASS 0006 should review drift, clean rough UI edges, and confirm whether the current in-memory backing should be replaced or kept as an interim layer.

### Handoff notes
- The minimal working loop is now functional: create, edit, archive, mark paid, mark pending, and review related activity records.
- Audit entries are written for create, update, archive, and status-change actions, and the dashboard/list surfaces refresh from shared app state after each change.

## PASS 0005.1 — Defect Triage and MVP Hardening

### time.loc
version: time.loc/1.0
stamp.local: 2026-04-10T15:46:16-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T22:46:17Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFQXZRBGHN3P6VS0MWT5015
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

Date: 2026-04-10
Agent/Model: Codex (GPT-5-based)

### Completed
- Replaced unsafe quiet-hours parsing with safe parsing and range validation in the local notification service.
- Corrected status derivation so `pending` obligations re-evaluate to `overdue` after their due date passes.
- Added controller-level save validation and matching form validation for obviously invalid account, card, and obligation inputs.
- Neutralized remaining local repository stubs for notification rules and subscriptions that could otherwise trip MVP hardening work.
- Added regression tests and verified the pass with `flutter analyze` and `flutter test`.

### Files created/updated
- `HANDSHAKE_PASS_0005_1.md`
- `lib/services/notifications/local_notification_service.dart`
- `lib/services/notifications/obligation_status_service_impl.dart`
- `lib/app/state/kinjuu_app_controller.dart`
- `lib/features/obligations/presentation/add_edit_obligation_screen.dart`
- `lib/features/accounts_cards/presentation/accounts_cards_screen.dart`
- `lib/data/repositories/local_notification_rule_repository.dart`
- `lib/data/repositories/local_subscription_repository.dart`
- `test/services/notifications/notification_foundation_test.dart`
- `test/app/state/kinjuu_app_controller_test.dart`
- `PASSCHANGELOG.md`

### Decisions made
- Kept quiet-hours validation permissive by treating malformed or out-of-range values as absent instead of throwing during planning.
- Preserved `pending` as a meaningful user state only until the obligation is actually past due, at which point derivation returns `overdue`.
- Added validation in both the UI and controller layers so invalid saves are blocked whether they come from forms or direct method calls.

### Explicitly not done
- No new features, state architecture changes, budgeting, bank connectivity, cloud sync, or premium/connect work.
- No broad persistence refactor beyond neutralizing stubbed repository paths relevant to MVP hardening.

### Open issues
- The app still uses in-memory backing for the active CRUD loop, so persistence across app restarts remains deferred.
- `LocalDatabase` and platform notification scheduling are still scaffold-only abstractions, but they remain unreachable from current MVP flows.

### Handoff notes
- Quiet-hours strings now fail safely if malformed, and invalid hour/minute ranges are ignored rather than crashing reminder planning.
- Regression coverage now includes invalid quiet-hours input, pending-to-overdue derivation, and invalid save rejection for core controller flows.

## PASS 0006 — Review, Trim, and Stabilize

### time.loc
version: time.loc/1.0
stamp.local: 2026-04-10T15:48:23-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T22:48:23Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFQY3FE7QKN91XVC4BZ8018
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

Date: 2026-04-10
Agent/Model: Codex (GPT-5-based)

### Completed
- Reviewed the current implementation against the product spec, tech scaffold spec, PASS packet contract, and prior handoff.
- Verified that MVP scope, data model boundaries, sensitive-data exclusions, and `time.loc` placement remain aligned with the canon docs.
- Tightened remaining TODO and stub markers so scaffold debt is clearly labeled as intentional, not as hidden defects.
- Re-ran verification with `flutter analyze` and `flutter test`.

### Files created/updated
- `HANDSHAKE_PASS_0006.md`
- `lib/data/database/local_database.dart`
- `lib/services/notifications/local_notification_service.dart`
- `lib/services/notifications/recurrence_service_impl.dart`
- `PASSCHANGELOG.md`

### Decisions made
- Kept the current in-memory CRUD loop as acceptable MVP-stage scaffold debt rather than forcing a late-pass persistence refactor.
- Preserved the current selective `time.loc` boundary: mandatory in PASS/process docs, present in audit-bearing app records, absent from ordinary UI rendering.
- Reframed remaining unreachable stubs as scaffold debt in code comments and error strings to improve handoff clarity.

### Explicitly not done
- No new product features, budgeting, bank connectivity, cloud sync, premium/connect work, or broad architectural changes.
- No replacement of the in-memory CRUD backing with SQLite during this stabilization pass.

### Open issues
- The active CRUD loop still uses in-memory backing and is not durable across app restarts.
- `LocalDatabase` remains a package-agnostic abstraction with intentionally unwired operations.
- Local notification delivery remains planning-only until a concrete device notification plugin is intentionally adopted.

### Handoff notes
- No hidden out-of-scope feature drift was found in the current repo state.
- Remaining stubs are now documented more clearly as acceptable scaffold debt for the current MVP stage.

## PASS 0007 — Local Persistence Integration

### time.loc
version: time.loc/1.0
stamp.local: 2026-04-10T15:58:06-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T22:58:06Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFQZ7M1VPC2DK8T5GBN5021
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

Date: 2026-04-10
Agent/Model: Codex (GPT-5-based)

### Completed
- Replaced the active in-memory CRUD backing for accounts, cards, obligations, payment events, and audit entries with SQLite-backed local persistence.
- Wired the existing repository contracts to the real local database helper while preserving the current controller and UI flows.
- Added restart-survival test coverage for the core MVP persistence path.
- Verified the pass with `flutter analyze` and `flutter test`.

### Files created/updated
- `HANDSHAKE_PASS_0007.md`
- `HANDOFF_PASS_0007.md`
- `pubspec.yaml`
- `pubspec.lock`
- `lib/data/database/local_database.dart`
- `lib/data/database/database_bootstrap.dart`
- `lib/data/models/account_model.dart`
- `lib/data/models/tracked_card_model.dart`
- `lib/data/models/obligation_model.dart`
- `lib/data/models/payment_event_model.dart`
- `lib/data/models/audit_entry_model.dart`
- `lib/data/repositories/local_account_repository.dart`
- `lib/data/repositories/local_card_repository.dart`
- `lib/data/repositories/local_obligation_repository.dart`
- `lib/data/repositories/local_payment_event_repository.dart`
- `lib/data/repositories/local_audit_repository.dart`
- `lib/app/state/kinjuu_app_controller.dart`
- `test/app/state/kinjuu_app_controller_test.dart`
- `PASSCHANGELOG.md`

### Decisions made
- Adopted a narrow SQLite integration using `sqflite` with `sqflite_common_ffi` for desktop/test environments rather than introducing a new persistence architecture.
- Kept the existing schema contract and selective `time.loc` boundary unchanged: audit-bearing app records only, not ordinary UI models.
- Left subscriptions and notification rules on the deferred in-memory path because they are not part of the currently implemented MVP interaction loop.

### Explicitly not done
- No budgeting, bank connectivity, cloud sync, payment processing, premium/connect work, or new product surfaces.
- No schema expansion beyond the existing MVP tables.
- No device-notification delivery integration or persistence wiring for deferred non-core repositories.

### Open issues
- `subscriptions` and `notification_rules` still use the deferred in-memory repository backing because they are not active in the current MVP path.
- The local notification service still plans reminders but does not yet schedule them on-device.

### Handoff notes
- Core created and updated data now survives app restart/reload through the local SQLite-backed repository path.
- The next pass can stay focused on UX or deferred persistence work rather than revisiting the core CRUD durability path.

## PASS time.loc-norm — time.loc Normalization Correction

### time.loc
version: time.loc/1.0
stamp.local: 2026-04-10T16:30:00-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-10T23:30:00Z
stamp.utc.day: Friday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRFR2S8XGVJ0KQMN7PBW5024
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

Date: 2026-04-10
Agent/Model: Claude Sonnet 4.6

### Completed
- Normalized all `time.loc` blocks in PASSCHANGELOG.md, HANDOFF_PASS_0001–0007, HANDSHAKE_PASS_0002–0007, and HANDSHAKE_PASS_0005_1 to the canonical format.
- Corrected `version: 1` → `version: time.loc/1.0` in all 23 blocks.
- Corrected `stamp.local.day` and `stamp.utc.day` from date strings to English weekday names (Friday).
- Corrected `geo.country: USA` → `geo.country: US` (ISO-3166-1 alpha-2) in all blocks.
- Corrected `geo.source: environment_estimate` → `geo.source: declared` in all blocks.
- Replaced ad-hoc `seq` strings with ULID-shaped values in all blocks.
- Updated templates in `Kinjuu_PASS_Packet_Set.md` (sections 6, 7, 8) to emit canonical `time.loc`.
- Created `HANDOFF_time_loc_normalization.md`.

### Files created/updated
- `PASSCHANGELOG.md`
- `HANDOFF_PASS_0001.md`
- `HANDOFF_PASS_0002.md`
- `HANDOFF_PASS_0003.md`
- `HANDOFF_PASS_0004.md`
- `HANDOFF_PASS_0005.md`
- `HANDOFF_PASS_0005_1.md`
- `HANDOFF_PASS_0006.md`
- `HANDOFF_PASS_0007.md`
- `HANDSHAKE_PASS_0002.md`
- `HANDSHAKE_PASS_0003.md`
- `HANDSHAKE_PASS_0004.md`
- `HANDSHAKE_PASS_0005.md`
- `HANDSHAKE_PASS_0005_1.md`
- `HANDSHAKE_PASS_0006.md`
- `HANDSHAKE_PASS_0007.md`
- `Kinjuu_PASS_Packet_Set.md`
- `HANDOFF_time_loc_normalization.md`

### Decisions made
- `geo.source: declared` used for all historical blocks because the country (US) was stated by the agent from known context (PDT offset), not from IP lookup or GPS.
- ULID-shaped seq values are reconstructed approximations from the ISO-8601 timestamps present in each block; exact ULIDs were never captured at generation time.
- `sig: unavailable` preserved as the established fallback for unsigned process records.
- Timestamp values left unchanged; only format fields were corrected.

### Explicitly not done
- No product scope changes.
- No app logic changes.
- No new features.
- No timestamp value corrections (only format corrections).

### Open issues
- None. All known pseudo-`time.loc` blocks have been normalized.

### Handoff notes
- Future passes should use the updated templates in `Kinjuu_PASS_Packet_Set.md` which now pre-fill `version: time.loc/1.0` and indicate the correct format for each field.
