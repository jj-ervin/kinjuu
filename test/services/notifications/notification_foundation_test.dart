import 'package:flutter_test/flutter_test.dart';
import 'package:kinjuu/domain/entities/obligation.dart';
import 'package:kinjuu/domain/enums/obligation_status.dart';
import 'package:kinjuu/domain/enums/obligation_type.dart';
import 'package:kinjuu/domain/enums/recurrence_rule_style.dart';
import 'package:kinjuu/domain/enums/reminder_event_type.dart';
import 'package:kinjuu/domain/enums/source_type.dart';
import 'package:kinjuu/services/notifications/local_notification_service.dart';
import 'package:kinjuu/services/notifications/notification_defaults.dart';
import 'package:kinjuu/services/notifications/obligation_status_service_impl.dart';
import 'package:kinjuu/services/notifications/recurrence_service_impl.dart';

void main() {
  group('Notification foundation', () {
    test('global defaults include day offsets, due date, and overdue rule', () {
      final now = DateTime(2026, 4, 10, 12);

      final rules = NotificationDefaults.globalDefaults(now: now);

      expect(rules.length, 5);
      expect(rules.where((rule) => rule.daysBefore > 0).map((r) => r.daysBefore), [7, 3, 1]);
      expect(rules.any((rule) => rule.triggerOnDueDate), isTrue);
      expect(rules.any((rule) => rule.triggerIfOverdue), isTrue);
    });

    test('notification service builds ordered reminder plan', () {
      final service = LocalNotificationService();
      final now = DateTime(2026, 4, 10, 12);
      final obligation = _buildObligation(dueDate: DateTime(2026, 4, 20));

      final entries = service.buildPlanForObligation(
        obligation: obligation,
        rules: NotificationDefaults.globalDefaults(now: now),
        notificationTitle: 'Electric bill due soon',
        notificationBody: 'Reminder body',
        now: now,
      );

      expect(entries.length, 5);
      expect(entries.first.eventType, ReminderEventType.daysBefore);
      expect(entries.last.eventType, ReminderEventType.overdue);
      expect(entries.map((entry) => entry.scheduledFor), orderedEquals([...entries.map((entry) => entry.scheduledFor)]..sort()));
    });

    test('status service derives due today and overdue correctly', () {
      final service = ObligationStatusServiceImpl();
      final now = DateTime(2026, 4, 10, 8);

      final dueToday = _buildObligation(dueDate: DateTime(2026, 4, 10));
      final overdue = _buildObligation(dueDate: DateTime(2026, 4, 9));

      expect(service.deriveStatus(dueToday, now: now), ObligationStatus.dueToday);
      expect(service.deriveStatus(overdue, now: now), ObligationStatus.overdue);
    });

    test('recurrence service calculates monthly follow-up date', () {
      final service = RecurrenceServiceImpl();

      final next = service.nextOccurrence(
        recurrenceRule: RecurrenceRuleStyle.monthly,
        anchorDate: DateTime(2026, 1, 31, 9),
        after: DateTime(2026, 2, 1),
      );

      expect(next, DateTime(2026, 2, 28, 9));
    });
  });
}

Obligation _buildObligation({required DateTime dueDate}) {
  return Obligation(
    id: 'obl-1',
    title: 'Electric bill',
    obligationType: ObligationType.bill,
    sourceType: SourceType.manual,
    linkedAccountId: null,
    linkedCardId: null,
    expectedAmount: 120,
    minimumAmount: null,
    currencyCode: 'USD',
    dueDate: dueDate,
    statementDate: null,
    recurrenceRule: RecurrenceRuleStyle.monthly,
    status: ObligationStatus.upcoming,
    autopayExpected: false,
    category: 'Utilities',
    notes: '',
    createdAt: DateTime(2026, 4, 1),
    updatedAt: DateTime(2026, 4, 1),
  );
}
