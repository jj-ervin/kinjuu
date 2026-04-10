import '../../domain/entities/obligation.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/enums/obligation_type.dart';
import '../../domain/enums/recurrence_rule_style.dart';
import '../../domain/enums/source_type.dart';
import 'model_utils.dart';

class ObligationModel extends Obligation {
  ObligationModel({
    required super.id,
    required super.title,
    required super.obligationType,
    required super.sourceType,
    required super.linkedAccountId,
    required super.linkedCardId,
    required super.expectedAmount,
    required super.minimumAmount,
    required super.currencyCode,
    required super.dueDate,
    required super.statementDate,
    required super.recurrenceRule,
    required super.status,
    required super.autopayExpected,
    required super.category,
    required super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ObligationModel.fromEntity(Obligation obligation) {
    return ObligationModel(
      id: obligation.id,
      title: obligation.title,
      obligationType: obligation.obligationType,
      sourceType: obligation.sourceType,
      linkedAccountId: obligation.linkedAccountId,
      linkedCardId: obligation.linkedCardId,
      expectedAmount: obligation.expectedAmount,
      minimumAmount: obligation.minimumAmount,
      currencyCode: obligation.currencyCode,
      dueDate: obligation.dueDate,
      statementDate: obligation.statementDate,
      recurrenceRule: obligation.recurrenceRule,
      status: obligation.status,
      autopayExpected: obligation.autopayExpected,
      category: obligation.category,
      notes: obligation.notes,
      createdAt: obligation.createdAt,
      updatedAt: obligation.updatedAt,
    );
  }

  factory ObligationModel.fromMap(Map<String, Object?> map) {
    return ObligationModel(
      id: ModelUtils.readString(map, 'id'),
      title: ModelUtils.readString(map, 'title'),
      obligationType: ObligationType.fromStorage(
        ModelUtils.readString(map, 'obligation_type'),
      ),
      sourceType: SourceType.fromStorage(
        ModelUtils.readString(map, 'source_type'),
      ),
      linkedAccountId: ModelUtils.readNullableString(map, 'linked_account_id'),
      linkedCardId: ModelUtils.readNullableString(map, 'linked_card_id'),
      expectedAmount: ModelUtils.readNullableDouble(map, 'expected_amount'),
      minimumAmount: ModelUtils.readNullableDouble(map, 'minimum_amount'),
      currencyCode: ModelUtils.readString(map, 'currency_code'),
      dueDate: ModelUtils.readDateTime(map, 'due_date'),
      statementDate: ModelUtils.readNullableDateTime(map, 'statement_date'),
      recurrenceRule: RecurrenceRuleStyle.fromStorage(
        ModelUtils.readString(map, 'recurrence_rule'),
      ),
      status: ObligationStatus.fromStorage(ModelUtils.readString(map, 'status')),
      autopayExpected: ModelUtils.readBool(map, 'autopay_expected'),
      category: ModelUtils.readString(map, 'category'),
      notes: ModelUtils.readString(map, 'notes'),
      createdAt: ModelUtils.readDateTime(map, 'created_at'),
      updatedAt: ModelUtils.readDateTime(map, 'updated_at'),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'obligation_type': obligationType.storageValue,
      'source_type': sourceType.storageValue,
      'linked_account_id': linkedAccountId,
      'linked_card_id': linkedCardId,
      'expected_amount': expectedAmount,
      'minimum_amount': minimumAmount,
      'currency_code': currencyCode,
      'due_date': dueDate.toIso8601String(),
      'statement_date': statementDate?.toIso8601String(),
      'recurrence_rule': recurrenceRule.storageValue,
      'status': status.storageValue,
      'autopay_expected': ModelUtils.boolToSql(autopayExpected),
      'category': category,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
