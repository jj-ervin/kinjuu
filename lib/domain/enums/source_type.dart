enum SourceType {
  manual('manual');

  const SourceType(this.storageValue);

  final String storageValue;

  static SourceType fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => SourceType.manual,
    );
  }
}

