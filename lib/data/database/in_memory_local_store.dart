import '../../domain/entities/account.dart';
import '../../domain/entities/audit_entry.dart';
import '../../domain/entities/notification_rule.dart';
import '../../domain/entities/obligation.dart';
import '../../domain/entities/payment_event.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/tracked_card.dart';

class InMemoryLocalStore {
  final Map<String, Account> accounts = <String, Account>{};
  final Map<String, TrackedCard> cards = <String, TrackedCard>{};
  final Map<String, Obligation> obligations = <String, Obligation>{};
  final Map<String, Subscription> subscriptions = <String, Subscription>{};
  final Map<String, PaymentEvent> paymentEvents = <String, PaymentEvent>{};
  final Map<String, NotificationRule> notificationRules = <String, NotificationRule>{};
  final Map<String, AuditEntry> auditEntries = <String, AuditEntry>{};

  void clear() {
    accounts.clear();
    cards.clear();
    obligations.clear();
    subscriptions.clear();
    paymentEvents.clear();
    notificationRules.clear();
    auditEntries.clear();
  }
}
