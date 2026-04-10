import '../../domain/entities/payment_event.dart';
import '../../domain/repositories/payment_event_repository.dart';
import 'local_repository_base.dart';

class LocalPaymentEventRepository extends LocalRepositoryBase
    implements PaymentEventRepository {
  LocalPaymentEventRepository(super.database);

  @override
  Future<List<PaymentEvent>> getByObligationId(String obligationId) async {
    final items = LocalRepositoryBase.store.paymentEvents.values
        .where((entry) => entry.obligationId == obligationId)
        .toList(growable: false);
    items.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return items;
  }

  @override
  Future<void> save(PaymentEvent event) async {
    LocalRepositoryBase.store.paymentEvents[event.id] = event;
  }
}
