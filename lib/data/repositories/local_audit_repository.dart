import '../../domain/entities/audit_entry.dart';
import '../../domain/repositories/audit_repository.dart';
import '../models/audit_entry_model.dart';
import 'local_repository_base.dart';

class LocalAuditRepository extends LocalRepositoryBase implements AuditRepository {
  LocalAuditRepository(super.database);

  @override
  Future<List<AuditEntry>> getRecent({int limit = 50}) async {
    final rows = await database.query(
      'SELECT * FROM audit_entries ORDER BY created_at DESC LIMIT ?',
      <Object?>[limit],
    );
    final items = rows.map(AuditEntryModel.fromMap).toList();
    items.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return items.take(limit).toList(growable: false);
  }

  @override
  Future<void> save(AuditEntry entry) async {
    await database.insert(
      'audit_entries',
      AuditEntryModel.fromEntity(entry).toMap(),
    );
  }
}
