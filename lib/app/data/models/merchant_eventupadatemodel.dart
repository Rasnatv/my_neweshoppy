class HEventModel {
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
  final String? createdAt;
  final String? updatedAt;

  HEventModel({
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
    this.createdAt,
    this.updatedAt,
  });

  factory HEventModel.fromJson(Map<String, dynamic> json) {
    return HEventModel(
      id: json['id']?.toString() ?? '',
      eventName: json['event_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      eventLocation: json['event_location'] ?? '',
      bannerImage: json['banner_image'] ?? '',
      createdByType: json['created_by_type'] ?? '',
      createdById: json['created_by_id']?.toString() ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  HEventModel copyWith({
    String? id,
    String? eventName,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? eventLocation,
    String? bannerImage,
    String? createdByType,
    String? createdById,
    String? createdAt,
    String? updatedAt,
  }) {
    return HEventModel(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      eventLocation: eventLocation ?? this.eventLocation,
      bannerImage: bannerImage ?? this.bannerImage,
      createdByType: createdByType ?? this.createdByType,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}