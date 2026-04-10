import '../../domain/entities/notification_rule.dart';
import '../../domain/repositories/notification_rule_repository.dart';
import '../database/local_database.dart';
import 'local_repository_base.dart';

class LocalNotificationRuleRepository extends LocalRepositoryBase
    implements NotificationRuleRepository {
  LocalNotificationRuleRepository(super.database);

  @override
  Future<void> delete(String id) async {
    // TODO(pass-0003): Delete a notification rule from local storage if needed.
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationRule>> getAll() async {
    // TODO(pass-0003): Query all notification rules from local storage.
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationRule>> getByTargetId(String targetId) async {
    // TODO(pass-0003): Query notification rules for a specific target.
    throw UnimplementedError();
  }

  @override
  Future<void> save(NotificationRule rule) async {
    // TODO(pass-0003): Insert or update a notification rule.
    throw UnimplementedError();
  }
}

