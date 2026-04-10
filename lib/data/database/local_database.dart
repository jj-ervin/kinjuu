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
    // TODO(pass-0003): Connect this scaffold to a concrete SQLite package.
  }

  Future<void> close() async {
    // TODO(pass-0003): Close the concrete SQLite connection when implemented.
  }

  Future<void> execute(String sql, [List<Object?> parameters = const []]) async {
    throw UnimplementedError(
      'SQLite execution is intentionally deferred after PASS 0003 schema scaffolding.',
    );
  }

  Future<List<DbRow>> query(
    String sql, [
    List<Object?> parameters = const [],
  ]) async {
    throw UnimplementedError(
      'SQLite querying is intentionally deferred after PASS 0003 schema scaffolding.',
    );
  }

  Future<void> insert(String table, Map<String, Object?> values) async {
    throw UnimplementedError(
      'Insert operations are intentionally deferred after PASS 0003.',
    );
  }

  Future<void> update(
    String table,
    Map<String, Object?> values, {
    required String whereClause,
    List<Object?> whereArgs = const [],
  }) async {
    throw UnimplementedError(
      'Update operations are intentionally deferred after PASS 0003.',
    );
  }

  Future<void> delete(
    String table, {
    required String whereClause,
    List<Object?> whereArgs = const [],
  }) async {
    throw UnimplementedError(
      'Delete operations are intentionally deferred after PASS 0003.',
    );
  }
}

