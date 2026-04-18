
class updateAdvertisementModel {
  final String  id;
  final String  advertisement;
  final String  bannerImage;
  final String  createdByType;
  final String  createdById;
  final String? state;        // ← added
  final String? district;
  final String? mainLocation; // main_location

  updateAdvertisementModel({
    required this.id,
    required this.advertisement,
    required this.bannerImage,
    required this.createdByType,
    required this.createdById,
    this.state,
    this.district,
    this.mainLocation,
  });

  // Convenience getters
  bool get hasDistrict =>
      (district ?? '').trim().isNotEmpty;
  bool get hasArea =>
      (mainLocation ?? '').trim().isNotEmpty;

  factory updateAdvertisementModel.fromJson(Map<String, dynamic> json) {
    return updateAdvertisementModel(
      id            : json['id']?.toString()            ?? '',
      advertisement : json['advertisement']?.toString() ?? '',
      bannerImage   : json['banner_image']?.toString()  ?? '',
      createdByType : json['created_by_type']?.toString() ?? '',
      createdById   : json['created_by_id']?.toString() ?? '',
      state         : json['state']?.toString(),
      district      : json['district']?.toString(),
      mainLocation  : json['main_location']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id'              : id,
    'advertisement'   : advertisement,
    'banner_image'    : bannerImage,
    'created_by_type' : createdByType,
    'created_by_id'   : createdById,
    'state'           : state,
    'district'        : district,
    'main_location'   : mainLocation,
  };
}

class updateAdvertisementResponse {
  final String                  status;
  final String                  statusCode;
  final String                  message;
  final updateAdvertisementModel? data;

  updateAdvertisementResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.data,
  });

  bool get isSuccess =>
      status == '1' || status == 'true' || status == 'success';

  factory updateAdvertisementResponse.fromJson(
      Map<String, dynamic> json) {
    return updateAdvertisementResponse(
      status     : json['status']?.toString()      ?? '0',
      statusCode : json['status_code']?.toString() ?? '',
      message    : json['message']?.toString()     ?? '',
      data       : json['data'] != null
          ? updateAdvertisementModel.fromJson(
          json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}