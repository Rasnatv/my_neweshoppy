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
      id: json['id'],
      advertisement: json['advertisement'] ?? '',
      mainLocation: json['main_location'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}