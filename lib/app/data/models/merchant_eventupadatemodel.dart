
class HEventModel {
  final String id;
  final String eventName;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String eventLocation;
  final String bannerImage;
  final String district;       // ← NEW (read-only in UI)
  final String? mainLocation;  // ← NEW (read-only in UI)

  HEventModel({
    required this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.eventLocation,
    required this.bannerImage,
    required this.district,
    this.mainLocation,
  });

  factory HEventModel.fromJson(Map<String, dynamic> json) {
    return HEventModel(
      id: json['id']?.toString() ?? '',
      eventName: json['event_name'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      eventLocation: json['event_location'] as String? ?? '',
      bannerImage: json['banner_image'] as String? ?? '',
      district: json['district'] as String? ?? '',          // ← NEW
      mainLocation: json['main_location'] as String?,       // ← NEW
    );
  }
}