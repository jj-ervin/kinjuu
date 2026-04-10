enum NotificationTargetType {
  obligation('obligation'),
  subscription('subscription'),
  globalDefault('global_default');

  const NotificationTargetType(this.storageValue);

  final String storageValue;

  static NotificationTargetType fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => NotificationTargetType.obligation,
    );
  }
}

