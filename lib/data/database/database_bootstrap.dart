import 'local_database.dart';

class DatabaseBootstrap {
  DatabaseBootstrap(this.database);

  final LocalDatabase database;

  Future<void> initialize() async {
    await database.open();
  }
}
