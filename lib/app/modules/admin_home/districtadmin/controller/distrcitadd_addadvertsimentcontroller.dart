//
// import 'dart:convert';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// // TODO: Replace with your actual district admin home page import
// // import '../view/district_adminhome.dart';
//
// class DistrictAdminAdvertisementController extends GetxController {
//
//   // ─── Controllers ─────────────────────────────
//   final TextEditingController adName = TextEditingController();
//
//   // ─── Observables ─────────────────────────────
//   final Rx<File?> bannerImage = Rx<File?>(null);
//   final RxBool isLoading = false.obs;
//   final RxBool isTitleEmpty = false.obs;
//
//   // Districts are plain strings from the API: ["kasaragod", "mram"]
//   final RxList<String> districts = <String>[].obs;
//   final RxString selectedDistrict = ''.obs;
//   final RxBool isDistrictLoading = false.obs;
//
//   final _box = GetStorage();
//   final _picker = ImagePicker();
//
//   static const String baseUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api/district-admin';
//
//   // ─── Token ──────────────────────────────────
//   String get token => _box.read('auth_token') ?? '';
//
//   Map<String, String> get headers => {
//     'Authorization': 'Bearer $token',
//     'Accept': 'application/json',
//   };
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchDistricts();
//   }
//
//   // ─── Fetch Districts ──────────────────────────
//   // API response: { "status": true, "data": ["kasaragod", "mram"] }
//   Future<void> fetchDistricts() async {
//     if (token.isEmpty) {
//       _handleUnauthorized();
//       return;
//     }
//
//     try {
//       isDistrictLoading.value = true;
//
//       final res = await http.get(
//         Uri.parse('$baseUrl/districts'),
//         headers: headers,
//       );
//
//       final body = jsonDecode(res.body);
//
//       if (res.statusCode == 200 && body['status'] == true) {
//         // API returns a plain List<String>: ["kasaragod", "mram"]
//         final List<dynamic> data = body['data'] as List;
//         districts.assignAll(data.map((e) => e.toString()).toList());
//       } else if (res.statusCode == 401) {
//         _handleUnauthorized();
//       } else {
//         _showError(body['message'] ?? 'Failed to load districts');
//       }
//     } catch (e) {
//       _showError(e.toString());
//     } finally {
//       isDistrictLoading.value = false;
//     }
//   }
//
//   // ─── Image Picker ───────────────────────────
//   Future<void> pickBannerImage() async {
//     final file = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//     );
//
//     if (file != null) {
//       bannerImage.value = File(file.path);
//     }
//   }
//
//   void removeBannerImage() {
//     bannerImage.value = null;
//   }
//
//   // ─── Validation ─────────────────────────────
//   bool validate() {
//     if (adName.text.trim().isEmpty) {
//       isTitleEmpty.value = true;
//       _showError("Enter advertisement title");
//       return false;
//     } else if (selectedDistrict.value.isEmpty) {
//       _showError("Select a district");
//       return false;
//     } else if (bannerImage.value == null) {
//       _showError("Select banner image");
//       return false;
//     }
//     return true;
//   }
//
//   // ─── Add Advertisement API ──────────────────
//   // API expects: { "advertisement": "...", "district": "mram", "banner_image": "data:image/png;base64,..." }
//   // API responds with status_code 201 on success
//   Future<void> addAdvertisement() async {
//     if (!validate()) return;
//
//     if (token.isEmpty) {
//       _handleUnauthorized();
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final bytes = await bannerImage.value!.readAsBytes();
//       final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
//
//       final body = {
//         "advertisement": adName.text.trim(),
//         "district": selectedDistrict.value,   // plain string district name
//         "banner_image": base64Image,
//       };
//
//       final response = await http.post(
//         Uri.parse('$baseUrl/create-advertisement'),
//         headers: {
//           ...headers,
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(body),
//       );
//
//       final resData = jsonDecode(response.body);
//
//       // API returns status_code 201 on success
//       if ((response.statusCode == 200 || response.statusCode == 201) &&
//           resData['status'] == true) {
//
//         Get.snackbar(
//           "Success",
//           resData['message'] ?? "Advertisement created",
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//
//         resetForm();
//
//         // 🔥 Navigate Home — uncomment and replace with your district admin home page
//         // Get.offAll(() => DistrictAdminHomePage());
//
//       } else if (response.statusCode == 401) {
//         _handleUnauthorized();
//       } else {
//         _showError(resData['message'] ?? "Failed to create advertisement");
//       }
//     } catch (e) {
//       _showError(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ─── Reset ─────────────────────────────────
//   void resetForm() {
//     adName.clear();
//     selectedDistrict.value = '';
//     bannerImage.value = null;
//     isTitleEmpty.value = false;
//   }
//
//   // ─── Helpers ────────────────────────────────
//   void _showError(String msg) {
//     Get.snackbar(
//       "Error",
//       msg,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }
//
//   void _handleUnauthorized() {
//     Get.snackbar("Session Expired", "Please login again");
//     _box.erase();
//     // Get.offAll(() => LoginPage());
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../view/districtadmin_home.dart';
import 'districtadminadvertismentgetcontroller.dart'; // ← import get controller

