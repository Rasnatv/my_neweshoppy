
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
  final bannerImage      = Rx<File?>(null);

  final isLoading = false.obs;
  final picker    = ImagePicker();
  final box       = GetStorage();

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

  // Add these to MerchantAdvertisementController
  var errorBanner   = Rx<String?>(null);
  var errorState    = Rx<String?>(null);
  var errorDistrict = Rx<String?>(null);
  var errorArea     = Rx<String?>(null);

  final showMode = "district".obs;

  final String statesUrl    = "https://eshoppy.co.in/api/get-states";
  final String districtsUrl = "https://eshoppy.co.in/api/districts";
  final String areasUrl     = "https://eshoppy.co.in/api/areas";
  final String apiUrl       = "https://eshoppy.co.in/api/advertisement";

  @override
  void onInit() {
    super.onInit();
    authToken = box.read("auth_token") ?? "";
    fetchStates();

    // State changed → reset & reload districts
    ever(selectedState, (val) {
      selectedDistrict.value = null;
      selectedArea.value     = null;
      districtList.clear();
      areaList.clear();
      if (val != null) fetchDistricts(val);
    });

    // District changed → reset & reload areas (only in area mode)
    ever(selectedDistrict, (val) {
      selectedArea.value = null;
      areaList.clear();
      if (val != null && showMode.value == "area") fetchAreas(val);
    });

    // Mode switched to "area" → load areas if district already selected
    ever(showMode, (mode) {
      if (mode == "area" &&
          selectedDistrict.value != null &&
          areaList.isEmpty) {
        fetchAreas(selectedDistrict.value!);
      }
      // Switched back to district → clear area selection
      if (mode == "district") {
        selectedArea.value = null;
        areaList.clear();
      }
    });
  }

  @override
  void onClose() {
    adNameController.dispose();
    super.onClose();
  }

  // ── FETCH STATES (GET, no params) ─────────────────────────
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
        final data   = jsonDecode(response.body);
        final status = data['status'].toString();
        if ((status == "true" || status == "1") && data['data'] != null) {
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

  // ── FETCH DISTRICTS (POST, requires state) ────────────────
  Future<void> fetchDistricts(String state) async {
    isLoadingDistricts.value = true;
    try {
      final response = await http.post(
        Uri.parse(districtsUrl),
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"state": state}),
      );
      if (response.statusCode == 200) {
        final data   = jsonDecode(response.body);
        final status = data['status'].toString();
        if ((status == "true" || status == "1") && data['data'] != null) {
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

  // ── FETCH AREAS (POST, requires district) ─────────────────
  Future<void> fetchAreas(String district) async {
    isLoadingAreas.value = true;
    try {
      final response = await http.post(
        Uri.parse(areasUrl),
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"district": district}),
      );
      if (response.statusCode == 200) {
        final data   = jsonDecode(response.body);
        final status = data['status'].toString();
        if ((status == "true" || status == "1") && data['data'] != null) {
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

  // ── PICK BANNER ───────────────────────────────────────────
  Future<void> pickBanner() async {
    try {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;

      final file  = File(picked.path);
      final bytes = await file.readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);

      final width  = decodedImage.width;
      final height = decodedImage.height;
      final ratio  = width / height;

      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbar.error(
          "Invalid ratio ${width}x${height}. Please upload a 2:1 image (e.g. 1200x600)",
        );
        return;
      }

      bannerImage.value = file;
    } catch (e) {
      AppSnackbar.error("Image error: $e");
    }
  }

  void removeBanner() {
    bannerImage.value = null;
    errorBanner.value = "Please select a banner image";
  }

  Future<String?> _toBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return "data:image/jpeg;base64,${base64Encode(bytes)}";
    } catch (_) {
      return null;
    }
  }

  // ── POST ADVERTISEMENT ────────────────────────────────────
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

      final data   = jsonDecode(response.body);
      final status = data['status'].toString();

      if (status == "1" || status == "true") {
        if (Get.isRegistered<MerchantAdvertisementGetController>()) {
          Get.find<MerchantAdvertisementGetController>().fetchAdvertisements();
        }
        _clearForm();
        AppSnackbar.success(data["message"] ?? "Advertisement posted");
        await Future.delayed(const Duration(milliseconds: 800));
        Get.back();
      } else {
        AppSnackbar.error(data["message"] ?? "Something went wrong");
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
    bannerImage.value      = null;
    selectedState.value    = null;
    selectedDistrict.value = null;
    selectedArea.value     = null;
    districtList.clear();
    areaList.clear();
    showMode.value = "district";
  }
}