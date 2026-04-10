import '../enums/payment_event_type.dart';
import 'time_loc_record.dart';

class PaymentEvent {
  PaymentEvent({
    required this.id,
    required this.obligationId,
    required this.eventType,
    required this.eventDate,
    required this.amount,
    required this.note,
    required this.createdAt,
    required this.timeLoc,
  });

  final String id;
  final String obligationId;
  final PaymentEventType eventType;
  final DateTime eventDate;
  final double? amount;
  final String? note;
  final DateTime createdAt;
  final TimeLocRecord? timeLoc;
}
