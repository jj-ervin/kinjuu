enum AccountType {
  checking('checking'),
  savings('savings'),
  credit('credit'),
  cash('cash'),
  loan('loan'),
  other('other');

  const AccountType(this.storageValue);

  final String storageValue;

  static AccountType fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => AccountType.other,
    );
  }
}

