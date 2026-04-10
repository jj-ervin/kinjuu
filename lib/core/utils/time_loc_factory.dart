import '../../domain/entities/time_loc_record.dart';

abstract final class TimeLocFactory {
  static TimeLocRecord create({
    required String sequence,
    DateTime? now,
  }) {
    final localTime = now ?? DateTime.now();
    final utcTime = localTime.toUtc();

    return TimeLocRecord(
      version: '1',
      stampLocal: localTime.toIso8601String(),
      stampLocalDay: localTime.toIso8601String().split('T').first,
      stampUtc: utcTime.toIso8601String(),
      stampUtcDay: utcTime.toIso8601String().split('T').first,
      geoCity: null,
      geoRegion: null,
      geoCountry: 'USA',
      geoSource: 'device_time_only',
      sequence: sequence,
      signature: null,
      geoLatitude: null,
      geoLongitude: null,
      geoAltitude: null,
    );
  }
}

