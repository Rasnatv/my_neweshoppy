
class AdminaddEventModel {
  final String id;
  final String eventName;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String eventLocation;
  final String bannerImage;
  final String createdByType;
  final String createdById;
  final String? district;
  final String? mainLocation;

  const AdminaddEventModel({
    required this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.eventLocation,
    required this.bannerImage,
    required this.createdByType,
    required this.createdById,
    this.district,
    this.mainLocation,
  });

  factory AdminaddEventModel.fromJson(Map<String, dynamic> json) {
    String? district = json['district']?.toString();
    String? mainLocation = json['main_location']?.toString();

    if (district != null && district.trim().isEmpty) district = null;
    if (mainLocation != null && mainLocation.trim().isEmpty) mainLocation = null;

    return AdminaddEventModel(
      id: json['id']?.toString() ?? '',
      eventName: json['event_name']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      eventLocation: json['event_location']?.toString() ?? '',
      bannerImage: json['banner_image']?.toString() ?? '',
      createdByType: json['created_by_type']?.toString() ?? '',
      createdById: json['created_by_id']?.toString() ?? '',
      district: district,
      mainLocation: mainLocation,
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
    'banner_image': bannerImage,
    'created_by_type': createdByType,
    'created_by_id': createdById,
    'district': district ?? '',
    'main_location': mainLocation ?? '',
  };

  bool get hasDistrict => district != null && district!.trim().isNotEmpty;
  bool get hasArea => mainLocation != null && mainLocation!.trim().isNotEmpty;
}