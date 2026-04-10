import '../database/local_database.dart';

abstract class LocalRepositoryBase {
  const LocalRepositoryBase(this.database);

  final LocalDatabase database;
}

