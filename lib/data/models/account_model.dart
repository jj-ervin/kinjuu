import '../../domain/entities/account.dart';
import '../../domain/enums/account_type.dart';
import 'model_utils.dart';

class AccountModel extends Account {
  AccountModel({
    required super.id,
    required super.name,
    required super.institutionName,
    required super.accountType,
    required super.maskedReference,
    required super.notes,
    required super.isArchived,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AccountModel.fromEntity(Account account) {
    return AccountModel(
      id: account.id,
      name: account.name,
      institutionName: account.institutionName,
      accountType: account.accountType,
      maskedReference: account.maskedReference,
      notes: account.notes,
      isArchived: account.isArchived,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    );
  }

  factory AccountModel.fromMap(Map<String, Object?> map) {
    return AccountModel(
      id: ModelUtils.readString(map, 'id'),
      name: ModelUtils.readString(map, 'name'),
      institutionName: ModelUtils.readString(map, 'institution_name'),
      accountType: AccountType.fromStorage(
        ModelUtils.readString(map, 'account_type'),
      ),
      maskedReference: ModelUtils.readString(map, 'masked_reference'),
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
      'institution_name': institutionName,
      'account_type': accountType.storageValue,
      'masked_reference': maskedReference,
      'notes': notes,
      'is_archived': ModelUtils.boolToSql(isArchived),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
