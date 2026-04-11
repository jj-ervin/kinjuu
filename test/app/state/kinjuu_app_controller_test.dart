import 'package:flutter_test/flutter_test.dart';
import 'package:kinjuu/app/state/kinjuu_app_controller.dart';
import 'package:kinjuu/data/database/local_database.dart';
import 'package:kinjuu/data/repositories/local_notification_rule_repository.dart';
import 'package:kinjuu/data/repositories/local_payment_event_repository.dart';
import 'package:kinjuu/data/repositories/local_repository_base.dart';
import 'package:kinjuu/domain/entities/notification_rule.dart';
import 'package:kinjuu/domain/entities/obligation.dart';
import 'package:kinjuu/domain/entities/reminder_plan_entry.dart';
import 'package:kinjuu/domain/enums/account_type.dart';
import 'package:kinjuu/domain/enums/card_type.dart';
import 'package:kinjuu/domain/enums/notification_target_type.dart';
import 'package:kinjuu/domain/enums/obligation_status.dart';
import 'package:kinjuu/domain/enums/obligation_type.dart';
import 'package:kinjuu/domain/enums/recurrence_rule_style.dart';
import 'package:kinjuu/domain/services/notification_service.dart';
import 'package:kinjuu/services/notifications/local_notification_service.dart';

