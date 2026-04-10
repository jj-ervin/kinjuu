abstract final class ModelUtils {
  static String readString(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is String) {
      return value;
    }

    throw StateError('Expected String for "$key" but found $value');
  }

  static String? readNullableString(Map<String, Object?> map, String key) {
    final value = map[key];
    return value as String?;
  }

  static int readInt(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }

    throw StateError('Expected int for "$key" but found $value');
  }

  static int? readNullableInt(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }

    throw StateError('Expected nullable int for "$key" but found $value');
  }

  static double? readNullableDouble(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }

    throw StateError('Expected nullable double for "$key" but found $value');
  }

  static bool readBool(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is bool) {
      return value;
    }
    if (value is int) {
      return value != 0;
    }

    throw StateError('Expected bool/int for "$key" but found $value');
  }

  static DateTime readDateTime(Map<String, Object?> map, String key) {
    return DateTime.parse(readString(map, key));
  }

  static DateTime? readNullableDateTime(Map<String, Object?> map, String key) {
    final value = readNullableString(map, key);
    if (value == null) {
      return null;
    }

    return DateTime.parse(value);
  }

  static int boolToSql(bool value) => value ? 1 : 0;
}

