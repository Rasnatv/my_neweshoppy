class AdminaddEventModel {
  final String id;
  final String eventName;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String eventLocation;
  final String? bannerImage;
  final String createdByType;
  final int createdById;

  AdminaddEventModel({
    required this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.eventLocation,
    this.bannerImage,
    required this.createdByType,
    required this.createdById,
  });

  factory  AdminaddEventModel.fromJson(Map<String, dynamic> json) {
    return  AdminaddEventModel(
      id:            json['id'].toString(),
      eventName:     json['event_name']      ?? '',
      startDate:     json['start_date']      ?? '',
      endDate:       json['end_date']        ?? '',
      startTime:     json['start_time']      ?? '',
      endTime:       json['end_time']        ?? '',
      eventLocation: json['event_location']  ?? '',
      bannerImage:   json['banner_image'],
      createdByType: json['created_by_type'] ?? '',
      createdById:   json['created_by_id']   is int
          ? json['created_by_id']
          : int.tryParse(json['created_by_id'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':              id,
    'event_name':      eventName,
    'start_date':      startDate,
    'end_date':        endDate,
    'start_time':      startTime,
    'end_time':        endTime,
    'event_location':  eventLocation,
    'banner_image':    bannerImage,
    'created_by_type': createdByType,
    'created_by_id':   createdById,
  };
}