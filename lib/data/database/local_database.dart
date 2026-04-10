import 'app_database_schema.dart';

typedef DbRow = Map<String, Object?>;

class LocalDatabase {
  int get schemaVersion => AppDatabaseSchema.version;

  List<String> get bootstrapStatements => [
        'PRAGMA foreign_keys = ON',
        ...AppDatabaseSchema.createTableStatements,
        ...AppDatabaseSchema.createIndexStatements,
      ];

  Future<void> open() async {
    // TODO(scaffold-debt): Replace this no-op with a concrete SQLite adapter
    // when persistence work resumes beyond the current in-memory MVP loop.
  }

  Future<void> close() async {
    // TODO(scaffold-debt): Close the concrete SQLite adapter once one is wired.
  }

  Future<void> execute(String sql, [List<Object?> parameters = const []]) async {
    throw UnimplementedError(
      'Scaffold debt: LocalDatabase.execute is intentionally not wired because the active MVP flow currently uses in-memory repositories.',
    );
  }

  Future<List<DbRow>> query(
    String sql, [
    List<Object?> parameters = const [],
  ]) async {
    throw UnimplementedError(
      'Scaffold debt: LocalDatabase.query is intentionally not wired because the active MVP flow currently uses in-memory repositories.',
    );
  }

  Future<void> insert(String table, Map<String, Object?> values) async {
    throw UnimplementedError(
      'Scaffold debt: LocalDatabase.insert is intentionally not wired because the active MVP flow currently uses in-memory repositories.',
    );
  }

  Future<void> update(
    String table,
    Map<String, Object?> values, {
    required String whereClause,
    List<Object?> whereArgs = const [],
  }) async {
    throw UnimplementedError(
      'Scaffold debt: LocalDatabase.update is intentionally not wired because the active MVP flow currently uses in-memory repositories.',
    );
  }

  Future<void> delete(
    String table, {
    required String whereClause,
    List<Object?> whereArgs = const [],
  }) async {
    throw UnimplementedError(
      'Scaffold debt: LocalDatabase.delete is intentionally not wired because the active MVP flow currently uses in-memory repositories.',
    );
  }
}
