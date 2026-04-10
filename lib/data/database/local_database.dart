import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database_schema.dart';

typedef DbRow = Map<String, Object?>;

class LocalDatabase {
  LocalDatabase({this.databaseName = 'kinjuu_core.db', this.databasePath});

  final String databaseName;
  final String? databasePath;

  static bool _ffiInitialized = false;
  static final Map<String, Future<sqflite.Database>> _openHandles =
      <String, Future<sqflite.Database>>{};

  int get schemaVersion => AppDatabaseSchema.version;

  List<String> get bootstrapStatements => [
        'PRAGMA foreign_keys = ON',
        ...AppDatabaseSchema.createTableStatements,
        ...AppDatabaseSchema.createIndexStatements,
      ];

  Future<void> open() async {
    await _database;
  }

  Future<void> close() async {
    final resolvedPath = await resolvePath();
    final existing = _openHandles.remove(resolvedPath);
    if (existing == null) {
      return;
    }

    final database = await existing;
    await database.close();
  }

  Future<void> execute(String sql, [List<Object?> parameters = const []]) async {
    final db = await _database;
    await db.execute(sql, parameters);
  }

  Future<List<DbRow>> query(
    String sql, [
    List<Object?> parameters = const [],
  ]) async {
    final db = await _database;
    final rows = await db.rawQuery(sql, parameters);
    return rows
        .map((row) => Map<String, Object?>.from(row))
        .toList(growable: false);
  }

  Future<void> insert(String table, Map<String, Object?> values) async {
    final db = await _database;
    await db.insert(
      table,
      values,
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
  }

  Future<void> update(
    String table,
    Map<String, Object?> values, {
    required String whereClause,
    List<Object?> whereArgs = const [],
  }) async {
    final db = await _database;
    await db.update(
      table,
      values,
      where: whereClause,
      whereArgs: whereArgs,
    );
  }

  Future<void> delete(
    String table, {
    required String whereClause,
    List<Object?> whereArgs = const [],
  }) async {
    final db = await _database;
    await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  Future<void> reset() async {
    final resolvedPath = await resolvePath();
    await close();
    final factory = _databaseFactory;
    await factory.deleteDatabase(resolvedPath);
  }

  Future<String> resolvePath() async {
    if (databasePath != null) {
      return databasePath!;
    }

    final databasesPath = await _databaseFactory.getDatabasesPath();
    return path.join(databasesPath, databaseName);
  }

  sqflite.DatabaseFactory get _databaseFactory {
    if (!kIsWeb && _usesFfiFactory) {
      if (!_ffiInitialized) {
        sqfliteFfiInit();
        _ffiInitialized = true;
      }
      return databaseFactoryFfi;
    }

    return sqflite.databaseFactory;
  }

  bool get _usesFfiFactory =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  Future<sqflite.Database> get _database async {
    final resolvedPath = await resolvePath();
    return _openHandles.putIfAbsent(
      resolvedPath,
      () => _databaseFactory.openDatabase(
        resolvedPath,
        options: sqflite.OpenDatabaseOptions(
          version: schemaVersion,
          onConfigure: (db) async {
            await db.execute('PRAGMA foreign_keys = ON');
          },
          onCreate: (db, _) async {
            for (final statement in AppDatabaseSchema.createTableStatements) {
              await db.execute(statement);
            }
            for (final statement in AppDatabaseSchema.createIndexStatements) {
              await db.execute(statement);
            }
          },
        ),
      ),
    );
  }
}
