import '../../domain/entities/payment_event.dart';
import '../../domain/enums/payment_event_type.dart';
import 'model_utils.dart';
import 'time_loc_record_model.dart';

class PaymentEventModel extends PaymentEvent {
  PaymentEventModel({
    required super.id,
    required super.obligationId,
    required super.eventType,
    required super.eventDate,
    required super.amount,
    required super.note,
    required super.createdAt,
    required super.timeLoc,
  });

  factory PaymentEventModel.fromMap(Map<String, Object?> map) {
    return PaymentEventModel(
      id: ModelUtils.readString(map, 'id'),
      obligationId: ModelUtils.readString(map, 'obligation_id'),
      eventType: PaymentEventType.fromStorage(
        ModelUtils.readString(map, 'event_type'),
      ),
      eventDate: ModelUtils.readDateTime(map, 'event_date'),
      amount: ModelUtils.readNullableDouble(map, 'amount'),
      note: ModelUtils.readNullableString(map, 'note'),
      createdAt: ModelUtils.readDateTime(map, 'created_at'),
      timeLoc: ModelUtils.readNullableString(map, 'time_loc') == null
          ? null
          : TimeLocRecordModel.fromJsonString(
              ModelUtils.readString(map, 'time_loc'),
            ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'obligation_id': obligationId,
      'event_type': eventType.storageValue,
      'event_date': eventDate.toIso8601String(),
      'amount': amount,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'time_loc': timeLoc == null
          ? null
          : TimeLocRecordModel.fromEntity(timeLoc!).toJsonString(),
    };
  }
}
