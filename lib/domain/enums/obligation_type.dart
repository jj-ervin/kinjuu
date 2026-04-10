enum ObligationType {
  bill('bill'),
  subscription('subscription'),
  cardPayment('card_payment'),
  loan('loan'),
  other('other');

  const ObligationType(this.storageValue);

  final String storageValue;

  static ObligationType fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => ObligationType.other,
    );
  }
}

