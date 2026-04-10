import '../../domain/entities/notification_rule.dart';
import '../../domain/enums/notification_target_type.dart';

abstract final class NotificationDefaults {
  static const defaultDaysBefore = <int>[7, 3, 1];
  static const defaultOverdueIntervalDays = 1;

  static List<NotificationRule> globalDefaults({DateTime? now}) {
    final timestamp = now ?? DateTime.now();

    return [
      for (final days in defaultDaysBefore)
        NotificationRule(
          id: 'global-default-$days-days-before',
          targetType: NotificationTargetType.globalDefault,
          targetId: null,
          daysBefore: days,
          triggerOnDueDate: false,
          triggerIfOverdue: false,
          overdueIntervalDays: null,
          isEnabled: true,
          quietHoursStart: '22:00',
          quietHoursEnd: '07:00',
          createdAt: timestamp,
          updatedAt: timestamp,
        ),
      NotificationRule(
        id: 'global-default-due-date',
        targetType: NotificationTargetType.globalDefault,
        targetId: null,
        daysBefore: 0,
        triggerOnDueDate: true,
        triggerIfOverdue: false,
        overdueIntervalDays: null,
        isEnabled: true,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
        createdAt: timestamp,
        updatedAt: timestamp,
      ),
      NotificationRule(
        id: 'global-default-overdue',
        targetType: NotificationTargetType.globalDefault,
        targetId: null,
        daysBefore: 0,
        triggerOnDueDate: false,
        triggerIfOverdue: true,
        overdueIntervalDays: defaultOverdueIntervalDays,
        isEnabled: true,
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
        createdAt: timestamp,
        updatedAt: timestamp,
      ),
    ];
  }
}

