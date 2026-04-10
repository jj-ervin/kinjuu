import '../entities/notification_rule.dart';
import '../entities/obligation.dart';
import '../entities/reminder_plan_entry.dart';

abstract class NotificationService {
  List<ReminderPlanEntry> buildPlanForObligation({
    required Obligation obligation,
    required List<NotificationRule> rules,
    required String notificationTitle,
    required String notificationBody,
    DateTime? now,
  });

  Future<void> schedulePlan(List<ReminderPlanEntry> entries);
  Future<void> cancelByTarget(String targetId);
}

