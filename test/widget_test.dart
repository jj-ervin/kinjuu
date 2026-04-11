import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kinjuu/app/app.dart';
import 'package:kinjuu/app/state/kinjuu_app_controller.dart';
import 'package:kinjuu/core/constants/app_strings.dart';
import 'package:kinjuu/domain/entities/notification_rule.dart';
import 'package:kinjuu/domain/entities/obligation.dart';
import 'package:kinjuu/domain/entities/reminder_plan_entry.dart';
import 'package:kinjuu/domain/services/notification_service.dart';
import 'package:kinjuu/services/notifications/local_notification_service.dart';

void main() {
  testWidgets('Kinjuu app boots to dashboard scaffold', (tester) async {
    final controller = KinjuuAppController.inMemory(
      notificationService: _BootTestNotificationService(),
    );
    await controller.load();

    await tester.pumpWidget(KinjuuApp(controller: controller));
    await tester.pump();

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text(AppStrings.appTagline), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

class _BootTestNotificationService implements NotificationService {
  _BootTestNotificationService() : _planner = LocalNotificationService();

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
