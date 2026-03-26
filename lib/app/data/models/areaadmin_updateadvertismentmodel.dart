class AreaAdminAdvertisementupdateModel {
  final int id;
  final String advertisement;
  final String mainLocation;
  final String bannerImage;
  final String createdAt;
  final String updatedAt;

  AreaAdminAdvertisementupdateModel({
    required this.id,
    required this.advertisement,
    required this.mainLocation,
    required this.bannerImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AreaAdminAdvertisementupdateModel.fromJson(Map<String, dynamic> json) {
    return AreaAdminAdvertisementupdateModel(
      id: json['id'],
      advertisement: json['advertisement'] ?? '',
      mainLocation: json['main_location'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}