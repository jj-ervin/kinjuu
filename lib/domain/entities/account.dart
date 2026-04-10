import '../enums/account_type.dart';

class Account {
  Account({
    required this.id,
    required this.name,
    required this.institutionName,
    required this.accountType,
    required this.maskedReference,
    required this.notes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String institutionName;
  final AccountType accountType;
  final String maskedReference;
  final String notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
}

