import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../view/districtadmin_home.dart';
import 'districtadminadvertismentgetcontroller.dart';

class AdvertisementUpdateController extends GetxController {
  final box = GetStorage();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final advertisementController = TextEditingController();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool isFetching = false.obs;
  final RxString districtName = ''.obs;
  final RxString bannerImageUrl = ''.obs;
  final RxString base64Image = ''.obs;
  final Rx<File?> pickedImageFile = Rx<File?>(null);

  // Advertisement ID (passed via navigation)
  late int advertisementId;

  final ImagePicker _picker = ImagePicker();

  // API Base URL
  static const String _baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/district-admin';

  /// Get auth token from storage
  String get authToken => box.read('auth_token') ?? '';


  @override
  void onInit() {
    super.onInit();
    // ✅ Read as String first, then parse to int
    final rawId = Get.arguments?['advertisement_id']?.toString() ?? '0';
    advertisementId = int.tryParse(rawId) ?? 0;
    if (advertisementId != 0) {
      fetchAdvertisementDetails();
    }
  }

  @override
  void onClose() {
    advertisementController.dispose();
    super.onClose();
  }

  // ─── FETCH ADVERTISEMENT ────────────────────────────────────────────────────

  Future<void> fetchAdvertisementDetails() async {
    isFetching.value = true;
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/advertisement'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'advertisement_id': advertisementId}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final ad = data['data'];
        advertisementController.text = ad['advertisement'] ?? '';
        districtName.value = ad['district'] ?? '';
        bannerImageUrl.value = ad['banner_image'] ?? '';
      } else {
        _showError(data['message'] ?? 'Failed to fetch advertisement');
      }
    } catch (e) {
      _showError('Network error: ${e.toString()}');
    } finally {
      isFetching.value = false;
    }
  }

  // ─── PICK IMAGE ─────────────────────────────────────────────────────────────

  Future<void> pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      pickedImageFile.value = File(image.path);
      final bytes = await File(image.path).readAsBytes();
      final mimeType = image.mimeType ?? 'image/png';
      base64Image.value = 'data:$mimeType;base64,${base64Encode(bytes)}';
    }
  }

  Future<void> captureImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (image != null) {
      pickedImageFile.value = File(image.path);
      final bytes = await File(image.path).readAsBytes();
      final mimeType = image.mimeType ?? 'image/png';
      base64Image.value = 'data:$mimeType;base64,${base64Encode(bytes)}';
    }
  }

  void removeImage() {
    pickedImageFile.value = null;
    base64Image.value = '';
  }

  // ─── UPDATE ADVERTISEMENT ───────────────────────────────────────────────────
  Future<void> updateAdvertisement() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        'advertisement_id': advertisementId,
        'advertisement': advertisementController.text.trim(),
        'district': districtName.value,
      };

      if (base64Image.value.isNotEmpty) {
        body['banner_image'] = base64Image.value;
      }

      final response = await http.put(
        Uri.parse('$_baseUrl/advertisement/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        _showSuccess(data['message'] ?? 'Advertisement updated successfully');

        Future.delayed(const Duration(milliseconds: 1500), () {
          // ✅ Call it properly with ()
          if (Get.isRegistered<DistrictAdminAdvertisementGetController>()) {
            Get.find<DistrictAdminAdvertisementGetController>()
                .fetchAdvertisements(); // ✅ () added
          }
          // ✅ Go BACK to existing home page, not push a new one
          Get.offAll(Districtadminhomepage());
        });
      } else {
        _showError(data['message'] ?? 'Update failed');
      }
    } catch (e) {
      _showError('Network error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> updateAdvertisement() async {
  //   if (!formKey.currentState!.validate()) return;
  //
  //   isLoading.value = true;
  //   try {
  //     final Map<String, dynamic> body = {
  //       'advertisement_id': advertisementId,
  //       'advertisement': advertisementController.text.trim(),
  //       'district': districtName.value,
  //     };
  //
  //     // Only attach image if a new one is picked
  //     if (base64Image.value.isNotEmpty) {
  //       body['banner_image'] = base64Image.value;
  //     }
  //
  //     final response = await http.put(
  //       Uri.parse('$_baseUrl/advertisement/update'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $authToken',
  //       },
  //       body: jsonEncode(body),
  //     );
  //
  //     final data = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && data['status'] == true) {
  //       _showSuccess(data['message'] ?? 'Advertisement updated successfully');
  //
  //           // ✅ Directly trigger fetchEvents on the list controller before going back
  //           Future.delayed(const Duration(milliseconds: 1500), () {
  //             // ✅ Trigger full home refresh before going back
  //             if (Get.isRegistered<DistrictAdminAdvertisementGetController>()){
  //               Get.find<DistrictAdminAdvertisementGetController>().fetchAdvertisements;
  //             }
  //
  //   Get.toNamed('/districtadminhome');}
  //             );
  //     } else {
  //       _showError(data['message'] ?? 'Update failed');
  //     }
  //   } catch (e) {
  //     _showError('Network error: ${e.toString()}');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // ─── HELPERS ────────────────────────────────────────────────────────────────

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: const Color(0xFFFF4D4D),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: const Color(0xFF22C55E),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    );
  }
}