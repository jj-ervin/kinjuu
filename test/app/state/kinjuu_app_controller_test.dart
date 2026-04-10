import 'package:flutter_test/flutter_test.dart';
import 'package:kinjuu/app/state/kinjuu_app_controller.dart';
import 'package:kinjuu/data/database/local_database.dart';
import 'package:kinjuu/data/repositories/local_payment_event_repository.dart';
import 'package:kinjuu/data/repositories/local_repository_base.dart';
import 'package:kinjuu/domain/enums/account_type.dart';
import 'package:kinjuu/domain/enums/card_type.dart';
import 'package:kinjuu/domain/enums/obligation_status.dart';
import 'package:kinjuu/domain/enums/obligation_type.dart';
import 'package:kinjuu/domain/enums/recurrence_rule_style.dart';

void main() {
  group('KinjuuAppController', () {
    late KinjuuAppController controller;
    late LocalDatabase database;

    setUp(() async {
      database = LocalDatabase(databaseName: 'kinjuu_test.db');
      await database.reset();
      LocalRepositoryBase.store.clear();
      controller = KinjuuAppController(database: database);
      await controller.load();
    });

    test('supports account and card CRUD plus obligation status flow', () async {
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
        dueDate: DateTime.now().add(const Duration(days: 2)),
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

      await controller.markObligationPending(created.id);
      expect(controller.obligations.first.status, ObligationStatus.pending);

      await controller.markObligationPaid(created.id);
      expect(controller.obligations.first.status, ObligationStatus.paid);

      await controller.archiveObligation(created.id);
      expect(controller.obligations, isEmpty);
      expect(controller.auditEntries.length, greaterThanOrEqualTo(5));
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
        dueDate: DateTime.now().add(const Duration(days: 1)),
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

      final reloadedController = KinjuuAppController(database: database);
      await reloadedController.load();

      expect(reloadedController.accounts, hasLength(1));
      expect(reloadedController.cards, hasLength(1));
      expect(reloadedController.obligations, hasLength(1));
      expect(
        reloadedController.obligations.first.status,
        ObligationStatus.pending,
      );
      expect(reloadedController.auditEntries, hasLength(greaterThanOrEqualTo(4)));

      final afterReloadEvents = await paymentEventRepository.getByObligationId(
        obligationId,
      );
      expect(afterReloadEvents, hasLength(1));
    });
  });
}
