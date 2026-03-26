class AreaAdminEventModel {
  final int id;
  final String createdById;
  final String createdByType;
  final String eventName;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String mainLocation;
  final String eventLocation;
  final String bannerImage;
  final String createdAt;
  final String updatedAt;

  AreaAdminEventModel({
    required this.id,
    required this.createdById,
    required this.createdByType,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.mainLocation,
    required this.eventLocation,
    required this.bannerImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AreaAdminEventModel.fromJson(Map<String, dynamic> json) {
    return AreaAdminEventModel(
      id: json['id'] ?? 0,
      createdById: json['created_by_id']?.toString() ?? '',
      createdByType: json['created_by_type'] ?? '',
      eventName: json['event_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      mainLocation: json['main_location'] ?? '',
      eventLocation: json['event_location'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by_id': createdById,
      'created_by_type': createdByType,
      'event_name': eventName,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
      'main_location': mainLocation,
      'event_location': eventLocation,
      'banner_image': bannerImage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}