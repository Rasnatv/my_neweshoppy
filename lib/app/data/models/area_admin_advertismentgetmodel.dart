
class AreaAdmingetAdvertisementModel {
  final int id;
  final String advertisement;
  final String mainLocation;
  final String bannerImage;
  final DateTime createdAt;

  AreaAdmingetAdvertisementModel({
    required this.id,
    required this.advertisement,
    required this.mainLocation,
    required this.bannerImage,
    required this.createdAt,
  });

  factory AreaAdmingetAdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AreaAdmingetAdvertisementModel(
      // ✅ Safely parse id whether API sends int or String
      id: int.tryParse(json['id'].toString()) ?? 0,
      advertisement: json['advertisement']?.toString() ?? '',
      mainLocation: json['main_location']?.toString() ?? '',
      bannerImage: json['banner_image']?.toString() ?? '',
      // ✅ Safe DateTime parse with fallback
      createdAt: _parseDate(json['created_at']),
    );
  }

  static DateTime _parseDate(dynamic raw) {
    if (raw == null) return DateTime.now();
    try {
      return DateTime.parse(raw.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'advertisement': advertisement,
    'main_location': mainLocation,
    'banner_image': bannerImage,
    'created_at': createdAt.toIso8601String(),
  };
}