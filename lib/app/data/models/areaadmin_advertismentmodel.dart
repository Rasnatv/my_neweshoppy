class AreaAdminAdvertisementModel {
  final int id;
  final String advertisement;
  final String mainLocation;
  final String bannerImage;

  AreaAdminAdvertisementModel({
    required this.id,
    required this.advertisement,
    required this.mainLocation,
    required this.bannerImage,
  });

  factory AreaAdminAdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AreaAdminAdvertisementModel(
      id: json['id'],
      advertisement: json['advertisement'] ?? '',
      mainLocation: json['main_location'] ?? '',
      bannerImage: json['banner_image'] ?? '',
    );
  }
}