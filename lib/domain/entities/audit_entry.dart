import '../enums/audit_action_type.dart';
import '../enums/audit_entity_type.dart';
import 'time_loc_record.dart';

class AuditEntry {
  AuditEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.actionType,
    required this.summary,
    required this.createdAt,
    required this.timeLoc,
  });

  final String id;
  final AuditEntityType entityType;
  final String entityId;
  final AuditActionType actionType;
  final String summary;
  final DateTime createdAt;
  final TimeLocRecord? timeLoc;
}
