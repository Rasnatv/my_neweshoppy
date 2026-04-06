
class AreaAdminAdvertisementupdateModel {
  final int id;
  final String advertisement;
  final String bannerImage;
  final String mainLocation;
  final String createdByType;
  final int createdById;

  const AreaAdminAdvertisementupdateModel({
    required this.id,
    required this.advertisement,
    required this.bannerImage,
    required this.mainLocation,
    required this.createdByType,
    required this.createdById,
  });

  factory AreaAdminAdvertisementupdateModel.fromJson(
      Map<String, dynamic> json) {
    return AreaAdminAdvertisementupdateModel(
      // API returns id as a String ("50") — parse safely
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      advertisement: json['advertisement']?.toString() ?? '',
      bannerImage: json['banner_image']?.toString() ?? '',
      mainLocation: json['main_location']?.toString() ?? '',
      createdByType: json['created_by_type']?.toString() ?? '',
      createdById:
      int.tryParse(json['created_by_id']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'advertisement': advertisement,
    'banner_image': bannerImage,
    'main_location': mainLocation,
    'created_by_type': createdByType,
    'created_by_id': createdById,
  };
}