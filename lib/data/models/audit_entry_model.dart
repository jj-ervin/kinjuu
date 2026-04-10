import '../../domain/entities/audit_entry.dart';
import '../../domain/enums/audit_action_type.dart';
import '../../domain/enums/audit_entity_type.dart';
import 'model_utils.dart';
import 'time_loc_record_model.dart';

class AuditEntryModel extends AuditEntry {
  AuditEntryModel({
    required super.id,
    required super.entityType,
    required super.entityId,
    required super.actionType,
    required super.summary,
    required super.createdAt,
    required super.timeLoc,
  });

  factory AuditEntryModel.fromMap(Map<String, Object?> map) {
    return AuditEntryModel(
      id: ModelUtils.readString(map, 'id'),
      entityType: AuditEntityType.fromStorage(
        ModelUtils.readString(map, 'entity_type'),
      ),
      entityId: ModelUtils.readString(map, 'entity_id'),
      actionType: AuditActionType.fromStorage(
        ModelUtils.readString(map, 'action_type'),
      ),
      summary: ModelUtils.readString(map, 'summary'),
      createdAt: ModelUtils.readDateTime(map, 'created_at'),
      timeLoc: ModelUtils.readNullableString(map, 'time_loc') == null
          ? null
          : TimeLocRecordModel.fromJsonString(
              ModelUtils.readString(map, 'time_loc'),
            ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'entity_type': entityType.storageValue,
      'entity_id': entityId,
      'action_type': actionType.storageValue,
      'summary': summary,
      'created_at': createdAt.toIso8601String(),
      'time_loc': timeLoc == null
          ? null
          : TimeLocRecordModel.fromEntity(timeLoc!).toJsonString(),
    };
  }
}
