# Contributing to Kinjuu

## Build Process — PASS System

Kinjuu uses a **PASS-driven development process** to maintain coherence, manage scope, and preserve provenance.

See [docs/architecture/Kinjuu_PASS_Packet_Set.md](docs/architecture/Kinjuu_PASS_Packet_Set.md) for the full PASS packet specification.

## PASS Workflow

Each PASS (Programming Across Scope and Structure) is a scoped work unit with:

1. **Objective** — single, clear goal
2. **In-scope work** — explicit deliverables
3. **Out-of-scope work** — hard boundaries
4. **Handoff** — what the next pass receives
5. **Handshake** — next pass confirms understanding before proceeding

### Process

1. **Create a task branch**: `pass-NNNN-{title}`
2. **Work within scope**: Implement, test, verify
3. **Ensure code quality**:
   - Run `flutter analyze` and fix all violations (zero violations required)
   - Run `dart format` on all modified files
   - Run `flutter test` and ensure all tests pass
4. **Write HANDOFF document**: Document what you completed, changed, and what remains
5. **Update PASSCHANGELOG**: Add entry with required sections (see below)
6. **Submit for handshake**: Next pass reads HANDOFF and PASSCHANGELOG, confirms scope in HANDSHAKE
7. **Merge to main**: After handshake confirmation

### Required Sections in Every PASS Document

Every PASS HANDOFF and PASSCHANGELOG entry must answer these **6 reasoning questions**:

#### 1. **What changed?**
A precise delta-only description of what was added, removed, corrected, or restructured — no summaries, no narrative, no restatement of the entire pass.

#### 2. **Why did it change?**
The underlying rationale: governance, correction, alignment, drift-prevention, structural need, or architectural requirement.

#### 3. **What problem does this change resolve?**
The specific failure mode, ambiguity, drift vector, or structural gap that the change eliminates.

#### 4. **What new constraints or invariants now exist?**
Any new rules, boundaries, lifecycle constraints, naming constraints, or governance constraints introduced by the change.

#### 5. **What downstream surfaces, modules, or passes are affected?**
A deterministic list of all dependent systems that must update, revalidate, or realign because of this change.

#### 6. **What reasoning path led to this decision?**
A transparent, auditable explanation of the cognitive chain:
- What was considered
- What was rejected
- What evidence or invariants guided the decision
- Why this outcome is the correct one

### Example HANDOFF Entry

```markdown
## What changed?
- Added `LocalDatabase.reset()` method to clear tables and drop database file
- Added two new fields to `AuditEntry`: `metadata` (JSON) and `timeLoc` (nullable)
- Removed `isDeleted` soft-delete flag from obligations (now using archive status instead)

## Why did it change?
- Reset capability was needed for test isolation and development workflow
- Audit metadata field enables future forensics and detailed action logging
- Soft-delete flag was redundant with the obligation status model

## What problem does this resolve?
- Tests were sharing database state across runs, causing false positives
- No way to record additional context about audit actions (which user, from where, etc.)
- Confusion between "deleted" and "archived" states in obligations domain

## What new constraints now exist?
- All new AuditEntry records must populate timeLoc if they represent sensitive/financial actions
- Database reset clears ALL data — use only in test fixtures or reset endpoints
- Obligation archive status is now the source of truth for "deleted" semantics

## What downstream surfaces are affected?
- `test/app/state/kinjuu_app_controller_test.dart` — now calls `database.reset()` in setUp()
- `PASS 0005` — obligation archive flow now replaces soft-delete logic
- Dashboard, history, and list screens — obligation filters must use `status == archived` instead of `isDeleted`

## What reasoning path led to this?
- Considered: soft-delete pattern vs status-based deletion
  - Soft-delete is common but confused "deleted" with "archived" in this domain
  - Obligation status already has an `archived` value; reuse it
- Rejected: adding `deletedAt` timestamp
  - Would duplicate archive status tracking
  - Added complexity without clarity
- Evidence: product spec explicitly has "archive" as an obligation action
- Outcome: status model is the source of truth; soft-delete flag is removed
```

## Standards & Conventions

### Code Style
- Follow Flutter and Dart conventions (see `analysis_options.yaml`)
- **REQUIRED**: Run `flutter analyze` and fix all violations before submitting any code — zero violations are required
- **REQUIRED**: Run `dart format` on all modified Dart files
- **REQUIRED**: Run `npx markdownlint "docs/**/*.md" "*.md"` and fix all violations — zero violations are required
- Do not submit code or documentation with lint warnings, errors, or violations of any kind

### Testing
- Write tests for new features and bug fixes
- Unit tests go in `test/app/state/`, `test/services/`, etc.
- Run: `flutter test test/app test/services`
- Aim for >80% coverage on business logic

### Branching
- Main branch: `main` (stable, all tests pass)
- Feature/task branches: `pass-NNNN-{slug}`, `fix-{slug}`, `refactor-{slug}`
- Always branch from `main`
- Merge back to `main` after PASS completion

### Commit Messages
```text
{type}: {summary}

{body}

Co-Authored-By: {name} <{email}>
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`

Example:
```text
feat: add obligation archive action and status

- Implement archiveObligation() in controller
- Update status derivation to handle archived state
- Remove soft-delete isDeleted field from obligation

Resolves confusion between deleted and archived semantics.

Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>
```

## MVP Scope Boundaries

**In MVP:**
- Manual obligation entry
- Local persistence (SQLite)
- Local device reminders
- Status tracking (due, overdue, pending, paid, archived)
- Accounts & cards reference (no connectivity)
- Audit logging

**Out of MVP:**
- Bank/financial API connectivity
- Budgeting
- Forecasting
- Payment processing
- Cloud sync
- Multi-user collaboration
- Premium/connect features
- Storing full card numbers, CVV, banking credentials

**If you add something that looks like out-of-scope**, stop and discuss before committing.

## Getting Help

- Read [docs/architecture/](docs/architecture/) for specs and decisions
- Read [docs/PASS/PASSCHANGELOG.md](docs/PASS/PASSCHANGELOG.md) for build history and rationale
- Read the prior HANDOFF document for context on what you're building on top of
