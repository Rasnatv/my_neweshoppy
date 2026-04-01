// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../data/models/updateadvertisment_merchnatmodel.dart';
//
//
// // ─────────────────────────────────────────────────────────────
// //  UpdateAdvertisementController
// // ─────────────────────────────────────────────────────────────
//
// class UpdateAdvertisementController extends GetxController {
//   // ── API endpoints ─────────────────────────────────────────
//   static const String _baseUrl =
//       'https://rasma.astradevelops.in/e_shoppyy/public/api';
//   static const String _getSingleAdUrl = '$_baseUrl/get-single-advertisement';
//   static const String _updateAdUrl = '$_baseUrl/update-advertisement';
//
//   // ── Storage ───────────────────────────────────────────────
//   final box = GetStorage();
//
//   // ── Form key ──────────────────────────────────────────────
//   final formKey = GlobalKey<FormState>();
//
//   // ── Text controller ───────────────────────────────────────
//   final advertisementController = TextEditingController();
//
//   // ── Observable state ──────────────────────────────────────
//   final Rx<updateAdvertisementModel?> advertisement = Rx<updateAdvertisementModel?>(null);
//   final RxBool isLoading = false.obs;
//   final RxBool isSubmitting = false.obs;
//   final RxString errorMessage = ''.obs;
//
//   // Banner image
//   final Rx<File?> pickedImageFile = Rx<File?>(null);
//   final RxString existingBannerUrl = ''.obs;
//   final RxString _base64Image = ''.obs;
//
//   bool get hasBannerChanged => pickedImageFile.value != null;
//
//   // ── Dynamic headers with Bearer token ─────────────────────
//   Map<String, String> get _headers => {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer ${box.read("auth_token") ?? ""}',
//   };
//
//   // ── Lifecycle ─────────────────────────────────────────────
//   @override
//   void onInit() {
//     super.onInit();
//     final dynamic args = Get.arguments;
//     if (args is Map && args.containsKey('advertisement_id')) {
//       fetchAdvertisement(args['advertisement_id'].toString());
//     } else if (Get.parameters['advertisement_id'] != null) {
//       fetchAdvertisement(Get.parameters['advertisement_id']!);
//     }
//   }
//
//   @override
//   void onClose() {
//     advertisementController.dispose();
//     super.onClose();
//   }
//
//   // ── Token guard ───────────────────────────────────────────
//   bool _checkToken() {
//     final token = box.read("auth_token") ?? "";
//     if (token.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Token missing. Please login again.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false;
//     }
//     return true;
//   }
//
//   // ── Fetch single advertisement ────────────────────────────
//   Future<void> fetchAdvertisement(String adId) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//
//     if (!_checkToken()) {
//       isLoading.value = false;
//       return;
//     }
//
//     try {
//       final response = await http.post(
//         Uri.parse(_getSingleAdUrl),
//         headers: _headers,
//         body: jsonEncode({'advertisement_id': int.parse(adId)}),
//       );
//
//       final decoded = _decodeResponse(response);
//       final adResponse = updateAdvertisementResponse.fromJson(decoded);
//
//       if (adResponse.isSuccess && adResponse.data != null) {
//         _populateFields(adResponse.data!);
//       } else {
//         errorMessage.value = adResponse.message.isNotEmpty
//             ? adResponse.message
//             : 'Failed to load advertisement.';
//       }
//     } on SocketException {
//       errorMessage.value = 'No internet connection. Please check your network.';
//     } catch (e) {
//       errorMessage.value = 'An unexpected error occurred: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ── Populate form from model ──────────────────────────────
//   void _populateFields(updateAdvertisementModel data) {
//     advertisement.value = data;
//     advertisementController.text = data.advertisement;
//     existingBannerUrl.value = data.bannerImage;
//   }
//
//   // ── Image picker ──────────────────────────────────────────
//   Future<void> pickBannerImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final XFile? xFile = await picker.pickImage(
//       source: source,
//       imageQuality: 80,
//       maxWidth: 1280,
//     );
//
//     if (xFile != null) {
//       pickedImageFile.value = File(xFile.path);
//       final bytes = await File(xFile.path).readAsBytes();
//       final ext = xFile.path.split('.').last.toLowerCase();
//       final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
//       _base64Image.value = 'data:$mimeType;base64,${base64Encode(bytes)}';
//     }
//   }
//
//   void showImagePickerOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading:
//               const Icon(Icons.photo_camera, color: Color(0xFF00BFA5)),
//               title: const Text('Camera',
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               onTap: () {
//                 Get.back();
//                 pickBannerImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading:
//               const Icon(Icons.photo_library, color: Color(0xFF00BFA5)),
//               title: const Text('Gallery',
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               onTap: () {
//                 Get.back();
//                 pickBannerImage(ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ── Validation ────────────────────────────────────────────
//   String? validateRequired(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }
//     return null;
//   }
//
//   // ── Submit update ─────────────────────────────────────────
//   Future<void> updateAdvertisement() async {
//     if (!formKey.currentState!.validate()) return;
//     if (!_checkToken()) return;
//
//     isSubmitting.value = true;
//     errorMessage.value = '';
//
//     try {
//       final payload = <String, dynamic>{
//         'advertisement_id': int.parse(advertisement.value!.id),
//         'advertisement': advertisementController.text.trim(),
//         if (hasBannerChanged) 'banner_image': _base64Image.value,
//       };
//
//       final response = await http.put(
//         Uri.parse(_updateAdUrl),
//         headers: _headers,
//         body: jsonEncode(payload),
//       );
//
//       final decoded = _decodeResponse(response);
//       final adResponse = updateAdvertisementResponse.fromJson(decoded);
//
//       if (adResponse.isSuccess && adResponse.data != null) {
//         _populateFields(adResponse.data!);
//         pickedImageFile.value = null;
//
//         Get.snackbar(
//           'Success',
//           adResponse.message,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: const Color(0xFF00BFA5),
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//         );
//
//         Get.back();
//       } else {
//         errorMessage.value = adResponse.message.isNotEmpty
//             ? adResponse.message
//             : 'Failed to update advertisement.';
//         Get.snackbar(
//           'Error',
//           errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } on SocketException {
//       errorMessage.value = 'No internet connection.';
//       Get.snackbar('Network Error', errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     } catch (e) {
//       errorMessage.value = 'An unexpected error occurred: $e';
//       Get.snackbar('Error', errorMessage.value,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
//
//   // ── Decode HTTP response ──────────────────────────────────
//   Map<String, dynamic> _decodeResponse(http.Response response) {
//     if (response.statusCode != 200) {
//       throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
//     }
//     return jsonDecode(response.body) as Map<String, dynamic>;
//   }
// }
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/updateadvertisment_merchnatmodel.dart';

// ─────────────────────────────────────────────────────────────
//  UpdateAdvertisementController
// ─────────────────────────────────────────────────────────────

class UpdateAdvertisementController extends GetxController {
  // ── API endpoints ─────────────────────────────────────────
  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';
  static const String _getSingleAdUrl = '$_baseUrl/get-single-advertisement';
  static const String _updateAdUrl = '$_baseUrl/update-advertisement';

  // ── Storage ───────────────────────────────────────────────
  final box = GetStorage();

  // ── Form key ──────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();

  // ── Text controller ───────────────────────────────────────
  final advertisementController = TextEditingController();

  // ── Observable state ──────────────────────────────────────
  final Rx<updateAdvertisementModel?> advertisement =
  Rx<updateAdvertisementModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  // Banner image
  final Rx<File?> pickedImageFile = Rx<File?>(null);
  final RxString existingBannerUrl = ''.obs;
  final RxString _base64Image = ''.obs;

  bool get hasBannerChanged => pickedImageFile.value != null;

  // ── Dynamic headers with Bearer token ─────────────────────
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${box.read("auth_token") ?? ""}',
  };

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    if (args is Map && args.containsKey('advertisement_id')) {
      fetchAdvertisement(args['advertisement_id'].toString());
    } else if (Get.parameters['advertisement_id'] != null) {
      fetchAdvertisement(Get.parameters['advertisement_id']!);
    }
  }

  @override
  void onClose() {
    advertisementController.dispose();
    super.onClose();
  }

  // ── Token guard ───────────────────────────────────────────
  bool _checkToken() {
    final token = box.read("auth_token") ?? "";
    if (token.isEmpty) {
      Get.snackbar(
        "Error",
        "Token missing. Please login again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  // ── Fetch single advertisement ────────────────────────────
  Future<void> fetchAdvertisement(String adId) async {
    isLoading.value = true;
    errorMessage.value = '';

    if (!_checkToken()) {
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_getSingleAdUrl),
        headers: _headers,
        body: jsonEncode({'advertisement_id': int.parse(adId)}),
      );

      final decoded = _decodeResponse(response);
      final adResponse = updateAdvertisementResponse.fromJson(decoded);

      if (adResponse.isSuccess && adResponse.data != null) {
        _populateFields(adResponse.data!);
      } else {
        errorMessage.value = adResponse.message.isNotEmpty
            ? adResponse.message
            : 'Failed to load advertisement.';
      }
    } on SocketException {
      errorMessage.value =
      'No internet connection. Please check your network.';
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Populate form from model ──────────────────────────────
  void _populateFields(updateAdvertisementModel data) {
    advertisement.value = data;
    advertisementController.text = data.advertisement;
    existingBannerUrl.value = data.bannerImage;
    // district and mainLocation are read from advertisement.value directly
  }

  // ── Image picker ──────────────────────────────────────────
  Future<void> pickBannerImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? xFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1280,
    );

    if (xFile != null) {
      pickedImageFile.value = File(xFile.path);
      final bytes = await File(xFile.path).readAsBytes();
      final ext = xFile.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
      _base64Image.value = 'data:$mimeType;base64,${base64Encode(bytes)}';
    }
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading:
              const Icon(Icons.photo_camera, color: Color(0xFF00BFA5)),
              title: const Text('Camera',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Get.back();
                pickBannerImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading:
              const Icon(Icons.photo_library, color: Color(0xFF00BFA5)),
              title: const Text('Gallery',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Get.back();
                pickBannerImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Validation ────────────────────────────────────────────
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // ── Submit update ─────────────────────────────────────────
  Future<void> updateAdvertisement() async {
    if (!formKey.currentState!.validate()) return;
    if (!_checkToken()) return;

    isSubmitting.value = true;
    errorMessage.value = '';

    try {
      final ad = advertisement.value!;

      final payload = <String, dynamic>{
        'advertisement_id': int.parse(ad.id),
        'advertisement': advertisementController.text.trim(),
        // Always send district & main_location back as-is (read-only)
        'district': ad.district ?? '',
        'main_location': ad.mainLocation ?? '',
        if (hasBannerChanged) 'banner_image': _base64Image.value,
      };

      final response = await http.put(
        Uri.parse(_updateAdUrl),
        headers: _headers,
        body: jsonEncode(payload),
      );

      final decoded = _decodeResponse(response);
      final adResponse = updateAdvertisementResponse.fromJson(decoded);

      if (adResponse.isSuccess && adResponse.data != null) {
        _populateFields(adResponse.data!);
        pickedImageFile.value = null;

        Get.snackbar(
          'Success',
          adResponse.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF00BFA5),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        Get.back();
      } else {
        errorMessage.value = adResponse.message.isNotEmpty
            ? adResponse.message
            : 'Failed to update advertisement.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on SocketException {
      errorMessage.value = 'No internet connection.';
      Get.snackbar('Network Error', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      Get.snackbar('Error', errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isSubmitting.value = false;
    }
  }

  // ── Decode HTTP response ──────────────────────────────────
  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}