import '../enums/notification_target_type.dart';
import '../enums/reminder_event_type.dart';
import 'quiet_hours_window.dart';
import 'time_loc_record.dart';

class ReminderPlanEntry {
  const ReminderPlanEntry({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.eventType,
    required this.scheduledFor,
    required this.title,
    required this.body,
    required this.daysBefore,
    required this.quietHours,
    required this.timeLoc,
  });

  final String id;
  final NotificationTargetType targetType;
  final String targetId;
  final ReminderEventType eventType;
  final DateTime scheduledFor;
  final String title;
  final String body;
  final int? daysBefore;
  final QuietHoursWindow? quietHours;
  final TimeLocRecord? timeLoc;
}

