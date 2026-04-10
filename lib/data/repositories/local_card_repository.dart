import '../../domain/entities/tracked_card.dart';
import '../../domain/repositories/card_repository.dart';
import 'local_repository_base.dart';

class LocalCardRepository extends LocalRepositoryBase implements CardRepository {
  LocalCardRepository(super.database);

  @override
  Future<void> archive(String id) async {
    final existing = LocalRepositoryBase.store.cards[id];
    if (existing == null) {
      return;
    }

    LocalRepositoryBase.store.cards[id] = TrackedCard(
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
    );
  }

  @override
  Future<List<TrackedCard>> getAll() async {
    final items = LocalRepositoryBase.store.cards.values.toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<TrackedCard?> getById(String id) async {
    return LocalRepositoryBase.store.cards[id];
  }

  @override
  Future<void> save(TrackedCard card) async {
    LocalRepositoryBase.store.cards[card.id] = card;
  }
}
