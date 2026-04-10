import 'dart:convert';

import '../../domain/entities/time_loc_record.dart';

class TimeLocRecordModel extends TimeLocRecord {
  TimeLocRecordModel({
    required super.version,
    required super.stampLocal,
    required super.stampLocalDay,
    required super.stampUtc,
    required super.stampUtcDay,
    required super.geoCity,
    required super.geoRegion,
    required super.geoCountry,
    required super.geoSource,
    required super.sequence,
    required super.signature,
    required super.geoLatitude,
    required super.geoLongitude,
    required super.geoAltitude,
  });

  factory TimeLocRecordModel.fromMap(Map<String, Object?> map) {
    return TimeLocRecordModel(
      version: map['version'] as String,
      stampLocal: map['stamp.local'] as String,
      stampLocalDay: map['stamp.local.day'] as String,
      stampUtc: map['stamp.utc'] as String,
      stampUtcDay: map['stamp.utc.day'] as String,
      geoCity: map['geo.city'] as String?,
      geoRegion: map['geo.region'] as String?,
      geoCountry: map['geo.country'] as String?,
      geoSource: map['geo.source'] as String,
      sequence: map['seq'] as String?,
      signature: map['sig'] as String?,
      geoLatitude: (map['geo.lat'] as num?)?.toDouble(),
      geoLongitude: (map['geo.lon'] as num?)?.toDouble(),
      geoAltitude: (map['geo.alt'] as num?)?.toDouble(),
    );
  }

  factory TimeLocRecordModel.fromEntity(TimeLocRecord value) {
    return TimeLocRecordModel(
      version: value.version,
      stampLocal: value.stampLocal,
      stampLocalDay: value.stampLocalDay,
      stampUtc: value.stampUtc,
      stampUtcDay: value.stampUtcDay,
      geoCity: value.geoCity,
      geoRegion: value.geoRegion,
      geoCountry: value.geoCountry,
      geoSource: value.geoSource,
      sequence: value.sequence,
      signature: value.signature,
      geoLatitude: value.geoLatitude,
      geoLongitude: value.geoLongitude,
      geoAltitude: value.geoAltitude,
    );
  }

  factory TimeLocRecordModel.fromJsonString(String value) {
    final decoded = jsonDecode(value) as Map<String, dynamic>;
    return TimeLocRecordModel.fromMap(decoded.cast<String, Object?>());
  }

  Map<String, Object?> toMap() {
    return {
      'version': version,
      'stamp.local': stampLocal,
      'stamp.local.day': stampLocalDay,
      'stamp.utc': stampUtc,
      'stamp.utc.day': stampUtcDay,
      'geo.city': geoCity,
      'geo.region': geoRegion,
      'geo.country': geoCountry,
      'geo.source': geoSource,
      'seq': sequence,
      'sig': signature,
      'geo.lat': geoLatitude,
      'geo.lon': geoLongitude,
      'geo.alt': geoAltitude,
    };
  }

  String toJsonString() => jsonEncode(toMap());
}
