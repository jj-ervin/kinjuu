enum AuditActionType {
  created('created'),
  updated('updated'),
  archived('archived'),
  statusChanged('status_changed'),
  deleted('deleted'),
  viewed('viewed'),
  other('other');

  const AuditActionType(this.storageValue);

  final String storageValue;

  static AuditActionType fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => AuditActionType.other,
    );
  }
}
