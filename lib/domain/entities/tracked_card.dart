import '../enums/card_type.dart';

class TrackedCard {
  TrackedCard({
    required this.id,
    required this.name,
    required this.issuer,
    required this.cardType,
    required this.maskedReference,
    required this.statementDay,
    required this.dueDay,
    required this.notes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String issuer;
  final CardType cardType;
  final String maskedReference;
  final int? statementDay;
  final int? dueDay;
  final String notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
}

