import '../entities/subscription.dart';
import '../enums/obligation_status.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getAll();
  Future<Subscription?> getById(String id);
  Future<void> save(Subscription subscription);
  Future<void> updateStatus(String id, ObligationStatus status);
}
