abstract final class DisplayFormatters {
  static String formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  static String formatDateTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${formatDate(date)} $hour:$minute';
  }

  static String titleCase(String raw) {
    if (raw.isEmpty) {
      return raw;
    }

    return raw
        .split('_')
        .where((entry) => entry.isNotEmpty)
        .map((entry) => '${entry[0].toUpperCase()}${entry.substring(1)}')
        .join(' ');
  }

  static String formatAmount(String currencyCode, double amount) {
    return '$currencyCode ${amount.toStringAsFixed(2)}';
  }

  static String formatTimeText(String value) {
    final parts = value.split(':');
    if (parts.length != 2) {
      return value;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return value;
    }

    final suffix = hour >= 12 ? 'PM' : 'AM';
    final normalizedHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$normalizedHour:${minute.toString().padLeft(2, '0')} $suffix';
  }
}
