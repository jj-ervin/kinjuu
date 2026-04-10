import '../../domain/entities/obligation.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/repositories/obligation_repository.dart';
import '../database/local_database.dart';
import 'local_repository_base.dart';

class LocalObligationRepository extends LocalRepositoryBase
    implements ObligationRepository {
  LocalObligationRepository(super.database);

  @override
  Future<void> archive(String id) async {
    // TODO(pass-0003): Implement archive persistence once concrete SQLite access is wired.
    throw UnimplementedError();
  }

  @override
  Future<List<Obligation>> getAll() async {
    // TODO(pass-0003): Query all obligations from local storage.
    throw UnimplementedError();
  }

  @override
  Future<Obligation?> getById(String id) async {
    // TODO(pass-0003): Query a single obligation by id.
    throw UnimplementedError();
  }

  @override
  Future<List<Obligation>> getUpcoming() async {
    // TODO(pass-0003): Query upcoming obligations after status derivation is defined.
    throw UnimplementedError();
  }

  @override
  Future<void> save(Obligation obligation) async {
    // TODO(pass-0003): Insert or update a local obligation.
    throw UnimplementedError();
  }

  @override
  Future<void> updateStatus(String id, ObligationStatus status) async {
    // TODO(pass-0003): Persist status changes using the constrained obligation statuses.
    throw UnimplementedError();
  }
}
