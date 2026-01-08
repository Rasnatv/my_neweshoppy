class MerchantModelss {
  final String id;
  final String? storeImage;
  final String ownerName;
  final String shopName;
  final String email;
  final String phone1;
  final String phone2;
  final String state;
  final String district;
  final String latitude;
  final String longitude;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String website;
  final List uploadImages;

  MerchantModelss({
    required this.id,
    this.storeImage,
    required this.ownerName,
    required this.shopName,
    required this.email,
    required this.phone1,
    required this.phone2,
    required this.state,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.website,
    required this.uploadImages,
  });

  factory MerchantModelss.fromJson(Map<String, dynamic> json) {
    return MerchantModelss(
      id: json['id'].toString(),
      storeImage: json['store_image'],
      ownerName: json['owner_name'] ?? '',
      shopName: json['shop_name'] ?? '',
      email: json['email'] ?? '',
      phone1: json['phone_no_1'] ?? '',
      phone2: json['phone_no_2'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      whatsapp: json['whatsapp_no'] ?? '',
      facebook: json['facebook_link'] ?? '',
      instagram: json['instagram_link'] ?? '',
      website: json['website_link'] ?? '',
      uploadImages: json['upload_images'] ?? [],
    );
  }
}
