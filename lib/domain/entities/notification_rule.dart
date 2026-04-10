import '../enums/notification_target_type.dart';

class NotificationRule {
  NotificationRule({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.daysBefore,
    required this.triggerOnDueDate,
    required this.triggerIfOverdue,
    required this.overdueIntervalDays,
    required this.isEnabled,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final NotificationTargetType targetType;
  final String? targetId;
  final int daysBefore;
  final bool triggerOnDueDate;
  final bool triggerIfOverdue;
  final int? overdueIntervalDays;
  final bool isEnabled;
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final DateTime createdAt;
  final DateTime updatedAt;
}

