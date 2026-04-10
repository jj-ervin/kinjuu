import '../../domain/entities/tracked_card.dart';
import '../../domain/repositories/card_repository.dart';
import '../database/local_database.dart';
import 'local_repository_base.dart';

class LocalCardRepository extends LocalRepositoryBase implements CardRepository {
  LocalCardRepository(LocalDatabase database) : super(database);

  @override
  Future<void> archive(String id) async {
    // TODO(pass-0003): Implement archive persistence once concrete SQLite access is wired.
    throw UnimplementedError();
  }

  @override
  Future<List<TrackedCard>> getAll() async {
    // TODO(pass-0003): Query local SQLite-backed cards.
    throw UnimplementedError();
  }

  @override
  Future<TrackedCard?> getById(String id) async {
    // TODO(pass-0003): Query a single card by id.
    throw UnimplementedError();
  }

  @override
  Future<void> save(TrackedCard card) async {
    // TODO(pass-0003): Insert or update a local card.
    throw UnimplementedError();
  }
}

