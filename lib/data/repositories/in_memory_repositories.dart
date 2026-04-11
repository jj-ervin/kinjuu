import '../../domain/entities/account.dart';
import '../../domain/entities/audit_entry.dart';
import '../../domain/entities/notification_rule.dart';
import '../../domain/entities/obligation.dart';
import '../../domain/entities/payment_event.dart';
import '../../domain/entities/tracked_card.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/repositories/card_repository.dart';
import '../../domain/repositories/notification_rule_repository.dart';
import '../../domain/repositories/obligation_repository.dart';
import '../../domain/repositories/payment_event_repository.dart';
import '../database/in_memory_local_store.dart';

class InMemoryAccountRepository implements AccountRepository {
  InMemoryAccountRepository(this.store);

  final InMemoryLocalStore store;

  @override
  Future<void> archive(String id) async {
    final existing = store.accounts[id];
    if (existing == null) {
      return;
    }

    store.accounts[id] = Account(
      id: existing.id,
      name: existing.name,
      institutionName: existing.institutionName,
      accountType: existing.accountType,
      maskedReference: existing.maskedReference,
      notes: existing.notes,
      isArchived: true,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<Account>> getAll() async {
    final items = store.accounts.values.toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<Account?> getById(String id) async => store.accounts[id];

  @override
  Future<void> save(Account account) async {
    store.accounts[account.id] = account;
  }
}

class InMemoryCardRepository implements CardRepository {
  InMemoryCardRepository(this.store);

  final InMemoryLocalStore store;

  @override
  Future<void> archive(String id) async {
    final existing = store.cards[id];
    if (existing == null) {
      return;
    }

    store.cards[id] = TrackedCard(
      id: existing.id,
      name: existing.name,
      issuer: existing.issuer,
      cardType: existing.cardType,
      maskedReference: existing.maskedReference,
      statementDay: existing.statementDay,
      dueDay: existing.dueDay,
      notes: existing.notes,
      isArchived: true,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<TrackedCard>> getAll() async {
    final items = store.cards.values.toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<TrackedCard?> getById(String id) async => store.cards[id];

  @override
  Future<void> save(TrackedCard card) async {
    store.cards[card.id] = card;
  }
}

class InMemoryObligationRepository implements ObligationRepository {
  InMemoryObligationRepository(this.store);

  final InMemoryLocalStore store;

  @override
  Future<void> archive(String id) async {
    final existing = store.obligations[id];
    if (existing == null) {
      return;
    }

    store.obligations[id] = Obligation(
      id: existing.id,
      title: existing.title,
      obligationType: existing.obligationType,
      sourceType: existing.sourceType,
      linkedAccountId: existing.linkedAccountId,
      linkedCardId: existing.linkedCardId,
      expectedAmount: existing.expectedAmount,
      minimumAmount: existing.minimumAmount,
      currencyCode: existing.currencyCode,
      dueDate: existing.dueDate,
      statementDate: existing.statementDate,
      recurrenceRule: existing.recurrenceRule,
      status: ObligationStatus.archived,
      autopayExpected: existing.autopayExpected,
      category: existing.category,
      notes: existing.notes,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<Obligation>> getAll() async {
    final items = store.obligations.values.toList(growable: false);
    items.sort((left, right) => left.dueDate.compareTo(right.dueDate));
    return items;
  }

  @override
  Future<Obligation?> getById(String id) async => store.obligations[id];

  @override
  Future<List<Obligation>> getUpcoming() async {
    final items = store.obligations.values
        .where((entry) => entry.status != ObligationStatus.archived)
        .toList(growable: false);
    items.sort((left, right) => left.dueDate.compareTo(right.dueDate));
    return items;
  }

  @override
  Future<void> save(Obligation obligation) async {
    store.obligations[obligation.id] = obligation;
  }

  @override
  Future<void> updateStatus(String id, ObligationStatus status) async {
    final existing = store.obligations[id];
    if (existing == null) {
      return;
    }

    store.obligations[id] = Obligation(
      id: existing.id,
      title: existing.title,
      obligationType: existing.obligationType,
      sourceType: existing.sourceType,
      linkedAccountId: existing.linkedAccountId,
      linkedCardId: existing.linkedCardId,
      expectedAmount: existing.expectedAmount,
      minimumAmount: existing.minimumAmount,
      currencyCode: existing.currencyCode,
      dueDate: existing.dueDate,
      statementDate: existing.statementDate,
      recurrenceRule: existing.recurrenceRule,
      status: status,
      autopayExpected: existing.autopayExpected,
      category: existing.category,
      notes: existing.notes,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class InMemoryPaymentEventRepository implements PaymentEventRepository {
  InMemoryPaymentEventRepository(this.store);

  final InMemoryLocalStore store;

  @override
  Future<List<PaymentEvent>> getByObligationId(String obligationId) async {
    final items = store.paymentEvents.values
        .where((entry) => entry.obligationId == obligationId)
        .toList(growable: false);
    items.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return items;
  }

  @override
  Future<void> save(PaymentEvent event) async {
    store.paymentEvents[event.id] = event;
  }
}

class InMemoryAuditRepository implements AuditRepository {
  InMemoryAuditRepository(this.store);

  final InMemoryLocalStore store;

  @override
  Future<List<AuditEntry>> getRecent({int limit = 50}) async {
    final items = store.auditEntries.values.toList(growable: false);
    items.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return items.take(limit).toList(growable: false);
  }

  @override
  Future<void> save(AuditEntry entry) async {
    store.auditEntries[entry.id] = entry;
  }
}

class InMemoryNotificationRuleRepository implements NotificationRuleRepository {
  InMemoryNotificationRuleRepository(this.store);

  final InMemoryLocalStore store;

  @override
  Future<void> delete(String id) async {
    store.notificationRules.remove(id);
  }

  @override
  Future<List<NotificationRule>> getAll() async {
    final items = store.notificationRules.values.toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<List<NotificationRule>> getByTargetId(String targetId) async {
    final items = store.notificationRules.values
        .where((entry) => entry.targetId == targetId)
        .toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<void> save(NotificationRule rule) async {
    store.notificationRules[rule.id] = rule;
  }
}
