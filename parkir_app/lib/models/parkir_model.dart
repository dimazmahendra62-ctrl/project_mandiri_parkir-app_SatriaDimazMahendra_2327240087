class ParkirModel {
  final String id;
  final String lokasi;
  final int kapasitas;
  final int tersedia;
  final String status;
  final double latitude;
  final double longitude;

  ParkirModel({
    required this.id,
    required this.lokasi,
    required this.kapasitas,
    required this.tersedia,
    required this.status,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'lokasi': lokasi,
      'kapasitas': kapasitas,
      'tersedia': tersedia,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}