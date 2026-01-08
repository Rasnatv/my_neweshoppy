class MerchantModel {
  String ownerName;
  String shopName;
  String email;
  String phone;
  String state;
  String district;
  String location;
  String address;
  String? whatsapp;
  String? facebook;
  String? instagram;
  String? website;
  String? storeImage; // file path
  String status; // pending, approved, rejected

  MerchantModel({
    required this.ownerName,
    required this.shopName,
    required this.email,
    required this.phone,
    required this.state,
    required this.district,
    required this.location,
    required this.address,
    this.whatsapp,
    this.facebook,
    this.instagram,
    this.website,
    this.storeImage,
    this.status = "pending",
  });
}
