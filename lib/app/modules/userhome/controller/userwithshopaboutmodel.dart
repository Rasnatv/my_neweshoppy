class MerchantAboutModel {
  final int merchantId;
  final String address;
  final String phone1;
  final String phone2;
  final String website;
  final String email;

  MerchantAboutModel({
    required this.merchantId,
    required this.address,
    required this.phone1,
    required this.phone2,
    required this.website,
    required this.email,
  });

  factory MerchantAboutModel.fromJson(Map<String, dynamic> json) {
    return MerchantAboutModel(
      merchantId: json['merchant_id'],
      address: json['address'] ?? '',
      phone1: json['phone_no_1'] ?? '',
      phone2: json['phone_no_2'] ?? '',
      website: json['website_url'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
