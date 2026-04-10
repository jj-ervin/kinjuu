import '../entities/obligation.dart';
import '../enums/obligation_status.dart';

abstract class ObligationRepository {
  Future<List<Obligation>> getAll();
  Future<List<Obligation>> getUpcoming();
  Future<Obligation?> getById(String id);
  Future<void> save(Obligation obligation);
  Future<void> updateStatus(String id, ObligationStatus status);
  Future<void> archive(String id);
}
