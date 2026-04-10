import '../entities/account.dart';

abstract class AccountRepository {
  Future<List<Account>> getAll();
  Future<Account?> getById(String id);
  Future<void> save(Account account);
  Future<void> archive(String id);
}

