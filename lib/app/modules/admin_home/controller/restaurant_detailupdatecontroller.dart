//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import '../../../data/models/restaurant_detailupdatemodel.dart';
// //
// // class RestaurantUpdateController extends GetxController {
// //   final box = GetStorage();
// //   final picker = ImagePicker();
// //
// //   late int restaurantId;
// //   Map<String, dynamic>? restaurantData;
// //
// //   Rx<File?> restaurantImage = Rx<File?>(null);
// //
// //   final ownerCtrl = TextEditingController();
// //   final nameCtrl = TextEditingController();
// //   final addressCtrl = TextEditingController();
// //   final phoneCtrl = TextEditingController();
// //   final emailCtrl = TextEditingController();
// //   final websiteCtrl = TextEditingController();
// //   final whatsappCtrl = TextEditingController();
// //   final facebookCtrl = TextEditingController();
// //   final instaCtrl = TextEditingController();
// //
// //   String get adminToken => box.read('admin_token') ?? '';
// //
// //   // Method to initialize fields after data is set
// //   void initializeFields() {
// //     if (restaurantData != null) {
// //       // Debug print to see what data we have
// //       print("=== Restaurant Data ===");
// //       print("Full data: $restaurantData");
// //       print("Restaurant Name: ${restaurantData?['restaurant_name']}");
// //       print("Owner Name: ${restaurantData?['owner_name']}");
// //
// //       // Set all fields
// //       nameCtrl.text = restaurantData?['restaurant_name']?.toString() ?? '';
// //       ownerCtrl.text = restaurantData?['owner_name']?.toString() ?? '';
// //       addressCtrl.text = restaurantData?['address']?.toString() ?? '';
// //       phoneCtrl.text = restaurantData?['phone']?.toString() ?? '';
// //       emailCtrl.text = restaurantData?['email']?.toString() ?? '';
// //       websiteCtrl.text = restaurantData?['website']?.toString() ?? '';
// //       whatsappCtrl.text = restaurantData?['whatsapp']?.toString() ?? '';
// //       facebookCtrl.text = restaurantData?['facebook_link']?.toString() ?? '';
// //       instaCtrl.text = restaurantData?['instagram_link']?.toString() ?? '';
// //
// //       // Debug print to confirm what was set
// //       print("Name Controller Text: ${nameCtrl.text}");
// //       print("======================");
// //     }
// //   }
// //
// //   Future<void> pickImage() async {
// //     final XFile? img = await picker.pickImage(
// //       source: ImageSource.gallery,
// //       imageQuality: 70,
// //     );
// //     if (img != null) restaurantImage.value = File(img.path);
// //   }
// //
// //   Future<String> _base64(File file) async {
// //     final bytes = await file.readAsBytes();
// //     return "data:image/jpeg;base64,${base64Encode(bytes)}";
// //   }
// //
// //   Future<void> updateRestaurant({VoidCallback? onUpdated}) async {
// //     if (adminToken.isEmpty) {
// //       Get.snackbar("Unauthorized", "Admin session expired");
// //       return;
// //     }
// //
// //     String? image64;
// //     if (restaurantImage.value != null) {
// //       image64 = await _base64(restaurantImage.value!);
// //     }
// //
// //     final request = RestaurantUpdateRequest(
// //       restaurantId: restaurantId,
// //       restaurantImage: image64,
// //       ownerName: ownerCtrl.text.trim().isEmpty ? null : ownerCtrl.text.trim(),
// //       restaurantname: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
// //       address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
// //       phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
// //       email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
// //       website: websiteCtrl.text.trim().isEmpty ? null : websiteCtrl.text.trim(),
// //       whatsapp: whatsappCtrl.text.trim().isEmpty ? null : whatsappCtrl.text.trim(),
// //       facebook: facebookCtrl.text.trim().isEmpty ? null : facebookCtrl.text.trim(),
// //       instagram: instaCtrl.text.trim().isEmpty ? null : instaCtrl.text.trim(),
// //     );
// //
// //     try {
// //       final response = await http.post(
// //         Uri.parse(
// //           "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurant/update",
// //         ),
// //         headers: {
// //           "Accept": "application/json",
// //           "Content-Type": "application/json",
// //           "Authorization": "Bearer $adminToken",
// //         },
// //         body: jsonEncode(request.toJson()),
// //       );
// //
// //       final data = jsonDecode(response.body);
// //
// //       if (data['status'].toString() == "1") {
// //         Get.snackbar("Success", data['message']);
// //         onUpdated?.call();
// //         Get.back();
// //       } else {
// //         Get.snackbar("Error", data['message'] ?? "Update failed");
// //       }
// //     } catch (e) {
// //       Get.snackbar("Error", e.toString());
// //     }
// //   }
// //
// //   @override
// //   void onClose() {
// //     ownerCtrl.dispose();
// //     nameCtrl.dispose();
// //     addressCtrl.dispose();
// //     phoneCtrl.dispose();
// //     emailCtrl.dispose();
// //     websiteCtrl.dispose();
// //     whatsappCtrl.dispose();
// //     facebookCtrl.dispose();
// //     instaCtrl.dispose();
// //     super.onClose();
// //   }
// // }
// class RestaurantUpdateController extends GetxController {
//   final box = GetStorage();
//   final picker = ImagePicker();
//
//   late int restaurantId;
//   Map<String, dynamic>? restaurantData;
//
//   Rx<File?> restaurantImage = Rx<File?>(null);
//
//   final ownerCtrl = TextEditingController();
//   final nameCtrl = TextEditingController();
//   final addressCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   final emailCtrl = TextEditingController();
//   final websiteCtrl = TextEditingController();
//   final whatsappCtrl = TextEditingController();
//   final facebookCtrl = TextEditingController();
//   final instaCtrl = TextEditingController();
//
//   String get adminToken => box.read('admin_token') ?? '';
//
//   // Method to initialize fields after data is set
//   void initializeFields() {
//     print("🔍 ========== INITIALIZE FIELDS CALLED ==========");
//     print("🔍 restaurantData is null? ${restaurantData == null}");
//
//     if (restaurantData == null) {
//       print("❌ ERROR: restaurantData is NULL!");
//       return;
//     }
//
//     print("🔍 restaurantData keys: ${restaurantData!.keys.toList()}");
//     print("🔍 restaurantData full: $restaurantData");
//
//     // Check if restaurant_name key exists
//     print("🔍 Has 'restaurant_name' key? ${restaurantData!.containsKey('restaurant_name')}");
//     print("🔍 restaurant_name value: '${restaurantData!['restaurant_name']}'");
//     print("🔍 restaurant_name type: ${restaurantData!['restaurant_name'].runtimeType}");
//
//     // Set all fields with extra logging
//     final restaurantName = (restaurantData!['restaurant_name'] ?? '').toString();
//     print("🔍 Setting nameCtrl.text to: '$restaurantName'");
//     nameCtrl.text = restaurantName;
//     print("✅ nameCtrl.text after setting: '${nameCtrl.text}'");
//
//     ownerCtrl.text = (restaurantData!['owner_name'] ?? '').toString();
//     addressCtrl.text = (restaurantData!['address'] ?? '').toString();
//     phoneCtrl.text = (restaurantData!['phone'] ?? '').toString();
//     emailCtrl.text = (restaurantData!['email'] ?? '').toString();
//     websiteCtrl.text = (restaurantData!['website'] ?? '').toString();
//     whatsappCtrl.text = (restaurantData!['whatsapp'] ?? '').toString();
//     facebookCtrl.text = (restaurantData!['facebook_link'] ?? '').toString();
//     instaCtrl.text = (restaurantData!['instagram_link'] ?? '').toString();
//
//     print("🔍 ========== INITIALIZATION COMPLETE ==========");
//   }
//
//   // Rest of your methods...
//   Future<void> pickImage() async {
//     final XFile? img = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 70,
//     );
//     if (img != null) restaurantImage.value = File(img.path);
//   }
//
//   Future<String> _base64(File file) async {
//     final bytes = await file.readAsBytes();
//     return "data:image/jpeg;base64,${base64Encode(bytes)}";
//   }
//
//   Future<void> updateRestaurant({VoidCallback? onUpdated}) async {
//     if (adminToken.isEmpty) {
//       Get.snackbar("Unauthorized", "Admin session expired");
//       return;
//     }
//
//     String? image64;
//     if (restaurantImage.value != null) {
//       image64 = await _base64(restaurantImage.value!);
//     }
//
//     final request = RestaurantUpdateRequest(
//       restaurantId: restaurantId,
//       restaurantImage: image64,
//       ownerName: ownerCtrl.text.trim().isEmpty ? null : ownerCtrl.text.trim(),
//       restaurantname: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
//       address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
//       phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
//       email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
//       website: websiteCtrl.text.trim().isEmpty ? null : websiteCtrl.text.trim(),
//       whatsapp: whatsappCtrl.text.trim().isEmpty ? null : whatsappCtrl.text.trim(),
//       facebook: facebookCtrl.text.trim().isEmpty ? null : facebookCtrl.text.trim(),
//       instagram: instaCtrl.text.trim().isEmpty ? null : instaCtrl.text.trim(),
//     );
//
//     try {
//       final response = await http.post(
//         Uri.parse(
//           "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurant/update",
//         ),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $adminToken",
//         },
//         body: jsonEncode(request.toJson()),
//       );
//
//       final data = jsonDecode(response.body);
//
//       if (data['status'].toString() == "1") {
//         Get.snackbar("Success", data['message']);
//         onUpdated?.call();
//         Get.back();
//       } else {
//         Get.snackbar("Error", data['message'] ?? "Update failed");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
//
//   @override
//   void onClose() {
//     ownerCtrl.dispose();
//     nameCtrl.dispose();
//     addressCtrl.dispose();
//     phoneCtrl.dispose();
//     emailCtrl.dispose();
//     websiteCtrl.dispose();
//     whatsappCtrl.dispose();
//     facebookCtrl.dispose();
//     instaCtrl.dispose();
//     super.onClose();
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../data/models/restaurant_detailupdatemodel.dart';

