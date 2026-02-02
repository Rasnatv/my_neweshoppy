class MerchantAboutModel {
  final int merchantId;
  final String address;
  final String phone1;
  final String phone2;
  final String website;
  final String email;
  final String instagram;
  final String whatsapp;
  final String facebook;

  MerchantAboutModel({
    required this.merchantId,
    required this.address,
    required this.phone1,
    required this.phone2,
    required this.website,
    required this.email,
    required this.instagram,
    required this.whatsapp,
    required this.facebook,
  });

  factory MerchantAboutModel.fromJson(Map<String, dynamic> json) {
    return MerchantAboutModel(
      merchantId: json['merchant_id'] is String
          ? int.parse(json['merchant_id'])
          : json['merchant_id'] ?? 0,
      address: json['address'] ?? '',
      phone1: json['phone_no_1'] ?? '',
      phone2: json['phone_no_2'] ?? '',
      website: json['website_url'] ?? '',
      email: json['email'] ?? '',
      instagram: json['instagram_link'] ?? '',
      whatsapp: json['whatsapp_no'] ?? '',
      facebook: json['facebook_link'] ?? '',
    );
  }
}
