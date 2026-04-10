import '../../domain/entities/payment_event.dart';
import '../../domain/repositories/payment_event_repository.dart';
import 'local_repository_base.dart';

class LocalPaymentEventRepository extends LocalRepositoryBase
    implements PaymentEventRepository {
  LocalPaymentEventRepository(super.database);

  @override
  Future<List<PaymentEvent>> getByObligationId(String obligationId) async {
    // TODO(pass-0003): Query payment events for a given obligation.
    throw UnimplementedError();
  }

  @override
  Future<void> save(PaymentEvent event) async {
    // TODO(pass-0003): Insert a payment event into local storage.
    throw UnimplementedError();
  }
}

