class TimeLocRecord {
  TimeLocRecord({
    required this.version,
    required this.stampLocal,
    required this.stampLocalDay,
    required this.stampUtc,
    required this.stampUtcDay,
    required this.geoCity,
    required this.geoRegion,
    required this.geoCountry,
    required this.geoSource,
    required this.sequence,
    required this.signature,
    this.geoLatitude,
    this.geoLongitude,
    this.geoAltitude,
  });

  final String version;
  final String stampLocal;
  final String stampLocalDay;
  final String stampUtc;
  final String stampUtcDay;
  final String? geoCity;
  final String? geoRegion;
  final String? geoCountry;
  final String geoSource;
  final String? sequence;
  final String? signature;
  final double? geoLatitude;
  final double? geoLongitude;
  final double? geoAltitude;
}
