import '../../domain/entities/obligation.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/repositories/obligation_repository.dart';
import 'local_repository_base.dart';

class LocalObligationRepository extends LocalRepositoryBase
    implements ObligationRepository {
  LocalObligationRepository(super.database);

  @override
  Future<void> archive(String id) async {
    final existing = LocalRepositoryBase.store.obligations[id];
    if (existing == null) {
      return;
    }

    LocalRepositoryBase.store.obligations[id] = Obligation(
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
    final items =
        LocalRepositoryBase.store.obligations.values.toList(growable: false);
    items.sort((left, right) => left.dueDate.compareTo(right.dueDate));
    return items;
  }

  @override
  Future<Obligation?> getById(String id) async {
    return LocalRepositoryBase.store.obligations[id];
  }

  @override
  Future<List<Obligation>> getUpcoming() async {
    final items = LocalRepositoryBase.store.obligations.values
        .where((entry) => entry.status != ObligationStatus.archived)
        .toList(growable: false);
    items.sort((left, right) => left.dueDate.compareTo(right.dueDate));
    return items;
  }

  @override
  Future<void> save(Obligation obligation) async {
    LocalRepositoryBase.store.obligations[obligation.id] = obligation;
  }

  @override
  Future<void> updateStatus(String id, ObligationStatus status) async {
    final existing = LocalRepositoryBase.store.obligations[id];
    if (existing == null) {
      return;
    }

    LocalRepositoryBase.store.obligations[id] = Obligation(
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
