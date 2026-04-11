# Kinjuu — Obligation Tracking MVP

A Flutter app for tracking bills, subscriptions, and other obligations with local persistence, reminders, and status tracking.

## Repository Structure

```plaintext
kinjuu/
├── docs/                          # Documentation & PASS process
│   ├── architecture/              # Product specs, tech scaffold, PASS packet set
│   ├── PASS/                      # PASSCHANGELOG, HANDOFF/HANDSHAKE docs
│   └── guides/                    # Setup and contribution guides
├── lib/                           # Flutter app (Dart code)
│   ├── main.dart
│   ├── app/                       # App shell, routing, state
│   ├── features/                  # Feature screens (dashboard, obligations, etc.)
│   ├── domain/                    # Domain entities, enums, services
│   ├── data/                      # Data models, repositories, database
│   ├── services/                  # Business logic services (notifications, etc.)
│   ├── core/                      # App constants, utilities
│   └── shared/                    # Shared widgets
├── test/                          # Unit & widget tests
├── android/                       # Android native code
├── ios/                           # iOS native code
├── windows/                       # Windows native code
├── pubspec.yaml                   # Dart dependencies
├── README.md                       # This file
└── .gitignore
```

## Documentation

- **[Architecture & Specs](docs/architecture/)** — Product spec, tech scaffold, PASS packet set
- **[PASS Process](docs/PASS/)** — PASSCHANGELOG, HANDOFF, HANDSHAKE documents
- **[Guides](docs/guides/)** — Setup, build, test, and contribution guides

## Current Status

**PASS 0008** — Notification Delivery Wiring

Core MVP is feature-complete with:

- ✅ Local obligation tracking (create, edit, archive)
- ✅ SQLite persistence
- ✅ Local device reminders & notifications
- ✅ Status tracking (due, overdue, pending, paid, archived)
- ✅ Audit logging
- ✅ Dashboard, obligations list, accounts/cards management
- ✅ Unit test coverage

**Known Limitations:**

- Widget tests temporarily disabled (pumpWidget hang during rendering — [see docs/PASS/HANDOFF_PASS_0008.md](docs/PASS/HANDOFF_PASS_0008.md))
- Custom recurrence rules deferred
- No cloud sync or multi-user collaboration

## Getting Started

```bash
flutter pub get
flutter run
```

For more details, see [docs/guides/](docs/guides/).

## Building & Testing

```bash
# Run unit tests
flutter test test/app test/services

# Analyze code
flutter analyze

# Build for platform
flutter build apk      # Android
flutter build windows  # Windows
flutter build ios      # iOS (requires macOS)
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and the [PASS Packet Set](docs/architecture/Kinjuu_PASS_Packet_Set.md) for the build process and handoff/handshake requirements.

## License

TBD

