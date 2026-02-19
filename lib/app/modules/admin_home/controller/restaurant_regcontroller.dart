//
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import '../../../data/models/restaurent_adminregmodel.dart';
// import '../view/restaurant/restaurant_menumanagment.dart';
//
// class RestaurantRegController extends GetxController {
//   final box = GetStorage();
//   final picker = ImagePicker();
//
//   Rx<File?> restaurantImage = Rx<File?>(null);
//   RxList<File> additionalImages = <File>[].obs;
//   RxBool isLoading = false.obs;
//
//   final ownerCtrl = TextEditingController();
//   final restaurantNameCtrl = TextEditingController();
//   final addressCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   final emailCtrl = TextEditingController();
//   final websiteCtrl = TextEditingController();
//   final whatsappCtrl = TextEditingController();
//   final facebookCtrl = TextEditingController();
//   final instaCtrl = TextEditingController();
//
//   String get token => box.read('auth_token') ?? '';
//
//   // PICK MAIN IMAGE
//   Future<void> pickRestaurantImage() async {
//     final XFile? image =
//     await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
//     if (image != null) restaurantImage.value = File(image.path);
//   }
//
//   // PICK ADDITIONAL IMAGES
//   Future<void> pickAdditionalImages() async {
//     final List<XFile>? images =
//     await picker.pickMultiImage(imageQuality: 70);
//     if (images != null) {
//       additionalImages.addAll(images.map((e) => File(e.path)));
//     }
//   }
//
//   // FILE → BASE64
//   Future<String> _fileToBase64(File file) async {
//     final bytes = await file.readAsBytes();
//     return "data:image/jpeg;base64,${base64Encode(bytes)}";
//   }
//
//   // SUBMIT
//   Future<void> submit() async {
//     if (token.isEmpty) {
//       Get.snackbar("Session Expired", "Please login again");
//       return;
//     }
//
//     if (restaurantImage.value == null ||
//         ownerCtrl.text.isEmpty ||
//         restaurantNameCtrl.text.isEmpty ||
//         addressCtrl.text.isEmpty ||
//         phoneCtrl.text.isEmpty) {
//       Get.snackbar("Error", "Please fill mandatory fields");
//       return;
//     }
//
//     isLoading.value = true;
//
//     try {
//       final mainImage = await _fileToBase64(restaurantImage.value!);
//
//       final List<String> additionalBase64 = [];
//       for (var img in additionalImages) {
//         additionalBase64.add(await _fileToBase64(img));
//       }
//
//       final request = RestaurantRegisterRequest(
//         ownerName: ownerCtrl.text.trim(),
//         restaurantName: restaurantNameCtrl.text.trim(),
//         address: addressCtrl.text.trim(),
//         phone: phoneCtrl.text.trim(),
//         email: emailCtrl.text.trim(),
//         website: websiteCtrl.text.trim(),
//         whatsapp: whatsappCtrl.text.trim(),
//         facebook: facebookCtrl.text.trim(),
//         instagram: instaCtrl.text.trim(),
//         restaurantImage: mainImage,
//         additionalImages: additionalBase64,
//       );
//
//       final response = await http.post(
//         Uri.parse(
//             "https://rasma.astradevelops.in/e_shoppyy/public/api/restaurant/register"),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode(request.toJson()),
//       );
//
//       final data = jsonDecode(response.body);
//
//       if ((response.statusCode == 200 || response.statusCode == 201) &&
//           (data['status'] == "1" || data['status'] == true)) {
//         Get.snackbar("Success", data['message'] ?? "Registered successfully");
//         Get.off(() => MenuManagementPage());
//       } else {
//         Get.snackbar("Error", data['message'] ?? "Failed to register restaurant");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong");
//       print("Submit Exception: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     ownerCtrl.dispose();
//     restaurantNameCtrl.dispose();
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
import '../../../data/models/restaurent_adminregmodel.dart';
import '../view/restaurant/restaurant_menumanagment.dart';

class RestaurantRegController extends GetxController {
  final box = GetStorage();
  final picker = ImagePicker();

  Rx<File?> restaurantImage = Rx<File?>(null);
  RxList<File> additionalImages = <File>[].obs;
  RxBool isLoading = false.obs;

  final ownerCtrl = TextEditingController();
  final restaurantNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  final facebookCtrl = TextEditingController();
  final instaCtrl = TextEditingController();

  String get token => box.read('auth_token') ?? '';

  // -------------------- PICK MAIN IMAGE --------------------
  Future<void> pickRestaurantImage() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) restaurantImage.value = File(image.path);
  }

  // -------------------- PICK ADDITIONAL IMAGES --------------------
  Future<void> pickAdditionalImages() async {
    final List<XFile>? images =
    await picker.pickMultiImage(imageQuality: 70);
    if (images != null) {
      additionalImages.addAll(images.map((e) => File(e.path)));
    }
  }

  // -------------------- FILE TO BASE64 --------------------
  Future<String> _fileToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  // -------------------- SUBMIT --------------------
  Future<void> submit() async {
    if (token.isEmpty) {
      Get.snackbar(
        "Session Expired",
        "Please login again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (restaurantImage.value == null ||
        ownerCtrl.text.trim().isEmpty ||
        restaurantNameCtrl.text.trim().isEmpty ||
        addressCtrl.text.trim().isEmpty ||
        phoneCtrl.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all mandatory fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final mainImage = await _fileToBase64(restaurantImage.value!);

      final List<String> additionalBase64 = [];
      for (var img in additionalImages) {
        additionalBase64.add(await _fileToBase64(img));
      }

      final request = RestaurantRegisterRequest(
        ownerName: ownerCtrl.text.trim(),
        restaurantName: restaurantNameCtrl.text.trim(),
        address: addressCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        website: websiteCtrl.text.trim(),
        whatsapp: whatsappCtrl.text.trim(),
        facebook: facebookCtrl.text.trim(),
        instagram: instaCtrl.text.trim(),
        restaurantImage: mainImage,
        additionalImages: additionalBase64,
      );

      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/restaurant/register"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(request.toJson()),
      );

      debugPrint("Register Status: ${response.statusCode}");
      debugPrint("Register Body: ${response.body}");

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          (data['status'] == "1" || data['status'] == true)) {

        // ✅ Save restaurant_id to GetStorage so MenuController can use it
        final dynamic rawId =
            data['data']?['id'] ?? data['data']?['restaurant_id'];
        if (rawId != null) {
          final int? parsedId =
          rawId is int ? rawId : int.tryParse(rawId.toString());
          if (parsedId != null) {
            box.write('restaurant_id', parsedId);
            debugPrint("✅ restaurant_id saved: $parsedId");
          }
        } else {
          debugPrint("⚠️ No restaurant_id in response: ${data['data']}");
        }

        Get.snackbar(
          "Success",
          data['message'] ?? "Restaurant registered successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ✅ Navigate to MenuManagementPage, remove reg page from stack
        Get.off(() => const MenuManagementPage());

      } else if (response.statusCode == 401) {
        Get.snackbar(
          "Unauthorized",
          "Session expired. Please login again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Failed to register restaurant",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint("Submit Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    ownerCtrl.dispose();
    restaurantNameCtrl.dispose();
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