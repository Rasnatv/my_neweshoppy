class UserLocationModel {
  final String state;
  final String district;
  final String mainLocation;

  UserLocationModel({
    required this.state,
    required this.district,
    required this.mainLocation,
  });

  factory UserLocationModel.fromJson(Map<String, dynamic> json) {
    return UserLocationModel(
      state: json['state']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      mainLocation: json['main_location']?.toString() ?? '',
    );
  }
}
