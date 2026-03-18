class AddressModel {
  final int? addressId;
  final String fullName;
  final String phoneNumber;
  final String pincode;
  final String state;
  final String district;
  final String city;
  final String houseNo;
  final String area;

  AddressModel({
    this.addressId,
    required this.fullName,
    required this.phoneNumber,
    required this.pincode,
    required this.state,
    required this.district,
    required this.city,
    required this.houseNo,
    required this.area,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'],
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      pincode: json['pincode'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      houseNo: json['house_no'] ?? '',
      area: json['area'] ?? '',
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
}