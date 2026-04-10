import '../../domain/entities/subscription.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/repositories/subscription_repository.dart';
import 'local_repository_base.dart';

class LocalSubscriptionRepository extends LocalRepositoryBase
    implements SubscriptionRepository {
  LocalSubscriptionRepository(super.database);

  @override
  Future<List<Subscription>> getAll() async {
    final items =
        LocalRepositoryBase.store.subscriptions.values.toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<Subscription?> getById(String id) async {
    return LocalRepositoryBase.store.subscriptions[id];
  }

  @override
  Future<void> save(Subscription subscription) async {
    LocalRepositoryBase.store.subscriptions[subscription.id] = subscription;
  }

  @override
  Future<void> updateStatus(String id, ObligationStatus status) async {
    final existing = LocalRepositoryBase.store.subscriptions[id];
    if (existing == null) {
      return;
    }

    LocalRepositoryBase.store.subscriptions[id] = Subscription(
      id: existing.id,
      title: existing.title,
      providerName: existing.providerName,
      sourceType: existing.sourceType,
      billingCycle: existing.billingCycle,
      expectedAmount: existing.expectedAmount,
      renewalDate: existing.renewalDate,
      linkedAccountId: existing.linkedAccountId,
      linkedCardId: existing.linkedCardId,
      status: status,
      notes: existing.notes,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
