import '../enums/obligation_status.dart';
import '../enums/obligation_type.dart';
import '../enums/recurrence_rule_style.dart';
import '../enums/source_type.dart';

class Obligation {
  Obligation({
    required this.id,
    required this.title,
    required this.obligationType,
    required this.sourceType,
    required this.linkedAccountId,
    required this.linkedCardId,
    required this.expectedAmount,
    required this.minimumAmount,
    required this.currencyCode,
    required this.dueDate,
    required this.statementDate,
    required this.recurrenceRule,
    required this.status,
    required this.autopayExpected,
    required this.category,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final ObligationType obligationType;
  final SourceType sourceType;
  final String? linkedAccountId;
  final String? linkedCardId;
  final double? expectedAmount;
  final double? minimumAmount;
  final String currencyCode;
  final DateTime dueDate;
  final DateTime? statementDate;
  final RecurrenceRuleStyle recurrenceRule;
  final ObligationStatus status;
  final bool autopayExpected;
  final String category;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}

