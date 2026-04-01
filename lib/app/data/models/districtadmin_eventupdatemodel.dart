class DistrictAdminEventUpdateModel {
  final int id;
  final String createdById;
  final String createdByType;
  final String eventName;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String eventLocation;
  final String district;
  final String bannerImage;
  final String createdAt;
  final String updatedAt;

  DistrictAdminEventUpdateModel({
    required this.id,
    required this.createdById,
    required this.createdByType,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.eventLocation,
    required this.district,
    required this.bannerImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DistrictAdminEventUpdateModel.fromJson(Map<String, dynamic> json) {
    return DistrictAdminEventUpdateModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      createdById: json['created_by_id']?.toString() ?? '',
      createdByType: json['created_by_type'] ?? '',
      eventName: json['event_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      eventLocation: json['event_location'] ?? '',
      district: json['district'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}