class AddressListModel {
  final int addressId;
  final String fullName;
  final String phoneNumber;
  final String pincode;
  final String state;
  final String district;
  final String city;
  final String houseNo;
  final String area;
  final String? createdAt;

  AddressListModel({
    required this.addressId,
    required this.fullName,
    required this.phoneNumber,
    required this.pincode,
    required this.state,
    required this.district,
    required this.city,
    required this.houseNo,
    required this.area,
    this.createdAt,
  });

  factory AddressListModel.fromJson(Map<String, dynamic> json) {
    return AddressListModel(
      addressId: json['address_id'],
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      pincode: json['pincode'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      houseNo: json['house_no'] ?? '',
      area: json['area'] ?? '',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'pincode': pincode,
      'state': state,
      'district': district,
      'city': city,
      'house_no': houseNo,
      'area': area,
    };
  }

  /// Full formatted address string
  String get fullAddress =>
      '$houseNo, $area, $city, $district, $state - $pincode';
}