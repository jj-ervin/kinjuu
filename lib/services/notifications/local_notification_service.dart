import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/entities/notification_rule.dart';
import '../../domain/entities/obligation.dart';
import '../../domain/entities/quiet_hours_window.dart';
import '../../domain/entities/reminder_plan_entry.dart';
import '../../domain/enums/notification_target_type.dart';
import '../../domain/enums/reminder_event_type.dart';
import '../../domain/services/notification_service.dart';

class LocalNotificationService implements NotificationService {
  LocalNotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'kinjuu_obligation_reminders',
    'Obligation reminders',
    description: 'Scheduled reminders for tracked Kinjuu obligations.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _plugin;
  bool _isInitialized = false;

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
    if (!_supportsScheduling) {
      return;
    }

    await _ensureInitialized();
    final requests = await _plugin.pendingNotificationRequests();
    for (final request in requests) {
      if (_isRequestForTarget(request, targetId)) {
        await _plugin.cancel(request.id);
      }
    }
  }

  @override
  Future<void> schedulePlan(List<ReminderPlanEntry> entries) async {
    if (!_supportsScheduling || entries.isEmpty) {
      return;
    }

    await _ensureInitialized();
    final now = DateTime.now();
    for (final entry in entries) {
      if (entry.scheduledFor.isBefore(now)) {
        continue;
      }

      await _plugin.zonedSchedule(
        _notificationIdFor(entry.id),
        entry.title,
        entry.body,
        tz.TZDateTime.from(entry.scheduledFor, tz.local),
        _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: _payloadForEntry(entry),
      );
    }
  }

  bool get _supportsScheduling {
    if (kIsWeb) {
      return false;
    }

    return Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isLinux;
  }

  NotificationDetails get _notificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'kinjuu_obligation_reminders',
        'Obligation reminders',
        channelDescription: 'Scheduled reminders for tracked Kinjuu obligations.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(),
    );
  }

  Future<void> _ensureInitialized() async {
    if (_isInitialized) {
      return;
    }

    tz_data.initializeTimeZones();
    await _configureLocalTimezone();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      linux: LinuxInitializationSettings(defaultActionName: 'Open notification'),
    );

    await _plugin.initialize(initializationSettings);
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    await _requestPermissions();
    _isInitialized = true;
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  Future<void> _requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  bool _isRequestForTarget(PendingNotificationRequest request, String targetId) {
    final payload = request.payload;
    return payload != null && payload.startsWith('obligation:$targetId:');
  }

  int _notificationIdFor(String value) {
    var hash = 0x811c9dc5;
    for (final codeUnit in value.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash;
  }

  String _payloadForEntry(ReminderPlanEntry entry) {
    return '${entry.targetType.storageValue}:${entry.targetId}:${entry.id}';
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
