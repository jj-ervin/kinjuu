enum ReminderEventType {
  daysBefore('days_before'),
  dueDate('due_date'),
  overdue('overdue');

  const ReminderEventType(this.storageValue);

  final String storageValue;
}