class RestaurantUpdateController extends GetxController {
  final box = GetStorage();
  final picker = ImagePicker();

  late int restaurantId;
  Map<String, dynamic>? restaurantData;

  Rx<File?> restaurantImage = Rx<File?>(null);
  var isInitialized = false.obs;

  final ownerCtrl = TextEditingController();
  final restaurantnameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  final facebookCtrl = TextEditingController();
  final instaCtrl = TextEditingController();

  String get adminToken => box.read('admin_token') ?? '';

  // Initialize with restaurant data
  void init(int id, Map<String, dynamic> data) {
    restaurantId = id;
    restaurantData = data;
    initializeFields();
  }

  // Method to initialize fields after data is set
  void initializeFields() {
    if (restaurantData == null) {
      print("❌ ERROR: restaurantData is NULL!");
      return;
    }

    print("🔍 ========== INITIALIZING FIELDS ==========");
    print("🔍 Restaurant Data: $restaurantData");

    // Set all fields with safe null handling
    restaurantnameCtrl.text = restaurantData!['restaurant_name']?.toString() ?? '';
    ownerCtrl.text = restaurantData!['owner_name']?.toString() ?? '';
    addressCtrl.text = restaurantData!['address']?.toString() ?? '';
    phoneCtrl.text = restaurantData!['phone']?.toString() ?? '';
    emailCtrl.text = restaurantData!['email']?.toString() ?? '';
    websiteCtrl.text = restaurantData!['website']?.toString() ?? '';
    whatsappCtrl.text = restaurantData!['whatsapp']?.toString() ?? '';
    facebookCtrl.text = restaurantData!['facebook_link']?.toString() ?? '';
    instaCtrl.text = restaurantData!['instagram_link']?.toString() ?? '';

    isInitialized.value = true;

    print("✅ Name: '${restaurantnameCtrl.text}'");
    print("✅ Owner: '${ownerCtrl.text}'");
    print("✅ Address: '${addressCtrl.text}'");
    print("✅ Phone: '${phoneCtrl.text}'");
    print("✅ Email: '${emailCtrl.text}'");
    print("✅ Website: '${websiteCtrl.text}'");
    print("✅ WhatsApp: '${whatsappCtrl.text}'");
    print("✅ Facebook: '${facebookCtrl.text}'");
    print("✅ Instagram: '${instaCtrl.text}'");
    print("🔍 ==========================================");
  }

