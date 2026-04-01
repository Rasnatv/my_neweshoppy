import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminaddAdvertisementController extends GetxController {
  // ─── State ───────────────────────────────────────────────
  var isLoading    = false.obs;
  var isTitleEmpty = false.obs;

  // ─── Form Controllers ────────────────────────────────────
  final adTitle = TextEditingController();

  // ─── Banner Image ────────────────────────────────────────
  final bannerImage = Rx<File?>(null);

  // ─── Storage & Picker ────────────────────────────────────
  final box    = GetStorage();
  final picker = ImagePicker();

  // ─── District & Area ─────────────────────────────────────
  final districts          = <String>[].obs;
  final areas              = <String>[].obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas     = false.obs;

  // 'district' | 'area' | null
  final locationType     = Rx<String?>(null);
  final selectedDistrict = Rx<String?>(null);
  final selectedArea     = Rx<String?>(null);

  // ─── Auth token helper ────────────────────────────────────
  String get _token => box.read('auth_token')?.toString().trim() ?? '';

  Map<String, String> get _headers => {
    'Accept': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  // ─── Lifecycle ────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchDistricts();
    fetchAreas();
  }

  @override
  void onClose() {
    adTitle.dispose();
    super.onClose();
  }

  // ─── Set location type (toggle) ───────────────────────────
  void setLocationType(String type) {
    // Tapping the same toggle again deselects it
    if (locationType.value == type) {
      locationType.value     = null;
      selectedDistrict.value = null;
      selectedArea.value     = null;
    } else {
      locationType.value     = type;
      selectedDistrict.value = null;
      selectedArea.value     = null;
    }
  }

  // ─── Fetch Districts ──────────────────────────────────────
  Future<void> fetchDistricts() async {
    isLoadingDistricts.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/districts'),
        headers: _headers,
      );
      final body = jsonDecode(response.body);
      if (body['status'] == true && body['data'] != null) {
        districts.value = List<String>.from(body['data']);
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to load districts',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ─── Fetch Areas ──────────────────────────────────────────
  Future<void> fetchAreas() async {
    isLoadingAreas.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/areas'),
        headers: _headers,
      );
      final body = jsonDecode(response.body);
      if (body['status'] == true && body['data'] != null) {
        areas.value = List<String>.from(body['data']);
      }
    } catch (_) {
      Get.snackbar('Error', 'Failed to load areas',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingAreas.value = false;
    }
  }

  // ─── Image Pick / Remove ──────────────────────────────────
  Future<void> pickBannerImage() async {
    final img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (img != null) bannerImage.value = File(img.path);
  }

  void removeBannerImage() => bannerImage.value = null;

  // ─── Add Advertisement ────────────────────────────────────
  Future<void> addAdvertisement() async {
    if (_token.isEmpty) {
      Get.snackbar('Session Expired', 'Please login again',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (bannerImage.value == null) {
      Get.snackbar('Validation', 'Please select a banner image',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // Convert image → base64
      final imgBytes  = await bannerImage.value!.readAsBytes();
      final imgBase64 = 'data:image/jpeg;base64,${base64Encode(imgBytes)}';

      // Build request body matching the API contract
      final body = {
        'advertisement': adTitle.text.trim(),
        'banner_image': imgBase64,
        'district': locationType.value == 'district'
            ? selectedDistrict.value ?? ''
            : '',
        'main_location':
        locationType.value == 'area' ? selectedArea.value ?? '' : '',
      };

      final response = await http.post(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/advertisement'),
        headers: {
          ..._headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final res = jsonDecode(response.body);

      if (res['status'].toString() == '1' ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        _clearForm();
        Get.back(result: true);
        Get.snackbar(
          'Success',
          res['message'] ?? 'Advertisement created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Error',
          res['message'] ?? 'Failed to create advertisement',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Clear Form ───────────────────────────────────────────
  void _clearForm() {
    adTitle.clear();
    bannerImage.value      = null;
    isTitleEmpty.value     = false;
    locationType.value     = null;
    selectedDistrict.value = null;
    selectedArea.value     = null;
  }
}