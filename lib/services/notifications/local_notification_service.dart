import '../../domain/entities/notification_rule.dart';
import '../../domain/entities/obligation.dart';
import '../../domain/entities/quiet_hours_window.dart';
import '../../domain/entities/reminder_plan_entry.dart';
import '../../domain/enums/notification_target_type.dart';
import '../../domain/enums/reminder_event_type.dart';
import '../../domain/services/notification_service.dart';

class LocalNotificationService implements NotificationService {
  @override
  List<ReminderPlanEntry> buildPlanForObligation({
    required Obligation obligation,
    required List<NotificationRule> rules,
    required String notificationTitle,
    required String notificationBody,
    DateTime? now,
  }) {
    final referenceTime = now ?? DateTime.now();
    final entries = <ReminderPlanEntry>[];

    for (final rule in rules.where((entry) => entry.isEnabled)) {
      final quietHours = _parseQuietHours(rule);

      if (rule.daysBefore > 0) {
        final scheduled = _applyQuietHours(
          DateTime(
            obligation.dueDate.year,
            obligation.dueDate.month,
            obligation.dueDate.day,
            9,
          ).subtract(Duration(days: rule.daysBefore)),
          quietHours,
        );

        if (!scheduled.isBefore(referenceTime)) {
          entries.add(
            ReminderPlanEntry(
              id: '${obligation.id}-before-${rule.daysBefore}',
              targetType: NotificationTargetType.obligation,
              targetId: obligation.id,
              eventType: ReminderEventType.daysBefore,
              scheduledFor: scheduled,
              title: notificationTitle,
              body: notificationBody,
              daysBefore: rule.daysBefore,
              quietHours: quietHours,
              timeLoc: null,
            ),
          );
        }
      }

      if (rule.triggerOnDueDate) {
        final scheduled = _applyQuietHours(
          DateTime(
            obligation.dueDate.year,
            obligation.dueDate.month,
            obligation.dueDate.day,
            9,
          ),
          quietHours,
        );

        if (!scheduled.isBefore(referenceTime)) {
          entries.add(
            ReminderPlanEntry(
              id: '${obligation.id}-due-date',
              targetType: NotificationTargetType.obligation,
              targetId: obligation.id,
              eventType: ReminderEventType.dueDate,
              scheduledFor: scheduled,
              title: notificationTitle,
              body: notificationBody,
              daysBefore: 0,
              quietHours: quietHours,
              timeLoc: null,
            ),
          );
        }
      }

      if (rule.triggerIfOverdue) {
        final interval = rule.overdueIntervalDays ?? 1;
        final scheduled = _applyQuietHours(
          DateTime(
            obligation.dueDate.year,
            obligation.dueDate.month,
            obligation.dueDate.day,
            9,
          ).add(Duration(days: interval)),
          quietHours,
        );

        if (!scheduled.isBefore(referenceTime)) {
          entries.add(
            ReminderPlanEntry(
              id: '${obligation.id}-overdue-$interval',
              targetType: NotificationTargetType.obligation,
              targetId: obligation.id,
              eventType: ReminderEventType.overdue,
              scheduledFor: scheduled,
              title: notificationTitle,
              body: notificationBody,
              daysBefore: -interval,
              quietHours: quietHours,
              timeLoc: null,
            ),
          );
        }
      }
    }

    entries.sort((left, right) => left.scheduledFor.compareTo(right.scheduledFor));
    return entries;
  }

  @override
  Future<void> cancelByTarget(String targetId) async {
    // TODO(scaffold-debt): Bridge target-based cancellation to a local device
    // notification plugin once platform scheduling is intentionally in scope.
  }

  @override
  Future<void> schedulePlan(List<ReminderPlanEntry> entries) async {
    // TODO(scaffold-debt): Bridge reminder plan entries to a local device
    // notification plugin once platform scheduling is intentionally in scope.
  }

  QuietHoursWindow? _parseQuietHours(NotificationRule rule) {
    final start = rule.quietHoursStart;
    final end = rule.quietHoursEnd;
    if (start == null || end == null) {
      return null;
    }

    final startParts = start.split(':');
    final endParts = end.split(':');
    if (startParts.length != 2 || endParts.length != 2) {
      return null;
    }

    final startHour = int.tryParse(startParts[0]);
    final startMinute = int.tryParse(startParts[1]);
    final endHour = int.tryParse(endParts[0]);
    final endMinute = int.tryParse(endParts[1]);

    if (!_isValidHourMinute(startHour, startMinute) ||
        !_isValidHourMinute(endHour, endMinute)) {
      return null;
    }

    return QuietHoursWindow(
      startHour: startHour!,
      startMinute: startMinute!,
      endHour: endHour!,
      endMinute: endMinute!,
    );
  }

  bool _isValidHourMinute(int? hour, int? minute) {
    if (hour == null || minute == null) {
      return false;
    }

    return hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59;
  }

  DateTime _applyQuietHours(DateTime scheduledFor, QuietHoursWindow? quietHours) {
    if (quietHours == null || !quietHours.contains(scheduledFor)) {
      return scheduledFor;
    }

    final adjusted = DateTime(
      scheduledFor.year,
      scheduledFor.month,
      scheduledFor.day,
      quietHours.endHour,
      quietHours.endMinute,
    );

    if (!adjusted.isBefore(scheduledFor)) {
      return adjusted;
    }

    return adjusted.add(const Duration(days: 1));
  }
}
