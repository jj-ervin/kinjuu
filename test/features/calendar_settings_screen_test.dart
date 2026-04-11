import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinjuu/app/state/kinjuu_app_controller.dart';
import 'package:kinjuu/app/state/kinjuu_app_scope.dart';
import 'package:kinjuu/domain/entities/notification_rule.dart';
import 'package:kinjuu/domain/entities/obligation.dart';
import 'package:kinjuu/domain/entities/reminder_plan_entry.dart';
import 'package:kinjuu/domain/enums/obligation_type.dart';
import 'package:kinjuu/domain/enums/recurrence_rule_style.dart';
import 'package:kinjuu/domain/services/notification_service.dart';
import 'package:kinjuu/features/calendar/presentation/calendar_screen.dart';
import 'package:kinjuu/features/settings/presentation/settings_screen.dart';
import 'package:kinjuu/services/notifications/local_notification_service.dart';

void main() {
  group('Calendar and settings screens', () {
    late KinjuuAppController controller;

    setUp(() async {
      controller = KinjuuAppController.inMemory(
        notificationService: _FakeNotificationService(),
      );
      await controller.load();
    });

    testWidgets('calendar screen shows persisted obligation sections',
        (tester) async {
      await controller.saveObligation(
        title: 'Rent',
        obligationType: ObligationType.bill,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        recurrenceRule: RecurrenceRuleStyle.monthly,
        expectedAmount: 1200,
        minimumAmount: null,
        currencyCode: 'USD',
        autopayExpected: false,
        category: 'Housing',
        notes: 'Monthly rent',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: KinjuuAppScope(
            controller: controller,
            child: const CalendarScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Next 7 days'), findsOneWidget);
      expect(find.text('Rent'), findsOneWidget);
      expect(find.text('Upcoming consistency'), findsOneWidget);
    });

    testWidgets('settings screen shows persisted reminder defaults',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: KinjuuAppScope(
            controller: controller,
            child: const SettingsScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Reminder defaults'), findsOneWidget);
      expect(find.text('7 days before'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Current behavior'),
        200,
        scrollable: find.byType(Scrollable),
      );
      await tester.pump();
      expect(find.text('Quiet hours'), findsOneWidget);
      expect(find.text('Current behavior'), findsOneWidget);
    });
  });
}

class _FakeNotificationService implements NotificationService {
  _FakeNotificationService() : _planner = LocalNotificationService();

  final LocalNotificationService _planner;

  @override
  List<ReminderPlanEntry> buildPlanForObligation({
    required Obligation obligation,
    required List<NotificationRule> rules,
    required String notificationTitle,
    required String notificationBody,
    DateTime? now,
  }) {
    return _planner.buildPlanForObligation(
      obligation: obligation,
      rules: rules,
      notificationTitle: notificationTitle,
      notificationBody: notificationBody,
      now: now,
    );
  }

  @override
  Future<void> cancelByTarget(String targetId) async {}

  @override
  Future<void> schedulePlan(List<ReminderPlanEntry> entries) async {}
}
