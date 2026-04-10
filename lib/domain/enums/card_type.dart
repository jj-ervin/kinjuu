enum CardType {
  credit('credit'),
  debit('debit'),
  charge('charge'),
  prepaid('prepaid'),
  other('other');

  const CardType(this.storageValue);

  final String storageValue;

  static CardType fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => CardType.other,
    );
  }
}

