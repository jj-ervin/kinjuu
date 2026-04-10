import '../../domain/entities/audit_entry.dart';
import '../../domain/repositories/audit_repository.dart';
import '../database/local_database.dart';
import 'local_repository_base.dart';

class LocalAuditRepository extends LocalRepositoryBase implements AuditRepository {
  LocalAuditRepository(super.database);

  @override
  Future<List<AuditEntry>> getRecent({int limit = 50}) async {
    // TODO(pass-0003): Query recent audit entries in descending timestamp order.
    throw UnimplementedError();
  }

  @override
  Future<void> save(AuditEntry entry) async {
    // TODO(pass-0003): Insert an audit entry into local storage.
    throw UnimplementedError();
  }
}
