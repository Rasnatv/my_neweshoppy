class UserEventModel {
  final String id;
  final String eventName;
  final String startDate;
  final String endDate;
  final String time;
  final String location;
  final String bannerImage;

  UserEventModel({
    required this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.time,
    required this.location,
    required this.bannerImage,
  });

  factory UserEventModel.fromJson(Map<String, dynamic> json) {
    return UserEventModel(
      id: json['id'].toString(),
      eventName: json['event_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      time: json['time'] ?? '',
      location: json['event_location'] ?? '',
      bannerImage: json['banner_image'] ?? '',
    );
  }
}
