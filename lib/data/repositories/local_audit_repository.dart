import '../../domain/entities/audit_entry.dart';
import '../../domain/repositories/audit_repository.dart';
import 'local_repository_base.dart';

class LocalAuditRepository extends LocalRepositoryBase implements AuditRepository {
  LocalAuditRepository(super.database);

  @override
  Future<List<AuditEntry>> getRecent({int limit = 50}) async {
    final items = LocalRepositoryBase.store.auditEntries.values.toList();
    items.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return items.take(limit).toList(growable: false);
  }

  @override
  Future<void> save(AuditEntry entry) async {
    LocalRepositoryBase.store.auditEntries[entry.id] = entry;
  }
}
