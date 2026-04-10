import 'package:flutter/foundation.dart';

import '../../core/utils/time_loc_factory.dart';
import '../../data/database/local_database.dart';
import '../../data/repositories/local_account_repository.dart';
import '../../data/repositories/local_audit_repository.dart';
import '../../data/repositories/local_card_repository.dart';
import '../../data/repositories/local_obligation_repository.dart';
import '../../data/repositories/local_payment_event_repository.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/audit_entry.dart';
import '../../domain/entities/obligation.dart';
import '../../domain/entities/payment_event.dart';
import '../../domain/entities/tracked_card.dart';
import '../../domain/enums/account_type.dart';
import '../../domain/enums/audit_action_type.dart';
import '../../domain/enums/audit_entity_type.dart';
import '../../domain/enums/card_type.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/enums/obligation_type.dart';
import '../../domain/enums/payment_event_type.dart';
import '../../domain/enums/recurrence_rule_style.dart';
import '../../domain/enums/source_type.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/repositories/card_repository.dart';
import '../../domain/repositories/obligation_repository.dart';
import '../../domain/repositories/payment_event_repository.dart';
import '../../services/notifications/obligation_status_service_impl.dart';

class KinjuuAppController extends ChangeNotifier {
  KinjuuAppController({
    AccountRepository? accountRepository,
    CardRepository? cardRepository,
    ObligationRepository? obligationRepository,
    PaymentEventRepository? paymentEventRepository,
    AuditRepository? auditRepository,
    ObligationStatusServiceImpl? obligationStatusService,
  })  : _accountRepository =
            accountRepository ?? LocalAccountRepository(LocalDatabase()),
        _cardRepository = cardRepository ?? LocalCardRepository(LocalDatabase()),
        _obligationRepository =
            obligationRepository ?? LocalObligationRepository(LocalDatabase()),
        _paymentEventRepository =
            paymentEventRepository ?? LocalPaymentEventRepository(LocalDatabase()),
        _auditRepository = auditRepository ?? LocalAuditRepository(LocalDatabase()),
        _obligationStatusService =
            obligationStatusService ?? ObligationStatusServiceImpl();

  final AccountRepository _accountRepository;
  final CardRepository _cardRepository;
  final ObligationRepository _obligationRepository;
  final PaymentEventRepository _paymentEventRepository;
  final AuditRepository _auditRepository;
  final ObligationStatusServiceImpl _obligationStatusService;

  List<Account> _accounts = const <Account>[];
  List<TrackedCard> _cards = const <TrackedCard>[];
  List<Obligation> _obligations = const <Obligation>[];
  List<AuditEntry> _auditEntries = const <AuditEntry>[];
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  List<Account> get accounts => _accounts.where((entry) => !entry.isArchived).toList(growable: false);
  List<TrackedCard> get cards => _cards.where((entry) => !entry.isArchived).toList(growable: false);
  List<Obligation> get obligations => _obligations
      .map(_withDerivedStatus)
      .where((entry) => entry.status != ObligationStatus.archived)
      .toList(growable: false);
  List<AuditEntry> get auditEntries => _auditEntries;

  List<Obligation> get dashboardObligations =>
      _obligationStatusService.sortForUpcoming(obligations).take(5).toList(growable: false);

  int get dueTodayCount => obligations
      .where((entry) => _obligationStatusService.deriveStatus(entry) == ObligationStatus.dueToday)
      .length;

  int get overdueCount => obligations
      .where((entry) => _obligationStatusService.deriveStatus(entry) == ObligationStatus.overdue)
      .length;

  int get upcomingCount => obligations
      .where((entry) => _obligationStatusService.deriveStatus(entry) == ObligationStatus.upcoming)
      .length;

  Future<void> load() async {
    _accounts = await _accountRepository.getAll();
    _cards = await _cardRepository.getAll();
    _obligations = await _obligationRepository.getAll();
    _auditEntries = await _auditRepository.getRecent();
    _isLoaded = true;
    notifyListeners();
  }

