import '../../domain/entities/tracked_card.dart';
import '../../domain/enums/card_type.dart';
import 'model_utils.dart';

class TrackedCardModel extends TrackedCard {
  TrackedCardModel({
    required super.id,
    required super.name,
    required super.issuer,
    required super.cardType,
    required super.maskedReference,
    required super.statementDay,
    required super.dueDay,
    required super.notes,
    required super.isArchived,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TrackedCardModel.fromEntity(TrackedCard card) {
    return TrackedCardModel(
      id: card.id,
      name: card.name,
      issuer: card.issuer,
      cardType: card.cardType,
      maskedReference: card.maskedReference,
      statementDay: card.statementDay,
      dueDay: card.dueDay,
      notes: card.notes,
      isArchived: card.isArchived,
      createdAt: card.createdAt,
      updatedAt: card.updatedAt,
    );
  }

  factory TrackedCardModel.fromMap(Map<String, Object?> map) {
    return TrackedCardModel(
      id: ModelUtils.readString(map, 'id'),
      name: ModelUtils.readString(map, 'name'),
      issuer: ModelUtils.readString(map, 'issuer'),
      cardType: CardType.fromStorage(ModelUtils.readString(map, 'card_type')),
      maskedReference: ModelUtils.readString(map, 'masked_reference'),
      statementDay: ModelUtils.readNullableInt(map, 'statement_day'),
      dueDay: ModelUtils.readNullableInt(map, 'due_day'),
      notes: ModelUtils.readString(map, 'notes'),
      isArchived: ModelUtils.readBool(map, 'is_archived'),
      createdAt: ModelUtils.readDateTime(map, 'created_at'),
      updatedAt: ModelUtils.readDateTime(map, 'updated_at'),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'issuer': issuer,
      'card_type': cardType.storageValue,
      'masked_reference': maskedReference,
      'statement_day': statementDay,
      'due_day': dueDay,
      'notes': notes,
      'is_archived': ModelUtils.boolToSql(isArchived),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
