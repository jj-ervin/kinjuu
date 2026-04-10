import '../../domain/entities/payment_event.dart';
import '../../domain/repositories/payment_event_repository.dart';
import '../models/payment_event_model.dart';
import 'local_repository_base.dart';

class LocalPaymentEventRepository extends LocalRepositoryBase
    implements PaymentEventRepository {
  LocalPaymentEventRepository(super.database);

  @override
  Future<List<PaymentEvent>> getByObligationId(String obligationId) async {
    final rows = await database.query(
      'SELECT * FROM payment_events WHERE obligation_id = ? ORDER BY created_at DESC',
      <Object?>[obligationId],
    );
    final items =
        rows.map(PaymentEventModel.fromMap).toList(growable: false);
    items.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return items;
  }

  @override
  Future<void> save(PaymentEvent event) async {
    await database.insert(
      'payment_events',
      PaymentEventModel.fromEntity(event).toMap(),
    );
  }
}
