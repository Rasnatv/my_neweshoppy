class AddressUpdateModel {
  final int addressId;
  final String fullName;
  final String phoneNumber;
  final String pincode;
  final String state;
  final String district;
  final String city;
  final String houseNo;
  final String area;

  AddressUpdateModel({
    required this.addressId,
    required this.fullName,
    required this.phoneNumber,
    required this.pincode,
    required this.state,
    required this.district,
    required this.city,
    required this.houseNo,
    required this.area,
  });

  factory AddressUpdateModel.fromJson(Map<String, dynamic> json) {
    return AddressUpdateModel(
      addressId: json['address_id'] as int,
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
      'address_id': addressId,
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