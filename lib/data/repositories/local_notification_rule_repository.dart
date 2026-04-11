import '../../domain/entities/notification_rule.dart';
import '../../domain/repositories/notification_rule_repository.dart';
import '../models/notification_rule_model.dart';
import 'local_repository_base.dart';

class LocalNotificationRuleRepository extends LocalRepositoryBase
    implements NotificationRuleRepository {
  LocalNotificationRuleRepository(super.database);

  @override
  Future<void> delete(String id) async {
    await database.delete(
      'notification_rules',
      whereClause: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  @override
  Future<List<NotificationRule>> getAll() async {
    final rows = await database.query(
      'SELECT * FROM notification_rules ORDER BY updated_at DESC',
    );
    final items = rows
        .map(NotificationRuleModel.fromMap)
        .toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<List<NotificationRule>> getByTargetId(String targetId) async {
    final rows = await database.query(
      'SELECT * FROM notification_rules WHERE target_id = ? ORDER BY updated_at DESC',
      <Object?>[targetId],
    );
    final items = rows
        .map(NotificationRuleModel.fromMap)
        .toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<void> save(NotificationRule rule) async {
    await database.insert(
      'notification_rules',
      NotificationRuleModel.fromEntity(rule).toMap(),
    );
  }
}
