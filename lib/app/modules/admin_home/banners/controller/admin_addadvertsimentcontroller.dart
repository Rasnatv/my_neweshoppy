
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../../data/errors/api_error.dart';
import '../../../merchantlogin/widget/successwidget.dart';
import '../views/adminadvertisment.dart';

class AdminaddAdvertisementController extends GetxController {
  final adNameController = TextEditingController();
  final bannerImage = Rx<File?>(null);

  final isLoading = false.obs;
  final picker = ImagePicker();
  final box = GetStorage();

  late String authToken;

  // Lists
  final stateList = <String>[].obs;
  final districtList = <String>[].obs;
  final areaList = <String>[].obs;

  // Loading flags
  final isLoadingStates = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas = false.obs;

  // Selected values
  final selectedState = Rx<String?>(null);
  final selectedDistrict = Rx<String?>(null);
  final selectedArea = Rx<String?>(null);

  final showMode = "district".obs;

  final String statesUrl =
      "https://eshoppy.co.in/api/get-states";
  final String districtsUrl =
      "https://eshoppy.co.in/api/districts";
  final String areasUrl =
      "https://eshoppy.co.in/api/areas";
  final String apiUrl =
      "https://eshoppy.co.in/api/advertisement";

  @override
  void onInit() {
    super.onInit();

    authToken = box.read("auth_token") ?? "";

    fetchStates();
    fetchDistricts();
    fetchAreas();
  }

  @override
  void onClose() {
    adNameController.dispose();
    super.onClose();
  }

  // ── COMMON HEADERS ─────────────────────────────
  Map<String, String> get headers => {
    "Authorization": "Bearer $authToken",
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  // ── FETCH STATES ───────────────────────────────
  Future<void> fetchStates() async {
    isLoadingStates.value = true;

    try {
      final res = await http.get(Uri.parse(statesUrl), headers: headers);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if ((data['status'] == true || data['status'] == 1) &&
            data['data'] != null) {
          stateList.assignAll(List<String>.from(data['data']));
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ── FETCH DISTRICTS ────────────────────────────
  Future<void> fetchDistricts() async {
    isLoadingDistricts.value = true;

    try {
      final res = await http.get(Uri.parse(districtsUrl), headers: headers);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == true && data['data'] != null) {
          districtList.assignAll(List<String>.from(data['data']));
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ── FETCH AREAS ────────────────────────────────
  Future<void> fetchAreas() async {
    isLoadingAreas.value = true;

    try {
      final res = await http.get(Uri.parse(areasUrl), headers: headers);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == true && data['data'] != null) {
          areaList.assignAll(List<String>.from(data['data']));
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingAreas.value = false;
    }
  }

  // ── PICK IMAGE ────────────────────────────────
  Future<void> pickBanner() async {
    try {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      final file = File(picked.path);

      final bytes = await file.readAsBytes();
      final decoded = await decodeImageFromList(bytes);

      final ratio = decoded.width / decoded.height;

      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbar.warning(
            "Invalid ratio ${decoded.width}x${decoded.height}\nUse 2:1 image");
        return;
      }

      bannerImage.value = file;
    } catch (e) {
      AppSnackbar.error("Image error");
    }
  }

  void removeBanner() => bannerImage.value = null;

  // ── BASE64 ────────────────────────────────────
  Future<String?> _toBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return "data:image/jpeg;base64,${base64Encode(bytes)}";
    } catch (_) {
      return null;
    }
  }

  // ── POST AD ───────────────────────────────────
  Future<void> postAdvertisement() async {
    if (adNameController.text.trim().isEmpty) {
      return AppSnackbar.warning("Enter advertisement name");
    }
    if (bannerImage.value == null) {
      return AppSnackbar.warning("Upload banner image");
    }
    if (selectedState.value == null) {
      return AppSnackbar.warning("Select state");
    }
    if (selectedDistrict.value == null) {
      return AppSnackbar.warning("Select district");
    }
    if (showMode.value == "area" && selectedArea.value == null) {
      return AppSnackbar.warning("Select area");
    }

    isLoading.value = true;

    try {
      final base64Image = await _toBase64(bannerImage.value!);

      final body = {
        "advertisement": adNameController.text.trim(),
        "banner_image": base64Image,
        "state": selectedState.value,
        "district": selectedDistrict.value,
        "main_location":
        showMode.value == "area" ? selectedArea.value : "",
      };

      final res = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (data["status"] == "1" || data["status"] == 1) {
          _clearForm();
          AppSnackbar.success(
              data["message"] ?? "Advertisement added successfully");

         Get.back(result: true);
        } else {
          AppSnackbar.error(data["message"] ?? "Failed");
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ── CLEAR ─────────────────────────────────────
  void _clearForm() {
    adNameController.clear();
    bannerImage.value = null;
    selectedState.value = null;
    selectedDistrict.value = null;
    selectedArea.value = null;
    showMode.value = "district";
  }
}


