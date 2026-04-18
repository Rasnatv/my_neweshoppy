class HomeEventModel {
  final String id;
  final String eventName;
  final String bannerImage;
  final String mainLocation;
  final String district;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;

  HomeEventModel({
    required this.id,
    required this.eventName,
    required this.bannerImage,
    required this.mainLocation,
    required this.district,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
  });

  factory HomeEventModel.fromJson(Map<String, dynamic> j) => HomeEventModel(
    id: j['id']?.toString() ?? '',
    eventName: j['event_name'] ?? '',
    bannerImage: j['banner_image'] ?? '',
    mainLocation: j['main_location'] ?? '',
    district: j['district'] ?? '',
    startDate: j['start_date'] ?? '',
    endDate: j['end_date'] ?? '',
    startTime: j['start_time'] ?? '',
    endTime: j['end_time'] ?? '',
  );
}