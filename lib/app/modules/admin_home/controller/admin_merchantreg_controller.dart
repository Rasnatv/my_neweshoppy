// //
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // class AdminMerchantRegController extends GetxController {
// //
// //   // Personal
// //   final name = TextEditingController();
// //   final phone = TextEditingController();
// //
// //   // Shop
// //   final shopName = TextEditingController();
// //   final location = TextEditingController();
// //
// //   // Social & Contact
// //   final whatsapp = TextEditingController();
// //   final facebook = TextEditingController();
// //   final instagram = TextEditingController();
// //   final website = TextEditingController();
// //
// //   // Account
// //   final username = TextEditingController();
// //   final password = TextEditingController();
// //
// //   // Dropdowns
// //   var selectedState = "".obs;
// //   var selectedDistrict = "".obs;
// //   var status = "Pending".obs;
// //
// //   final states = ["Kerala", "Tamil Nadu"];
// //   final districts = ["Kochi", "Trivandrum", "Calicut"];
// //
// //   void registerMerchant() {
// //     final data = {
// //       "name": name.text,
// //       "phone": phone.text,
// //       "shopName": shopName.text,
// //       "state": selectedState.value,
// //       "district": selectedDistrict.value,
// //       "location": location.text,
// //       "whatsapp": whatsapp.text,
// //       "facebook": facebook.text,
// //       "instagram": instagram.text,
// //       "website": website.text,
// //       "email": username.text,
// //       "password": password.text,
// //       "status": status.value,
// //     };
// //
// //     debugPrint(data.toString());
// //     Get.snackbar("Success", "Merchant Registered");
// //   }
// //
// //   @override
// //   void onClose() {
// //     name.dispose();
// //     phone.dispose();
// //     shopName.dispose();
// //     location.dispose();
// //     whatsapp.dispose();
// //     facebook.dispose();
// //     instagram.dispose();
// //     website.dispose();
// //     username.dispose();
// //     password.dispose();
// //     super.onClose();
// //   }
// // }
// //
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// class AdminMerchantRegController extends GetxController {
//
//   final ImagePicker _picker = ImagePicker();
//
//   // ================== Images ==================
//   Rx<File?> shopCoverImage = Rx<File?>(null);
//   RxList<File> shopImages = <File>[].obs;
//
//   // ================== Personal ==================
//   final name = TextEditingController();
//   final phone = TextEditingController();
//
//   // ================== Shop ==================
//   final shopName = TextEditingController();
//   final location = TextEditingController();
//
//   // ================== Social ==================
//   final whatsapp = TextEditingController();
//   final facebook = TextEditingController();
//   final instagram = TextEditingController();
//   final website = TextEditingController();
//
//   // ================== Account ==================
//   final username = TextEditingController();
//   final password = TextEditingController();
//
//   // ================== Dropdowns ==================
//   var selectedState = "".obs;
//   var selectedDistrict = "".obs;
//   var status = "Pending".obs;
//
//   final states = ["Kerala", "Tamil Nadu"];
//   final districts = ["Kochi", "Trivandrum", "Calicut"];
//
//   // ================== Image Pickers ==================
//   Future<void> pickCoverImage() async {
//     final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
//     if (img != null) shopCoverImage.value = File(img.path);
//   }
//
//   Future<void> pickShopImages() async {
//     final List<XFile> imgs = await _picker.pickMultiImage();
//     shopImages.addAll(imgs.map((e) => File(e.path)));
//   }
//
//   void removeShopImage(int index) {
//     shopImages.removeAt(index);
//   }
//
//   // ================== Submit ==================
//   void registerMerchant() {
//     final data = {
//       "name": name.text,
//       "phone": phone.text,
//       "shopName": shopName.text,
//       "state": selectedState.value,
//       "district": selectedDistrict.value,
//       "location": location.text,
//       "whatsapp": whatsapp.text,
//       "facebook": facebook.text,
//       "instagram": instagram.text,
//       "website": website.text,
//       "email": username.text,
//       "status": status.value,
//       "coverImage": shopCoverImage.value?.path,
//       "storeImages": shopImages.map((e) => e.path).toList(),
//     };
//
//     debugPrint(data.toString());
//     Get.snackbar("Success", "Merchant Registered");
//   }
//
//   @override
//   void onClose() {
//     name.dispose();
//     phone.dispose();
//     shopName.dispose();
//     location.dispose();
//     whatsapp.dispose();
//     facebook.dispose();
//     instagram.dispose();
//     website.dispose();
//     username.dispose();
//     password.dispose();
//     super.onClose();
//   }
// }
