enum PaymentEventType {
  markedPaid('marked_paid'),
  markedPending('marked_pending'),
  statusChanged('status_changed'),
  noteAdded('note_added'),
  other('other');

  const PaymentEventType(this.storageValue);

  final String storageValue;

  static PaymentEventType fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => PaymentEventType.other,
    );
  }
}

