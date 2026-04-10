enum AuditEntityType {
  account('account'),
  card('card'),
  obligation('obligation'),
  subscription('subscription'),
  notificationRule('notification_rule'),
  paymentEvent('payment_event'),
  settings('settings');

  const AuditEntityType(this.storageValue);

  final String storageValue;

  static AuditEntityType fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => AuditEntityType.obligation,
    );
  }
}

