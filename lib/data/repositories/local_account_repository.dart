import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../database/local_database.dart';
import 'local_repository_base.dart';

class LocalAccountRepository extends LocalRepositoryBase
    implements AccountRepository {
  LocalAccountRepository(LocalDatabase database) : super(database);

  @override
  Future<void> archive(String id) async {
    // TODO(pass-0003): Implement archive persistence once concrete SQLite access is wired.
    throw UnimplementedError();
  }

  @override
  Future<List<Account>> getAll() async {
    // TODO(pass-0003): Query local SQLite-backed accounts.
    throw UnimplementedError();
  }

  @override
  Future<Account?> getById(String id) async {
    // TODO(pass-0003): Query a single account by id.
    throw UnimplementedError();
  }

  @override
  Future<void> save(Account account) async {
    // TODO(pass-0003): Insert or update a local account.
    throw UnimplementedError();
  }
}

