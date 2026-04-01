
class DistrictAdminGetAdvertisementModel {
  final String id;
  final String rawId;
  final String advertisement;
  final String district;
  final String bannerImage;
  final String createdByType;

  DistrictAdminGetAdvertisementModel({
    required this.id,
    required this.rawId,
    required this.advertisement,
    required this.district,
    required this.bannerImage,
    required this.createdByType,
  });

  factory DistrictAdminGetAdvertisementModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id']?.toString() ?? '0';

    return DistrictAdminGetAdvertisementModel(
      id: rawId, // ✅ just use rawId directly, it's already a String
      rawId: rawId,
      advertisement: json['advertisement']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      bannerImage: json['banner_image']?.toString() ?? '',
      createdByType: json['created_by_type']?.toString() ?? '',
    );
  }
}