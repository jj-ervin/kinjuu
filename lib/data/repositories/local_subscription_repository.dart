import '../../domain/entities/subscription.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../database/local_database.dart';
import 'local_repository_base.dart';

class LocalSubscriptionRepository extends LocalRepositoryBase
    implements SubscriptionRepository {
  LocalSubscriptionRepository(super.database);

  @override
  Future<List<Subscription>> getAll() async {
    // TODO(pass-0003): Query all subscriptions from local storage.
    throw UnimplementedError();
  }

  @override
  Future<Subscription?> getById(String id) async {
    // TODO(pass-0003): Query a single subscription by id.
    throw UnimplementedError();
  }

  @override
  Future<void> save(Subscription subscription) async {
    // TODO(pass-0003): Insert or update a local subscription.
    throw UnimplementedError();
  }

  @override
  Future<void> updateStatus(String id, ObligationStatus status) async {
    // TODO(pass-0003): Persist subscription status changes.
    throw UnimplementedError();
  }
}
