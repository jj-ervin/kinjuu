import '../entities/audit_entry.dart';

abstract class AuditRepository {
  Future<List<AuditEntry>> getRecent({int limit = 50});
  Future<void> save(AuditEntry entry);
}
