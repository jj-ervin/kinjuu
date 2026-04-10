enum ObligationStatus {
  upcoming('upcoming'),
  dueToday('due_today'),
  pending('pending'),
  paid('paid'),
  overdue('overdue'),
  archived('archived');

  const ObligationStatus(this.storageValue);

  final String storageValue;

  static ObligationStatus fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => ObligationStatus.upcoming,
    );
  }
}

