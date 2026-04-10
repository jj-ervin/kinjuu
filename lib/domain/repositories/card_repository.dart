import '../entities/tracked_card.dart';

abstract class CardRepository {
  Future<List<TrackedCard>> getAll();
  Future<TrackedCard?> getById(String id);
  Future<void> save(TrackedCard card);
  Future<void> archive(String id);
}

