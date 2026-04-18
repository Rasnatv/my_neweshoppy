

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../merchantlogin/widget/successwidget.dart';
import '../../../data/errors/api_error.dart';
import 'merchant_advertismentlistcontroller.dart';

class MerchantAdvertisementController extends GetxController {
  final adNameController = TextEditingController();
  final bannerImage = Rx<File?>(null);

  final isLoading = false.obs;
  final picker = ImagePicker();
  final box = GetStorage();

  late String authToken;

  final stateList    = <String>[].obs;
  final districtList = <String>[].obs;
  final areaList     = <String>[].obs;

  final isLoadingStates    = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas     = false.obs;

  final selectedState    = Rx<String?>(null);
  final selectedDistrict = Rx<String?>(null);
  final selectedArea     = Rx<String?>(null);

  final showMode = "district".obs;

  // ── API URLS ──────────────────────────────────────────────
  final String statesUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant/states";
  final String districtsUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/districts";
  final String areasUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/areas";
  final String apiUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/advertisement";

  // ── LIFECYCLE ─────────────────────────────────────────────
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

  // ── FETCH STATES ──────────────────────────────────────────
  Future<void> fetchStates() async {
    isLoadingStates.value = true;
    try {
      final response = await http.get(
        Uri.parse(statesUrl),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'];
        if ((status == true || status == 1) && data['data'] != null) {
          stateList.assignAll(List<String>.from(data['data']));
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingStates.value = false;
    }
  }

  // ── FETCH DISTRICTS ───────────────────────────────────────
  Future<void> fetchDistricts() async {
    isLoadingDistricts.value = true;
    try {
      final response = await http.get(
        Uri.parse(districtsUrl),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          districtList.assignAll(List<String>.from(data['data']));
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ── FETCH AREAS ───────────────────────────────────────────
  Future<void> fetchAreas() async {
    isLoadingAreas.value = true;
    try {
      final response = await http.get(
        Uri.parse(areasUrl),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true && data['data'] != null) {
          areaList.assignAll(List<String>.from(data['data']));
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingAreas.value = false;
    }
  }

  Future<void> pickBanner() async {
    try {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      final file = File(picked.path);

      // ✅ Decode image to get actual width & height
      final bytes = await file.readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);

      final width  = decodedImage.width;
      final height = decodedImage.height;
      final ratio  = width / height;

      debugPrint(">>> Image size: ${width}x${height}, ratio: $ratio");

      // ✅ Allow only 2:1 ratio (small tolerance ±0.1)
      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbar.error(
          "Invalid image ratio ${width}x${height}.\nPlease upload a 2:1 ratio image (e.g. 1200x600)",
        );
        return;
      }

      // ✅ Ratio is correct — set directly, no cropper needed
      bannerImage.value = File(picked.path);

    } catch (e) {
      AppSnackbar.error("Image error: $e");
    }
  }

  // ── REMOVE BANNER ─────────────────────────────────────────
  void removeBanner() => bannerImage.value = null;

  // ── IMAGE → BASE64 ────────────────────────────────────────
  Future<String?> _toBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return "data:image/jpeg;base64,${base64Encode(bytes)}";
    } catch (e) {
      return null;
    }
  }
  Future<void> postAdvertisement() async {
    if (adNameController.text.trim().isEmpty) {
      return AppSnackbar.error("Enter advertisement name");
    }
    if (bannerImage.value == null) {
      return AppSnackbar.error("Upload banner image");
    }
    if (selectedState.value == null) {
      return AppSnackbar.error("Select a state");
    }
    if (selectedDistrict.value == null) {
      return AppSnackbar.error("Select a district");
    }
    if (showMode.value == "area" && selectedArea.value == null) {
      return AppSnackbar.error("Select an area");
    }

    isLoading.value = true;

    try {
      final base64Image = await _toBase64(bannerImage.value!);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "advertisement": adNameController.text.trim(),
          "banner_image": base64Image,
          "state": selectedState.value,
          "district": selectedDistrict.value,
          "main_location":
          showMode.value == "area" ? (selectedArea.value ?? "") : "",
        }),
      );

      final message = ApiErrorHandler.handleResponse(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data["status"] == "1" || data["status"] == 1) {
          /// ✅ 🔥 REFRESH LIST HERE
          if (Get.isRegistered<MerchantAdvertisementGetController>()) {
            Get.find<MerchantAdvertisementGetController>()
                .fetchAdvertisements();
          }

          _clearForm();
          AppSnackbar.success(data["message"] ?? "Advertisement posted");

          await Future.delayed(const Duration(milliseconds: 800));
          Get.back();
        } else {
          AppSnackbar.error(data["message"] ?? message);
        }
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ── CLEAR FORM ────────────────────────────────────────────
  void _clearForm() {
    adNameController.clear();
    bannerImage.value    = null;
    selectedState.value    = null;
    selectedDistrict.value = null;
    selectedArea.value     = null;
    showMode.value         = "district";
  }
}