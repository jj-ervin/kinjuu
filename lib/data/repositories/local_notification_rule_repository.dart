import '../../domain/entities/notification_rule.dart';
import '../../domain/repositories/notification_rule_repository.dart';
import 'local_repository_base.dart';

class LocalNotificationRuleRepository extends LocalRepositoryBase
    implements NotificationRuleRepository {
  LocalNotificationRuleRepository(super.database);

  @override
  Future<void> delete(String id) async {
    LocalRepositoryBase.store.notificationRules.remove(id);
  }

  @override
  Future<List<NotificationRule>> getAll() async {
    final items =
        LocalRepositoryBase.store.notificationRules.values.toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<List<NotificationRule>> getByTargetId(String targetId) async {
    final items = LocalRepositoryBase.store.notificationRules.values
        .where((entry) => entry.targetId == targetId)
        .toList(growable: false);
    items.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return items;
  }

  @override
  Future<void> save(NotificationRule rule) async {
    LocalRepositoryBase.store.notificationRules[rule.id] = rule;
  }
}
