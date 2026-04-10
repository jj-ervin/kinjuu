import '../../domain/entities/tracked_card.dart';
import '../../domain/repositories/card_repository.dart';
import '../models/tracked_card_model.dart';
import 'local_repository_base.dart';

class LocalCardRepository extends LocalRepositoryBase implements CardRepository {
  LocalCardRepository(super.database);

  @override
  Future<void> archive(String id) async {
    final existing = await getById(id);
    if (existing == null) {
      return;
    }

    await save(TrackedCard(
      id: existing.id,
      name: existing.name,
      issuer: existing.issuer,
      cardType: existing.cardType,
      maskedReference: existing.maskedReference,
      statementDay: existing.statementDay,
      dueDay: existing.dueDay,
      notes: existing.notes,
      isArchived: true,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    ));
  }

  @override
  Future<List<TrackedCard>> getAll() async {
    final rows = await database.query(
      'SELECT * FROM cards ORDER BY updated_at DESC',
    );
    final items =
        rows.map(TrackedCardModel.fromMap).toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<TrackedCard?> getById(String id) async {
    final rows = await database.query(
      'SELECT * FROM cards WHERE id = ? LIMIT 1',
      <Object?>[id],
    );
    if (rows.isEmpty) {
      return null;
    }
    return TrackedCardModel.fromMap(rows.first);
  }

  @override
  Future<void> save(TrackedCard card) async {
    await database.insert('cards', TrackedCardModel.fromEntity(card).toMap());
  }
}
