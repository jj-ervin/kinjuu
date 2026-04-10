import '../entities/notification_rule.dart';

abstract class NotificationRuleRepository {
  Future<List<NotificationRule>> getAll();
  Future<List<NotificationRule>> getByTargetId(String targetId);
  Future<void> save(NotificationRule rule);
  Future<void> delete(String id);
}

