import '../database/local_database.dart';
import '../database/in_memory_local_store.dart';

abstract class LocalRepositoryBase {
  const LocalRepositoryBase(this.database);

  final LocalDatabase database;

  static final InMemoryLocalStore store = InMemoryLocalStore();
}
