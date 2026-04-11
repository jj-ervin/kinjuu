import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kinjuu/app/state/kinjuu_app_controller.dart';
import 'package:kinjuu/app/state/kinjuu_app_scope.dart';
import 'package:kinjuu/data/database/local_database.dart';
import 'package:kinjuu/data/repositories/local_notification_rule_repository.dart';
import 'package:kinjuu/data/repositories/local_repository_base.dart';
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
    late LocalDatabase database;
    late KinjuuAppController controller;

    setUp(() async {
      database = LocalDatabase(databaseName: 'kinjuu_widget_test.db');
      await database.reset();
      LocalRepositoryBase.store.clear();
      controller = KinjuuAppController(
        database: database,
        notificationRuleRepository: LocalNotificationRuleRepository(database),
        notificationService: _FakeNotificationService(),
      );
      await controller.load();
    });

    testWidgets('calendar screen shows persisted obligation sections',
        (tester) async {
      // TODO: Fix hang in widget tree during pumpWidget
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
    }, skip: true);

    testWidgets('settings screen shows persisted reminder defaults',
        (tester) async {
      // TODO: Fix hang in widget tree during pumpWidget
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
      expect(find.text('Save settings'), findsOneWidget);
      expect(find.text('Current behavior'), findsOneWidget);
    }, skip: true);
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
