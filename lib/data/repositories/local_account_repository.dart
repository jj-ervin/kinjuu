import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import 'local_repository_base.dart';

class LocalAccountRepository extends LocalRepositoryBase
    implements AccountRepository {
  LocalAccountRepository(super.database);

  @override
  Future<void> archive(String id) async {
    final existing = LocalRepositoryBase.store.accounts[id];
    if (existing == null) {
      return;
    }

    LocalRepositoryBase.store.accounts[id] = Account(
      id: existing.id,
      name: existing.name,
      institutionName: existing.institutionName,
      accountType: existing.accountType,
      maskedReference: existing.maskedReference,
      notes: existing.notes,
      isArchived: true,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<Account>> getAll() async {
    final items = LocalRepositoryBase.store.accounts.values.toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<Account?> getById(String id) async {
    return LocalRepositoryBase.store.accounts[id];
  }

  @override
  Future<void> save(Account account) async {
    LocalRepositoryBase.store.accounts[account.id] = account;
  }
}
