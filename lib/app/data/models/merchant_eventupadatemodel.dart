//
// class HEventModel {
//   final String id;
//   final String eventName;
//   final String startDate;
//   final String endDate;
//   final String startTime;
//   final String endTime;
//   final String eventLocation;
//   final String bannerImage;
//   final String district;       // ← NEW (read-only in UI)
//   final String? mainLocation;  // ← NEW (read-only in UI)
//
//   HEventModel({
//     required this.id,
//     required this.eventName,
//     required this.startDate,
//     required this.endDate,
//     required this.startTime,
//     required this.endTime,
//     required this.eventLocation,
//     required this.bannerImage,
//     required this.district,
//     this.mainLocation,
//   });
//
//   factory HEventModel.fromJson(Map<String, dynamic> json) {
//     return HEventModel(
//       id: json['id']?.toString() ?? '',
//       eventName: json['event_name'] as String? ?? '',
//       startDate: json['start_date'] as String? ?? '',
//       endDate: json['end_date'] as String? ?? '',
//       startTime: json['start_time'] as String? ?? '',
//       endTime: json['end_time'] as String? ?? '',
//       eventLocation: json['event_location'] as String? ?? '',
//       bannerImage: json['banner_image'] as String? ?? '',
//       district: json['district'] as String? ?? '',          // ← NEW
//       mainLocation: json['main_location'] as String?,       // ← NEW
//     );
//   }
// }
class HEventModel {
  final String id;
  final String eventName;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  final String eventLocation;
  final String bannerImage;
  final String? state;
  final String? district;
  final String? mainLocation;

  HEventModel({
    required this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.eventLocation,
    required this.bannerImage,
    this.state,
    this.district,
    this.mainLocation,
  });

  factory HEventModel.fromJson(Map<String, dynamic> json) {
    return HEventModel(
      id            : json['id']?.toString() ?? '',
      eventName     : json['event_name']     as String? ?? '',
      startDate     : json['start_date']     as String? ?? '',
      endDate       : json['end_date']       as String? ?? '',
      startTime     : json['start_time']     as String? ?? '',
      endTime       : json['end_time']       as String? ?? '',
      eventLocation : json['event_location'] as String? ?? '',
      bannerImage   : json['banner_image']   as String? ?? '',
      state         : json['state']          as String?,
      district      : json['district']       as String?,
      mainLocation  : json['main_location']  as String?,
    );
  }

  /// Convenience copy-with for local updates after a successful API response.
  HEventModel copyWith({
    String? id,
    String? eventName,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? eventLocation,
    String? bannerImage,
    String? state,
    String? district,
    String? mainLocation,
  }) {
    return HEventModel(
      id            : id            ?? this.id,
      eventName     : eventName     ?? this.eventName,
      startDate     : startDate     ?? this.startDate,
      endDate       : endDate       ?? this.endDate,
      startTime     : startTime     ?? this.startTime,
      endTime       : endTime       ?? this.endTime,
      eventLocation : eventLocation ?? this.eventLocation,
      bannerImage   : bannerImage   ?? this.bannerImage,
      state         : state         ?? this.state,
      district      : district      ?? this.district,
      mainLocation  : mainLocation  ?? this.mainLocation,
    );
  }

  @override
  String toString() => 'HEventModel(id: $id, eventName: $eventName, '
      'state: $state, district: $district, mainLocation: $mainLocation)';
}