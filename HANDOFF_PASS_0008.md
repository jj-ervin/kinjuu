# HANDOFF — PASS 0008

## time.loc
version: time.loc/1.0
stamp.local: 2026-04-10T17:21:27.1659806-07:00
stamp.local.day: Friday
stamp.utc: 2026-04-11T00:21:27.1659806Z
stamp.utc.day: Saturday
geo.city:
geo.region:
geo.country: US
geo.source: declared
seq: 01JRG0E1CXQXK7R8C9A1NP0009
sig: unavailable
geo.lat:
geo.lon:
geo.alt:

## What was completed

- Wired the active Kinjuu Core MVP obligation reminder path to real local device notification scheduling using `flutter_local_notifications`.
- Moved `notification_rules` onto the SQLite-backed local repository path and seeded the global default reminder rules when they are missing.
- Added reminder synchronization in the main app controller so persisted obligations are canceled and rescheduled on initial load and after obligation create, edit, paid, pending, and archive transitions.
- Added regression coverage for scheduling, rescheduling, cancellation, persisted reload scheduling, and stale reminder rejection.
- Verified the repository with `flutter analyze` and `flutter test`.

## What was created/changed

- Handshake:
  - `HANDSHAKE_PASS_0008.md`
- Dependency and generated plugin updates:
  - `pubspec.yaml`
  - `pubspec.lock`
  - `windows/flutter/generated_plugin_registrant.cc`
  - `windows/flutter/generated_plugins.cmake`
- Notification delivery and persistence wiring:
  - `lib/services/notifications/local_notification_service.dart`
  - `lib/data/models/notification_rule_model.dart`
  - `lib/data/repositories/local_notification_rule_repository.dart`
  - `lib/app/state/kinjuu_app_controller.dart`
- Tests:
  - `test/app/state/kinjuu_app_controller_test.dart`
- Updated:
  - `PASSCHANGELOG.md`

## How scheduling is wired

- `LocalNotificationService` now keeps the existing reminder-plan builder and adds real scheduling/cancellation through `flutter_local_notifications`.
- Scheduling uses timezone-aware `zonedSchedule` calls plus stable per-entry notification IDs and per-target payload tagging for later cancellation.
- `KinjuuAppController.load()` now ensures default rules exist, loads persisted obligations, cancels any previously scheduled reminders for each obligation target, and then rebuilds schedules for eligible obligations.
- If an obligation has direct target rules in the future, those rules win; otherwise, the seeded global defaults are used.

## What triggers scheduling vs cancellation

- Scheduling/rebuild happens on:
  - app/controller load
  - obligation create
  - obligation edit
  - obligation marked pending
- Cancellation-only happens when an obligation becomes ineligible:
  - obligation marked paid
  - obligation archived
  - any load/sync pass where all planned reminders for that obligation are already in the past
- Eligibility remains aligned to the current MVP status model:
  - schedule-eligible: `upcoming`, `due_today`, `pending`, `overdue`
  - cancel-only: `paid`, `archived`

## Assumptions made

- The active MVP reminder flow should use persisted global default rules because there is no notification preference editor yet.
- Real delivery is required on supported mobile/local-notification plugin platforms; unsupported platforms are left as safe no-op scheduling targets rather than broadening scope.
- Reminder scheduling itself is not an audit-bearing record, so `time.loc` remains limited to payment-event and audit-entry provenance.

## What remains

- A future pass can add a user-facing notification settings or per-obligation reminder-rule editor if that becomes part of the locked MVP flow.
- If Windows desktop delivery becomes required, the notification backend will need a platform-capable follow-up rather than more controller changes.
- Custom recurrence advancement remains intentionally narrow and was not expanded in this pass.