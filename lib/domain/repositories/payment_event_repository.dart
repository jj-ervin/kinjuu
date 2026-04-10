import '../entities/payment_event.dart';

abstract class PaymentEventRepository {
  Future<List<PaymentEvent>> getByObligationId(String obligationId);
  Future<void> save(PaymentEvent event);
}

