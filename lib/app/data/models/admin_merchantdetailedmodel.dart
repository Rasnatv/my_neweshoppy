
class AdminMerchantDetail {
  final int id;
  final String storeImage;
  final String ownerName;
  final String shopName;
  final String email;
  final String phone1;
  final String phone2;
  final String state;
  final String district;
  final String mainLocation;
  final String latitude;
  final String longitude;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String website;
  final String approvalStatus;
  final String createdAt;

  AdminMerchantDetail({
    required this.id,
    required this.storeImage,
    required this.ownerName,
    required this.shopName,
    required this.email,
    required this.phone1,
    required this.phone2,
    required this.state,
    required this.district,
    required this.mainLocation,
    required this.latitude,
    required this.longitude,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.website,
    required this.approvalStatus,
    required this.createdAt,
  });

  factory AdminMerchantDetail.fromJson(Map<String, dynamic> json) {
    return AdminMerchantDetail(
      id: json['id'],
      storeImage: json['store_image'] ?? '',
      ownerName: json['owner_name'] ?? '',
      shopName: json['shop_name'] ?? '',
      email: json['email'] ?? '',
      phone1: json['phone_no_1'] ?? '',
      phone2: json['phone_no_2'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      mainLocation: json['main_location'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      whatsapp: json['whatsapp_no'] ?? '',
      facebook: json['facebook_link'] ?? '',
      instagram: json['instagram_link'] ?? '',
      website: json['website_link'] ?? '',
      approvalStatus: json['approval_status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
    );
  }

  AdminMerchantDetail copyWith({String? approvalStatus}) {
    return AdminMerchantDetail(
      id: id,
      storeImage: storeImage,
      ownerName: ownerName,
      shopName: shopName,
      email: email,
      phone1: phone1,
      phone2: phone2,
      state: state,
      district: district,
      mainLocation: mainLocation,
      latitude: latitude,
      longitude: longitude,
      whatsapp: whatsapp,
      facebook: facebook,
      instagram: instagram,
      website: website,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      createdAt: createdAt,
    );
  }
}
