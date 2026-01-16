class AdminMerchant {
  final int id;
  final String shopName;
  final String email;
  final String mainLocation;
  final String approvalStatus;

  AdminMerchant({
    required this.id,
    required this.shopName,
    required this.email,
    required this.mainLocation,
    required this.approvalStatus,
  });

  factory AdminMerchant.fromJson(Map<String, dynamic> json) {
    return AdminMerchant(
      id: json['id'],
      shopName: json['shop_name'] ?? '',
      email: json['email'] ?? '',
      mainLocation: json['main_location'] ?? '',
      approvalStatus: json['approval_status'] ?? 'pending',
    );
  }
}