  Future<void> pickImage() async {
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (img != null) restaurantImage.value = File(img.path);
  }

  Future<String> _base64(File file) async {
    final bytes = await file.readAsBytes();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  Future<void> updateRestaurant({VoidCallback? onUpdated}) async {
    if (adminToken.isEmpty) {
      Get.snackbar("Unauthorized", "Admin session expired");
      return;
    }

    String? image64;
    if (restaurantImage.value != null) {
      image64 = await _base64(restaurantImage.value!);
    }

    final request = RestaurantUpdateRequest(
      restaurantId: restaurantId,
      restaurantImage: image64,
      ownerName: ownerCtrl.text.trim().isEmpty ? null : ownerCtrl.text.trim(),
      restaurantname: restaurantnameCtrl.text.trim().isEmpty ? null : restaurantnameCtrl.text.trim(),
      address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
      phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
      email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
      website: websiteCtrl.text.trim().isEmpty ? null : websiteCtrl.text.trim(),
      whatsapp: whatsappCtrl.text.trim().isEmpty ? null : whatsappCtrl.text.trim(),
      facebook: facebookCtrl.text.trim().isEmpty ? null : facebookCtrl.text.trim(),
      instagram: instaCtrl.text.trim().isEmpty ? null : instaCtrl.text.trim(),
    );

    try {
      final response = await http.post(
        Uri.parse(
          "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurant/update",
        ),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $adminToken",
        },
        body: jsonEncode(request.toJson()),
      );

      final data = jsonDecode(response.body);

      if (data['status'].toString() == "1") {
        Get.snackbar("Success", data['message']);
        onUpdated?.call();
        Get.back();
      } else {
        Get.snackbar("Error", data['message'] ?? "Update failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  void onClose() {
    ownerCtrl.dispose();
    restaurantnameCtrl.dispose();
    addressCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    websiteCtrl.dispose();
    whatsappCtrl.dispose();
    facebookCtrl.dispose();
    instaCtrl.dispose();
    super.onClose();
  }
}