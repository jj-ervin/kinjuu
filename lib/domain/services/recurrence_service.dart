import '../enums/recurrence_rule_style.dart';

abstract class RecurrenceService {
  DateTime? nextOccurrence({
    required RecurrenceRuleStyle recurrenceRule,
    required DateTime anchorDate,
    DateTime? after,
  });

  List<DateTime> upcomingOccurrences({
    required RecurrenceRuleStyle recurrenceRule,
    required DateTime anchorDate,
    required int count,
    DateTime? after,
  });
}

