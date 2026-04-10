import '../../domain/entities/subscription.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/enums/recurrence_rule_style.dart';
import '../../domain/enums/source_type.dart';
import 'model_utils.dart';

class SubscriptionModel extends Subscription {
  SubscriptionModel({
    required super.id,
    required super.title,
    required super.providerName,
    required super.sourceType,
    required super.billingCycle,
    required super.expectedAmount,
    required super.renewalDate,
    required super.linkedAccountId,
    required super.linkedCardId,
    required super.status,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SubscriptionModel.fromMap(Map<String, Object?> map) {
    return SubscriptionModel(
      id: ModelUtils.readString(map, 'id'),
      title: ModelUtils.readString(map, 'title'),
      providerName: ModelUtils.readString(map, 'provider_name'),
      sourceType: SourceType.fromStorage(
        ModelUtils.readString(map, 'source_type'),
      ),
      billingCycle: RecurrenceRuleStyle.fromStorage(
        ModelUtils.readString(map, 'billing_cycle'),
      ),
      expectedAmount: ModelUtils.readNullableDouble(map, 'expected_amount'),
      renewalDate: ModelUtils.readDateTime(map, 'renewal_date'),
      linkedAccountId: ModelUtils.readNullableString(map, 'linked_account_id'),
      linkedCardId: ModelUtils.readNullableString(map, 'linked_card_id'),
      status: ObligationStatus.fromStorage(ModelUtils.readString(map, 'status')),
      notes: ModelUtils.readString(map, 'notes'),
      createdAt: ModelUtils.readDateTime(map, 'created_at'),
      updatedAt: ModelUtils.readDateTime(map, 'updated_at'),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'provider_name': providerName,
      'source_type': sourceType.storageValue,
      'billing_cycle': billingCycle.storageValue,
      'expected_amount': expectedAmount,
      'renewal_date': renewalDate.toIso8601String(),
      'linked_account_id': linkedAccountId,
      'linked_card_id': linkedCardId,
      'status': status.storageValue,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

