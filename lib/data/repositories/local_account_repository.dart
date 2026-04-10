import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../models/account_model.dart';
import 'local_repository_base.dart';

class LocalAccountRepository extends LocalRepositoryBase
    implements AccountRepository {
  LocalAccountRepository(super.database);

  @override
  Future<void> archive(String id) async {
    final existing = await getById(id);
    if (existing == null) {
      return;
    }

    await save(Account(
      id: existing.id,
      name: existing.name,
      institutionName: existing.institutionName,
      accountType: existing.accountType,
      maskedReference: existing.maskedReference,
      notes: existing.notes,
      isArchived: true,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    ));
  }

  @override
  Future<List<Account>> getAll() async {
    final rows = await database.query(
      'SELECT * FROM accounts ORDER BY updated_at DESC',
    );
    final items =
        rows.map(AccountModel.fromMap).toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<Account?> getById(String id) async {
    final rows = await database.query(
      'SELECT * FROM accounts WHERE id = ? LIMIT 1',
      <Object?>[id],
    );
    if (rows.isEmpty) {
      return null;
    }
    return AccountModel.fromMap(rows.first);
  }

  @override
  Future<void> save(Account account) async {
    await database.insert('accounts', AccountModel.fromEntity(account).toMap());
  }
}
