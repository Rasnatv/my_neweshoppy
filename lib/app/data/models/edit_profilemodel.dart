class ProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String profileImage;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.profileImage,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }
}
