import '../../domain/entities/notification_rule.dart';
import '../../domain/enums/notification_target_type.dart';
import 'model_utils.dart';

class NotificationRuleModel extends NotificationRule {
  NotificationRuleModel({
    required super.id,
    required super.targetType,
    required super.targetId,
    required super.daysBefore,
    required super.triggerOnDueDate,
    required super.triggerIfOverdue,
    required super.overdueIntervalDays,
    required super.isEnabled,
    required super.quietHoursStart,
    required super.quietHoursEnd,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NotificationRuleModel.fromMap(Map<String, Object?> map) {
    return NotificationRuleModel(
      id: ModelUtils.readString(map, 'id'),
      targetType: NotificationTargetType.fromStorage(
        ModelUtils.readString(map, 'target_type'),
      ),
      targetId: ModelUtils.readNullableString(map, 'target_id'),
      daysBefore: ModelUtils.readInt(map, 'days_before'),
      triggerOnDueDate: ModelUtils.readBool(map, 'trigger_on_due_date'),
      triggerIfOverdue: ModelUtils.readBool(map, 'trigger_if_overdue'),
      overdueIntervalDays: ModelUtils.readNullableInt(
        map,
        'overdue_interval_days',
      ),
      isEnabled: ModelUtils.readBool(map, 'is_enabled'),
      quietHoursStart: ModelUtils.readNullableString(map, 'quiet_hours_start'),
      quietHoursEnd: ModelUtils.readNullableString(map, 'quiet_hours_end'),
      createdAt: ModelUtils.readDateTime(map, 'created_at'),
      updatedAt: ModelUtils.readDateTime(map, 'updated_at'),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'target_type': targetType.storageValue,
      'target_id': targetId,
      'days_before': daysBefore,
      'trigger_on_due_date': ModelUtils.boolToSql(triggerOnDueDate),
      'trigger_if_overdue': ModelUtils.boolToSql(triggerIfOverdue),
      'overdue_interval_days': overdueIntervalDays,
      'is_enabled': ModelUtils.boolToSql(isEnabled),
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

