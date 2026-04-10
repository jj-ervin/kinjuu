import '../enums/obligation_status.dart';
import '../enums/recurrence_rule_style.dart';
import '../enums/source_type.dart';

class Subscription {
  Subscription({
    required this.id,
    required this.title,
    required this.providerName,
    required this.sourceType,
    required this.billingCycle,
    required this.expectedAmount,
    required this.renewalDate,
    required this.linkedAccountId,
    required this.linkedCardId,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String providerName;
  final SourceType sourceType;
  final RecurrenceRuleStyle billingCycle;
  final double? expectedAmount;
  final DateTime renewalDate;
  final String? linkedAccountId;
  final String? linkedCardId;
  final ObligationStatus status;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}