class DistrictAdminAdvertisementController extends GetxController {

  // ─── Controllers ─────────────────────────────
  final TextEditingController adName = TextEditingController();

  // ─── Observables ─────────────────────────────
  final Rx<File?> bannerImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isTitleEmpty = false.obs;

  // Districts are plain strings from the API: ["kasaragod", "mram"]
  final RxList<String> districts = <String>[].obs;
  final RxString selectedDistrict = ''.obs;
  final RxBool isDistrictLoading = false.obs;

  final _box = GetStorage();
  final _picker = ImagePicker();

  static const String baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/district-admin';

  // ─── Token ──────────────────────────────────
  String get token => _box.read('auth_token') ?? '';

  Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchDistricts();
  }

  // ─── Fetch Districts ──────────────────────────
  Future<void> fetchDistricts() async {
    if (token.isEmpty) {
      _handleUnauthorized();
      return;
    }

    try {
      isDistrictLoading.value = true;

      final res = await http.get(
        Uri.parse('$baseUrl/districts'),
        headers: headers,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        final List<dynamic> data = body['data'] as List;
        districts.assignAll(data.map((e) => e.toString()).toList());
      } else if (res.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError(body['message'] ?? 'Failed to load districts');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isDistrictLoading.value = false;
    }
  }

  // ─── Image Picker ───────────────────────────
  Future<void> pickBannerImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      bannerImage.value = File(file.path);
    }
  }

  void removeBannerImage() {
    bannerImage.value = null;
  }

  // ─── Validation ─────────────────────────────
  bool validate() {
    if (adName.text.trim().isEmpty) {
      isTitleEmpty.value = true;
      _showError("Enter advertisement title");
      return false;
    } else if (selectedDistrict.value.isEmpty) {
      _showError("Select a district");
      return false;
    } else if (bannerImage.value == null) {
      _showError("Select banner image");
      return false;
    }
    return true;
  }

  // ─── Add Advertisement API ──────────────────
  Future<void> addAdvertisement() async {
    if (!validate()) return;

    if (token.isEmpty) {
      _handleUnauthorized();
      return;
    }

    try {
      isLoading.value = true;

      final bytes = await bannerImage.value!.readAsBytes();
      final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';

      final body = {
        "advertisement": adName.text.trim(),
        "district": selectedDistrict.value,
        "banner_image": base64Image,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/create-advertisement'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final resData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          resData['status'] == true) {

        // ✅ Show success snackbar
        Get.snackbar(
          "Success",
          resData['message'] ?? "Advertisement created",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // ✅ Refresh home list so new ad appears immediately
        if (Get.isRegistered<DistrictAdminAdvertisementGetController>()) {
          Get.find<DistrictAdminAdvertisementGetController>()
              .fetchAdvertisements();
        }

        resetForm();

        // ✅ Navigate back to home
        Get.offAll(()=>Districtadminhomepage());

      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError(resData['message'] ?? "Failed to create advertisement");
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Reset ─────────────────────────────────
  void resetForm() {
    adName.clear();
    selectedDistrict.value = '';
    bannerImage.value = null;
    isTitleEmpty.value = false;
  }

  // ─── Helpers ────────────────────────────────
  void _showError(String msg) {
    Get.snackbar(
      "Error",
      msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleUnauthorized() {
    Get.snackbar("Session Expired", "Please login again");
    _box.erase();
    // Get.offAll(() => LoginPage());
  }
}