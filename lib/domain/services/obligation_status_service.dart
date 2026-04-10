import '../entities/obligation.dart';
import '../enums/obligation_status.dart';

abstract class ObligationStatusService {
  ObligationStatus deriveStatus(Obligation obligation, {DateTime? now});
  List<Obligation> sortForUpcoming(List<Obligation> obligations, {DateTime? now});
}

