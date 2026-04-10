import '../../domain/entities/obligation.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/repositories/obligation_repository.dart';
import '../models/obligation_model.dart';
import 'local_repository_base.dart';

class LocalObligationRepository extends LocalRepositoryBase
    implements ObligationRepository {
  LocalObligationRepository(super.database);

  @override
  Future<void> archive(String id) async {
    final existing = await getById(id);
    if (existing == null) {
      return;
    }

    await save(Obligation(
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
    ));
  }

  @override
  Future<List<Obligation>> getAll() async {
    final rows = await database.query(
      'SELECT * FROM obligations ORDER BY due_date ASC',
    );
    final items =
        rows.map(ObligationModel.fromMap).toList(growable: false);
    items.sort((left, right) => left.dueDate.compareTo(right.dueDate));
    return items;
  }

  @override
  Future<Obligation?> getById(String id) async {
    final rows = await database.query(
      'SELECT * FROM obligations WHERE id = ? LIMIT 1',
      <Object?>[id],
    );
    if (rows.isEmpty) {
      return null;
    }
    return ObligationModel.fromMap(rows.first);
  }

  @override
  Future<List<Obligation>> getUpcoming() async {
    final rows = await database.query(
      'SELECT * FROM obligations WHERE status != ? ORDER BY due_date ASC',
      <Object?>[ObligationStatus.archived.storageValue],
    );
    final items = rows
        .map(ObligationModel.fromMap)
        .where((entry) => entry.status != ObligationStatus.archived)
        .toList(growable: false);
    items.sort((left, right) => left.dueDate.compareTo(right.dueDate));
    return items;
  }

  @override
  Future<void> save(Obligation obligation) async {
    await database.insert(
      'obligations',
      ObligationModel.fromEntity(obligation).toMap(),
    );
  }

  @override
  Future<void> updateStatus(String id, ObligationStatus status) async {
    final existing = await getById(id);
    if (existing == null) {
      return;
    }

    await save(Obligation(
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
    ));
  }
}
