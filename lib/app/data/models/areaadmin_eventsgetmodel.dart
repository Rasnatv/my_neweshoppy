
class AreaAdmingshowEventModel {
  final String id;
  final String eventName;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String eventLocation;
  final String mainLocation;
  final String bannerImage;
  final String createdAt;
  final String updatedAt;
  final String createdByType; // NEW
  final String createdById;   // NEW

  AreaAdmingshowEventModel({
    required this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.eventLocation,
    required this.mainLocation,
    required this.bannerImage,
    required this.createdAt,
    required this.updatedAt,
    required this.createdByType,
    required this.createdById,
  });

  factory AreaAdmingshowEventModel.fromJson(Map<String, dynamic> json) {
    return AreaAdmingshowEventModel(
      id: json['id']?.toString() ?? '',
      eventName: json['event_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      eventLocation: json['event_location'] ?? '',
      mainLocation: json['main_location'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdByType: json['created_by_type'] ?? '',  // NEW
      createdById: json['created_by_id']?.toString() ?? '',  // NEW
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_name': eventName,
    'start_date': startDate,
    'end_date': endDate,
    'start_time': startTime,
    'end_time': endTime,
    'event_location': eventLocation,
    'main_location': mainLocation,
    'banner_image': bannerImage,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'created_by_type': createdByType,  // NEW
    'created_by_id': createdById,      // NEW
  };

// In AreaAdmingshowEventModel

  bool get isEditableByAreaAdmin =>
      createdByType == 'area_admin' || createdByType == 'merchant';
}