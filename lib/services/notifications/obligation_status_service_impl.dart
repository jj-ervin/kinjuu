import '../../domain/entities/obligation.dart';
import '../../domain/enums/obligation_status.dart';
import '../../domain/services/obligation_status_service.dart';

class ObligationStatusServiceImpl implements ObligationStatusService {
  @override
  ObligationStatus deriveStatus(Obligation obligation, {DateTime? now}) {
    final referenceTime = now ?? DateTime.now();
    final dueDate = DateTime(
      obligation.dueDate.year,
      obligation.dueDate.month,
      obligation.dueDate.day,
    );
    final today = DateTime(
      referenceTime.year,
      referenceTime.month,
      referenceTime.day,
    );

    if (obligation.status == ObligationStatus.archived) {
      return ObligationStatus.archived;
    }
    if (obligation.status == ObligationStatus.paid) {
      return ObligationStatus.paid;
    }
    if (obligation.status == ObligationStatus.pending) {
      return ObligationStatus.pending;
    }
    if (dueDate.isAtSameMomentAs(today)) {
      return ObligationStatus.dueToday;
    }
    if (dueDate.isBefore(today)) {
      return ObligationStatus.overdue;
    }

    return ObligationStatus.upcoming;
  }

  @override
  List<Obligation> sortForUpcoming(List<Obligation> obligations, {DateTime? now}) {
    final derived = [
      for (final obligation in obligations)
        (
          obligation: obligation,
          status: deriveStatus(obligation, now: now),
        ),
    ];

    const sortOrder = {
      ObligationStatus.dueToday: 0,
      ObligationStatus.overdue: 1,
      ObligationStatus.upcoming: 2,
      ObligationStatus.pending: 3,
      ObligationStatus.paid: 4,
      ObligationStatus.archived: 5,
    };

    derived.sort((left, right) {
      final byStatus =
          sortOrder[left.status]!.compareTo(sortOrder[right.status]!);
      if (byStatus != 0) {
        return byStatus;
      }

      return left.obligation.dueDate.compareTo(right.obligation.dueDate);
    });

    return derived.map((entry) => entry.obligation).toList(growable: false);
  }
}

