class QuietHoursWindow {
  const QuietHoursWindow({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
  });

  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  String get startAsText =>
      '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}';

  String get endAsText =>
      '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

  bool contains(DateTime dateTime) {
    final minutes = (dateTime.hour * 60) + dateTime.minute;
    final start = (startHour * 60) + startMinute;
    final end = (endHour * 60) + endMinute;

    if (start == end) {
      return false;
    }

    if (start < end) {
      return minutes >= start && minutes < end;
    }

    return minutes >= start || minutes < end;
  }
}

