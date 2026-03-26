import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../view/area_adminhome.dart';

class AreaAdminAdvertisementController extends GetxController {

  // ─── Controllers ─────────────────────────────
  final TextEditingController adName = TextEditingController();

  // ─── Observables ─────────────────────────────
  final Rx<File?> bannerImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isTitleEmpty = false.obs;

  final RxList<String> locations = <String>[].obs;
  final RxString selectedLocation = ''.obs;
  final RxBool isLocationLoading = false.obs;

  final _box = GetStorage();
  final _picker = ImagePicker();

  static const String baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin';

  // ─── Token ──────────────────────────────────
  String get token => _box.read('auth_token') ?? '';

  Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  // ─── Fetch Locations (Same as Event) ─────────
  Future<void> fetchLocations() async {
    if (token.isEmpty) {
      _handleUnauthorized();
      return;
    }

    try {
      isLocationLoading.value = true;

      final res = await http.get(
        Uri.parse('$baseUrl/main-locations'),
        headers: headers,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        locations.assignAll(
            (body['data'] as List).map((e) => e.toString()).toList());
      } else if (res.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError(body['message'] ?? 'Failed to load locations');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLocationLoading.value = false;
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
    } else if (selectedLocation.value.isEmpty) {
      _showError("Select location");
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
      final base64Image =
          'data:image/png;base64,${base64Encode(bytes)}';

      final body = {
        "advertisement": adName.text.trim(),
        "main_location": selectedLocation.value,
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

      if (response.statusCode == 200 && resData['status'] == true) {

        Get.snackbar(
          "Success",
          resData['message'] ?? "Advertisement created",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        resetForm();

        // 🔥 Navigate Home
        Get.offAll(() => AreaAdminhomepage());

      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        _showError(resData['message'] ?? "Failed");
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
    selectedLocation.value = '';
    bannerImage.value = null;
    isTitleEmpty.value = false;
  }

  // ─── Error ─────────────────────────────────
  void _showError(String msg) {
    Get.snackbar(
      "Error",
      msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _handleUnauthorized() {
    Get.snackbar("Session Expired", "Login again");
    _box.erase();
    Get.offAll(() => AreaAdminhomepage());
  }
}