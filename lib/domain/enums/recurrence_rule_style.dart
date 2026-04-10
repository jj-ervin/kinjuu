enum RecurrenceRuleStyle {
  oneTime('one_time'),
  weekly('weekly'),
  biweekly('biweekly'),
  monthly('monthly'),
  quarterly('quarterly'),
  yearly('yearly'),
  custom('custom');

  const RecurrenceRuleStyle(this.storageValue);

  final String storageValue;

  static RecurrenceRuleStyle fromStorage(String value) {
    return values.firstWhere(
      (entry) => entry.storageValue == value,
      orElse: () => RecurrenceRuleStyle.oneTime,
    );
  }
}