void main() {
  group('KinjuuAppController', () {
    late KinjuuAppController controller;
    late LocalDatabase database;
    late LocalNotificationRuleRepository notificationRuleRepository;
    late FakeNotificationService notificationService;

    setUp(() async {
      database = LocalDatabase(databaseName: 'kinjuu_test.db');
      await database.reset();
      LocalRepositoryBase.store.clear();
      notificationRuleRepository = LocalNotificationRuleRepository(database);
      notificationService = FakeNotificationService();
      controller = KinjuuAppController(
        database: database,
        notificationRuleRepository: notificationRuleRepository,
        notificationService: notificationService,
      );
      await controller.load();
    });

    test('schedules, reschedules, and cancels obligation reminders', () async {
      await controller.saveAccount(
        name: 'Checking',
        institutionName: 'Credit Union',
        accountType: AccountType.checking,
        maskedReference: '...1234',
        notes: 'Primary',
      );
      await controller.saveCard(
        name: 'Visa',
        issuer: 'Example Bank',
        cardType: CardType.credit,
        maskedReference: '...4242',
        statementDay: 12,
        dueDay: 25,
        notes: 'Rewards',
      );

      expect(controller.accounts, hasLength(1));
      expect(controller.cards, hasLength(1));

      await controller.saveObligation(
        title: 'Internet bill',
        obligationType: ObligationType.bill,
        dueDate: DateTime.now().add(const Duration(days: 10)),
        recurrenceRule: RecurrenceRuleStyle.monthly,
        expectedAmount: 80,
        minimumAmount: null,
        currencyCode: 'USD',
        autopayExpected: false,
        category: 'Utilities',
        notes: 'Manual reminder',
        linkedAccountId: controller.accounts.first.id,
        linkedCardId: controller.cards.first.id,
      );

      expect(controller.obligations, hasLength(1));
      final created = controller.obligations.first;
      final globalRules = await notificationRuleRepository.getAll();
      expect(
        globalRules.where((entry) =>
            entry.targetType == NotificationTargetType.globalDefault),
        hasLength(5),
      );
      expect(notificationService.canceledTargets, contains(created.id));
      expect(notificationService.scheduledEntries, hasLength(5));

      await controller.saveObligation(
        existingId: created.id,
        title: 'Internet bill updated',
        obligationType: created.obligationType,
        dueDate: created.dueDate,
        recurrenceRule: created.recurrenceRule,
        expectedAmount: 90,
        minimumAmount: null,
        currencyCode: created.currencyCode,
        autopayExpected: true,
        category: created.category,
        notes: 'Updated',
        linkedAccountId: created.linkedAccountId,
        linkedCardId: created.linkedCardId,
      );

      expect(controller.obligations.first.title, 'Internet bill updated');
      expect(
        notificationService.canceledTargets
            .where((entry) => entry == created.id),
        hasLength(2),
      );
      expect(notificationService.scheduledEntries, hasLength(10));

      await controller.markObligationPending(created.id);
      expect(controller.obligations.first.status, ObligationStatus.pending);
      expect(notificationService.scheduledEntries, hasLength(15));

      await controller.markObligationPaid(created.id);
      expect(controller.obligations.first.status, ObligationStatus.paid);
      expect(notificationService.scheduledEntries, hasLength(15));
      expect(
        notificationService.canceledTargets
            .where((entry) => entry == created.id),
        hasLength(4),
      );

      await controller.archiveObligation(created.id);
      expect(controller.obligations, isEmpty);
      expect(controller.auditEntries.length, greaterThanOrEqualTo(5));
      expect(notificationService.scheduledEntries, hasLength(15));
      expect(
        notificationService.canceledTargets
            .where((entry) => entry == created.id),
        hasLength(5),
      );
    });

    test('rejects obviously invalid card and obligation saves', () async {
      expect(
        () => controller.saveCard(
          name: 'Visa',
          issuer: 'Example Bank',
          cardType: CardType.credit,
          maskedReference: '4111111111111111',
          statementDay: 50,
          dueDay: 2,
          notes: '',
        ),
        throwsArgumentError,
      );

      expect(
        () => controller.saveObligation(
          title: 'Bad obligation',
          obligationType: ObligationType.bill,
          dueDate: DateTime.now(),
          recurrenceRule: RecurrenceRuleStyle.monthly,
          expectedAmount: 10,
          minimumAmount: 20,
          currencyCode: 'US',
          autopayExpected: false,
          category: '',
          notes: '',
        ),
        throwsArgumentError,
      );
    });

    test(
        'does not schedule reminders when every reminder time is already invalid',
        () async {
      await controller.saveObligation(
        title: 'Old bill',
        obligationType: ObligationType.bill,
        dueDate: DateTime.now().subtract(const Duration(days: 10)),
        recurrenceRule: RecurrenceRuleStyle.monthly,
        expectedAmount: 42,
        minimumAmount: null,
        currencyCode: 'USD',
        autopayExpected: false,
        category: 'Utilities',
        notes: 'Already stale',
      );

      expect(controller.obligations, hasLength(1));
      expect(notificationService.scheduledEntries, isEmpty);
      expect(notificationService.canceledTargets,
          contains(controller.obligations.first.id));
    });

    test('persists updated global notification defaults across reload',
        () async {
      await controller.saveObligation(
        title: 'Phone bill',
        obligationType: ObligationType.bill,
        dueDate: DateTime.now().add(const Duration(days: 10)),
        recurrenceRule: RecurrenceRuleStyle.monthly,
        expectedAmount: 55,
        minimumAmount: null,
        currencyCode: 'USD',
        autopayExpected: false,
        category: 'Utilities',
        notes: '',
      );

      await controller.saveGlobalNotificationDefaults(
        daysBefore: const [3],
        triggerOnDueDate: true,
        triggerIfOverdue: false,
        overdueIntervalDays: 1,
        quietHoursStart: '21:00',
        quietHoursEnd: '06:30',
      );

      expect(controller.globalNotificationRules, hasLength(2));
      expect(
        controller.globalNotificationRules
            .any((entry) => entry.daysBefore == 3),
        isTrue,
      );
      expect(
        controller.globalNotificationRules
            .any((entry) => entry.triggerIfOverdue),
        isFalse,
      );

      final reloadedNotificationService = FakeNotificationService();
      final reloadedController = KinjuuAppController(
        database: database,
        notificationRuleRepository: LocalNotificationRuleRepository(database),
        notificationService: reloadedNotificationService,
      );
      await reloadedController.load();

      expect(reloadedController.globalNotificationRules, hasLength(2));
      expect(
        reloadedController.globalNotificationRules.first.quietHoursStart,
        '21:00',
      );
      expect(
        reloadedController.globalNotificationRules.first.quietHoursEnd,
        '06:30',
      );
      expect(reloadedNotificationService.scheduledEntries, hasLength(2));
    });

    test('persists core data across a fresh controller load', () async {
      await controller.saveAccount(
        name: 'Checking',
        institutionName: 'Credit Union',
        accountType: AccountType.checking,
        maskedReference: '...1234',
        notes: 'Primary',
      );
      await controller.saveCard(
        name: 'Visa',
        issuer: 'Example Bank',
        cardType: CardType.credit,
        maskedReference: '...4242',
        statementDay: 12,
        dueDay: 25,
        notes: 'Rewards',
      );
      await controller.saveObligation(
        title: 'Internet bill',
        obligationType: ObligationType.bill,
        dueDate: DateTime.now().add(const Duration(days: 10)),
        recurrenceRule: RecurrenceRuleStyle.monthly,
        expectedAmount: 80,
        minimumAmount: null,
        currencyCode: 'USD',
        autopayExpected: false,
        category: 'Utilities',
        notes: 'Manual reminder',
        linkedAccountId: controller.accounts.first.id,
        linkedCardId: controller.cards.first.id,
      );

      final obligationId = controller.obligations.first.id;
      await controller.markObligationPending(obligationId);

      final paymentEventRepository = LocalPaymentEventRepository(database);
      final beforeReloadEvents = await paymentEventRepository.getByObligationId(
        obligationId,
      );
      expect(beforeReloadEvents, hasLength(1));

      final reloadedNotificationService = FakeNotificationService();
      final reloadedController = KinjuuAppController(
        database: database,
        notificationRuleRepository: LocalNotificationRuleRepository(database),
        notificationService: reloadedNotificationService,
      );
      await reloadedController.load();

      expect(reloadedController.accounts, hasLength(1));
      expect(reloadedController.cards, hasLength(1));
      expect(reloadedController.obligations, hasLength(1));
      expect(
        reloadedController.obligations.first.status,
        ObligationStatus.pending,
      );
      expect(
          reloadedController.auditEntries, hasLength(greaterThanOrEqualTo(4)));

      final afterReloadEvents = await paymentEventRepository.getByObligationId(
        obligationId,
      );
      expect(afterReloadEvents, hasLength(1));
      expect(
          reloadedNotificationService.canceledTargets, contains(obligationId));
      expect(reloadedNotificationService.scheduledEntries, hasLength(5));
    });
  });
}

class FakeNotificationService implements NotificationService {
  FakeNotificationService() : _planner = LocalNotificationService();

  final LocalNotificationService _planner;
  final List<String> canceledTargets = <String>[];
  final List<ReminderPlanEntry> scheduledEntries = <ReminderPlanEntry>[];

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
  Future<void> cancelByTarget(String targetId) async {
    canceledTargets.add(targetId);
  }

  @override
  Future<void> schedulePlan(List<ReminderPlanEntry> entries) async {
    scheduledEntries.addAll(entries);
  }
}