  Obligation? obligationById(String id) {
    try {
      return _obligations.firstWhere((entry) => entry.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveAccount({
    String? existingId,
    required String name,
    required String institutionName,
    required AccountType accountType,
    required String maskedReference,
    required String notes,
  }) async {
    _requireNonEmpty(name, fieldName: 'Account name');
    _requireNonEmpty(institutionName, fieldName: 'Institution name');
    _validateMaskedReference(maskedReference, fieldName: 'Account masked reference');

    final now = DateTime.now();
    final existing = existingId == null ? null : await _accountRepository.getById(existingId);
    final account = Account(
      id: existing?.id ?? _nextId('account'),
      name: name.trim(),
      institutionName: institutionName.trim(),
      accountType: accountType,
      maskedReference: maskedReference.trim(),
      notes: notes.trim(),
      isArchived: existing?.isArchived ?? false,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await _accountRepository.save(account);
    await _recordAudit(
      entityType: AuditEntityType.account,
      entityId: account.id,
      actionType: existing == null ? AuditActionType.created : AuditActionType.updated,
      summary: existing == null ? 'Created account ${account.name}' : 'Updated account ${account.name}',
    );
    await load();
  }

  Future<void> archiveAccount(String id) async {
    final account = await _accountRepository.getById(id);
    if (account == null) {
      return;
    }

    await _accountRepository.archive(id);
    await _recordAudit(
      entityType: AuditEntityType.account,
      entityId: id,
      actionType: AuditActionType.archived,
      summary: 'Archived account ${account.name}',
    );
    await load();
  }

  Future<void> saveCard({
    String? existingId,
    required String name,
    required String issuer,
    required CardType cardType,
    required String maskedReference,
    required int? statementDay,
    required int? dueDay,
    required String notes,
  }) async {
    _requireNonEmpty(name, fieldName: 'Card name');
    _requireNonEmpty(issuer, fieldName: 'Card issuer');
    _validateMaskedReference(maskedReference, fieldName: 'Card masked reference');
    _validateOptionalDay(statementDay, fieldName: 'Statement day');
    _validateOptionalDay(dueDay, fieldName: 'Due day');

    final now = DateTime.now();
    final existing = existingId == null ? null : await _cardRepository.getById(existingId);
    final card = TrackedCard(
      id: existing?.id ?? _nextId('card'),
      name: name.trim(),
      issuer: issuer.trim(),
      cardType: cardType,
      maskedReference: maskedReference.trim(),
      statementDay: statementDay,
      dueDay: dueDay,
      notes: notes.trim(),
      isArchived: existing?.isArchived ?? false,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await _cardRepository.save(card);
    await _recordAudit(
      entityType: AuditEntityType.card,
      entityId: card.id,
      actionType: existing == null ? AuditActionType.created : AuditActionType.updated,
      summary: existing == null ? 'Created card ${card.name}' : 'Updated card ${card.name}',
    );
    await load();
  }

  Future<void> archiveCard(String id) async {
    final card = await _cardRepository.getById(id);
    if (card == null) {
      return;
    }

    await _cardRepository.archive(id);
    await _recordAudit(
      entityType: AuditEntityType.card,
      entityId: id,
      actionType: AuditActionType.archived,
      summary: 'Archived card ${card.name}',
    );
    await load();
  }

  Future<void> saveObligation({
    String? existingId,
    required String title,
    required ObligationType obligationType,
    required DateTime dueDate,
    required RecurrenceRuleStyle recurrenceRule,
    required double? expectedAmount,
    required double? minimumAmount,
    required String currencyCode,
    required bool autopayExpected,
    required String category,
    required String notes,
    String? linkedAccountId,
    String? linkedCardId,
    DateTime? statementDate,
  }) async {
    _requireNonEmpty(title, fieldName: 'Obligation title');
    _validateAmount(expectedAmount, fieldName: 'Expected amount');
    _validateAmount(minimumAmount, fieldName: 'Minimum amount');
    if (expectedAmount != null &&
        minimumAmount != null &&
        minimumAmount > expectedAmount) {
      throw ArgumentError.value(
        minimumAmount,
        'minimumAmount',
        'Minimum amount cannot exceed expected amount.',
      );
    }
    _validateCurrencyCode(currencyCode);

    final now = DateTime.now();
    final existing = existingId == null ? null : await _obligationRepository.getById(existingId);
    final base = Obligation(
      id: existing?.id ?? _nextId('obligation'),
      title: title.trim(),
      obligationType: obligationType,
      sourceType: SourceType.manual,
      linkedAccountId: linkedAccountId,
      linkedCardId: linkedCardId,
      expectedAmount: expectedAmount,
      minimumAmount: minimumAmount,
      currencyCode: currencyCode.trim().isEmpty ? 'USD' : currencyCode.trim().toUpperCase(),
      dueDate: dueDate,
      statementDate: statementDate,
      recurrenceRule: recurrenceRule,
      status: existing?.status ?? ObligationStatus.upcoming,
      autopayExpected: autopayExpected,
      category: category.trim(),
      notes: notes.trim(),
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final obligation = _withDerivedStatus(base);
    await _obligationRepository.save(obligation);
    await _recordAudit(
      entityType: AuditEntityType.obligation,
      entityId: obligation.id,
      actionType: existing == null ? AuditActionType.created : AuditActionType.updated,
      summary: existing == null
          ? 'Created obligation ${obligation.title}'
          : 'Updated obligation ${obligation.title}',
    );
    await load();
  }

  Future<void> archiveObligation(String id) async {
    final obligation = await _obligationRepository.getById(id);
    if (obligation == null) {
      return;
    }

    await _obligationRepository.archive(id);
    await _recordAudit(
      entityType: AuditEntityType.obligation,
      entityId: id,
      actionType: AuditActionType.archived,
      summary: 'Archived obligation ${obligation.title}',
    );
    await load();
  }

  Future<void> markObligationPaid(String id) async {
    await _setObligationStatus(
      id,
      status: ObligationStatus.paid,
      eventType: PaymentEventType.markedPaid,
      summarySuffix: 'paid',
    );
  }

  Future<void> markObligationPending(String id) async {
    await _setObligationStatus(
      id,
      status: ObligationStatus.pending,
      eventType: PaymentEventType.markedPending,
      summarySuffix: 'pending',
    );
  }

  Future<void> _setObligationStatus(
    String id, {
    required ObligationStatus status,
    required PaymentEventType eventType,
    required String summarySuffix,
  }) async {
    final obligation = await _obligationRepository.getById(id);
    if (obligation == null) {
      return;
    }

    await _obligationRepository.updateStatus(id, status);
    final now = DateTime.now();
    await _paymentEventRepository.save(
      PaymentEvent(
        id: _nextId('payment-event'),
        obligationId: id,
        eventType: eventType,
        eventDate: now,
        amount: obligation.expectedAmount,
        note: 'Marked ${obligation.title} as $summarySuffix',
        createdAt: now,
        timeLoc: TimeLocFactory.create(
          sequence: 'payment-event-$summarySuffix-$id',
          now: now,
        ),
      ),
    );
    await _recordAudit(
      entityType: AuditEntityType.obligation,
      entityId: id,
      actionType: AuditActionType.statusChanged,
      summary: 'Marked obligation ${obligation.title} as $summarySuffix',
    );
    await load();
  }

  Future<void> _recordAudit({
    required AuditEntityType entityType,
    required String entityId,
    required AuditActionType actionType,
    required String summary,
  }) async {
    final now = DateTime.now();
    await _auditRepository.save(
      AuditEntry(
        id: _nextId('audit'),
        entityType: entityType,
        entityId: entityId,
        actionType: actionType,
        summary: summary,
        createdAt: now,
        timeLoc: TimeLocFactory.create(
          sequence: 'audit-${entityType.storageValue}-${actionType.storageValue}-$entityId',
          now: now,
        ),
      ),
    );
  }

  Obligation _withDerivedStatus(Obligation obligation) {
    final derived = _obligationStatusService.deriveStatus(obligation);
    return Obligation(
      id: obligation.id,
      title: obligation.title,
      obligationType: obligation.obligationType,
      sourceType: obligation.sourceType,
      linkedAccountId: obligation.linkedAccountId,
      linkedCardId: obligation.linkedCardId,
      expectedAmount: obligation.expectedAmount,
      minimumAmount: obligation.minimumAmount,
      currencyCode: obligation.currencyCode,
      dueDate: obligation.dueDate,
      statementDate: obligation.statementDate,
      recurrenceRule: obligation.recurrenceRule,
      status: derived,
      autopayExpected: obligation.autopayExpected,
      category: obligation.category,
      notes: obligation.notes,
      createdAt: obligation.createdAt,
      updatedAt: obligation.updatedAt,
    );
  }

  String _nextId(String prefix) => '$prefix-${DateTime.now().microsecondsSinceEpoch}';

  void _requireNonEmpty(String value, {required String fieldName}) {
    if (value.trim().isEmpty) {
      throw ArgumentError.value(value, fieldName, '$fieldName is required.');
    }
  }

  void _validateMaskedReference(String value, {required String fieldName}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return;
    }

    if (RegExp(r'^\d{12,19}$').hasMatch(trimmed)) {
      throw ArgumentError.value(
        value,
        fieldName,
        '$fieldName must be masked and cannot be a full identifier.',
      );
    }
  }

  void _validateOptionalDay(int? value, {required String fieldName}) {
    if (value == null) {
      return;
    }
    if (value < 1 || value > 31) {
      throw ArgumentError.value(value, fieldName, '$fieldName must be between 1 and 31.');
    }
  }

  void _validateAmount(double? value, {required String fieldName}) {
    if (value == null) {
      return;
    }
    if (value < 0) {
      throw ArgumentError.value(value, fieldName, '$fieldName cannot be negative.');
    }
  }

  void _validateCurrencyCode(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || !RegExp(r'^[A-Za-z]{3}$').hasMatch(trimmed)) {
      throw ArgumentError.value(
        value,
        'currencyCode',
        'Currency code must be a 3-letter code such as USD.',
      );
    }
  }
}
