class MerchantRegistrationResponse {
  final bool status;
  final int statusCode;
  final String message;
  final MerchantData? data;

  MerchantRegistrationResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory MerchantRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return MerchantRegistrationResponse(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? MerchantData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class MerchantData {
  final int id;
  final String userType;
  final String storeImage;
  final String ownerName;
  final String shopName;
  final String email;
  final String phoneNo1;
  final String phoneNo2;
  final String state;
  final String district;
  final String mainLocation;
  final double latitude;
  final double longitude;
  final String? whatsappNo;
  final String? facebookLink;
  final String? instagramLink;
  final String? websiteLink;
  final String authToken;

  MerchantData({
    required this.id,
    required this.userType,
    required this.storeImage,
    required this.ownerName,
    required this.shopName,
    required this.email,
    required this.phoneNo1,
    required this.phoneNo2,
    required this.state,
    required this.district,
    required this.mainLocation,
    required this.latitude,
    required this.longitude,
    this.whatsappNo,
    this.facebookLink,
    this.instagramLink,
    this.websiteLink,
    required this.authToken,
  });

  factory MerchantData.fromJson(Map<String, dynamic> json) {
    return MerchantData(
      id: json['id'] ?? 0,
      userType: json['user_type'] ?? '',
      storeImage: json['store_image'] ?? '',
      ownerName: json['owner_name'] ?? '',
      shopName: json['shop_name'] ?? '',
      email: json['email'] ?? '',
      phoneNo1: json['phone_no_1'] ?? '',
      phoneNo2: json['phone_no_2'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      mainLocation: json['main_location'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      whatsappNo: json['whatsapp_no'],
      facebookLink: json['facebook_link'],
      instagramLink: json['instagram_link'],
      websiteLink: json['website_link'],
      authToken: json['auth_token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_type': userType,
      'store_image': storeImage,
      'owner_name': ownerName,
      'shop_name': shopName,
      'email': email,
      'phone_no_1': phoneNo1,
      'phone_no_2': phoneNo2,
      'state': state,
      'district': district,
      'main_location': mainLocation,
      'latitude': latitude,
      'longitude': longitude,
      'whatsapp_no': whatsappNo,
      'facebook_link': facebookLink,
      'instagram_link': instagramLink,
      'website_link': websiteLink,
      'auth_token': authToken,
    };
  }
}