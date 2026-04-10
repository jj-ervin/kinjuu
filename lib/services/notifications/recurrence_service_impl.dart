import '../../domain/enums/recurrence_rule_style.dart';
import '../../domain/services/recurrence_service.dart';

class RecurrenceServiceImpl implements RecurrenceService {
  @override
  DateTime? nextOccurrence({
    required RecurrenceRuleStyle recurrenceRule,
    required DateTime anchorDate,
    DateTime? after,
  }) {
    final reference = after ?? DateTime.now();
    var candidate = anchorDate;

    if (recurrenceRule == RecurrenceRuleStyle.oneTime) {
      return candidate.isAfter(reference) ? candidate : null;
    }

    while (!candidate.isAfter(reference)) {
      final next = _step(candidate, recurrenceRule);
      if (next == null || next.isAtSameMomentAs(candidate)) {
        return null;
      }
      candidate = next;
    }

    return candidate;
  }

  @override
  List<DateTime> upcomingOccurrences({
    required RecurrenceRuleStyle recurrenceRule,
    required DateTime anchorDate,
    required int count,
    DateTime? after,
  }) {
    if (count <= 0) {
      return const [];
    }

    final occurrences = <DateTime>[];
    var cursor = after ?? DateTime.now();

    while (occurrences.length < count) {
      final next = nextOccurrence(
        recurrenceRule: recurrenceRule,
        anchorDate: anchorDate,
        after: cursor,
      );
      if (next == null) {
        break;
      }
      occurrences.add(next);
      cursor = next;
    }

    return occurrences;
  }

  DateTime? _step(DateTime current, RecurrenceRuleStyle recurrenceRule) {
    switch (recurrenceRule) {
      case RecurrenceRuleStyle.oneTime:
        return null;
      case RecurrenceRuleStyle.weekly:
        return current.add(const Duration(days: 7));
      case RecurrenceRuleStyle.biweekly:
        return current.add(const Duration(days: 14));
      case RecurrenceRuleStyle.monthly:
        return _addMonths(current, 1);
      case RecurrenceRuleStyle.quarterly:
        return _addMonths(current, 3);
      case RecurrenceRuleStyle.yearly:
        return _addMonths(current, 12);
      case RecurrenceRuleStyle.custom:
        // TODO(pass-0004): Support persisted custom recurrence rules after schema expansion.
        return null;
    }
  }

  DateTime _addMonths(DateTime date, int monthsToAdd) {
    final totalMonths = (date.year * 12) + (date.month - 1) + monthsToAdd;
    final year = totalMonths ~/ 12;
    final month = (totalMonths % 12) + 1;
    final lastDayOfTargetMonth = DateTime(year, month + 1, 0).day;
    final day = date.day <= lastDayOfTargetMonth ? date.day : lastDayOfTargetMonth;

    return DateTime(
      year,
      month,
      day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }
}
