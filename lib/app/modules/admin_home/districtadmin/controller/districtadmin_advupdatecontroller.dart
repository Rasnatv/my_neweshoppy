
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';

import '../../../merchantlogin/widget/successwidget.dart';
import '../view/districtadmin_home.dart';
import 'districtadminadvertismentgetcontroller.dart';

class AdvertisementUpdateController extends GetxController {
  final box = GetStorage();

  final formKey = GlobalKey<FormState>();
  final advertisementController = TextEditingController();
  final Rx<File?> bannerImage       = Rx<File?>(null);

  final RxBool isLoading = false.obs;
  final RxBool isFetching = false.obs;

  final RxString bannerImageUrl = ''.obs;
  final RxString base64Image = ''.obs;

  final Rx<File?> pickedImageFile = Rx<File?>(null);

  final RxList<String> stateList = <String>[].obs;
  final RxString selectedState = ''.obs;

  final RxList<String> districtList = <String>[].obs;
  final RxString selectedDistrict = ''.obs;

  late int advertisementId;

  final picker = ImagePicker();

  static const String baseUrl = 'https://eshoppy.co.in/api';

  String get authToken => box.read('auth_token') ?? '';

  Map<String, String> get headers => {
    'Authorization': 'Bearer $authToken',
    'Accept': 'application/json',
  };

  Map<String, String> get jsonHeaders => {
    ...headers,
    'Content-Type': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    initLoad();
  }

  Future<void> initLoad() async {
    isFetching.value = true;

    final rawId = Get.arguments?['advertisement_id']?.toString() ?? '0';
    advertisementId = int.tryParse(rawId) ?? 0;

    await fetchStates();

    if (advertisementId != 0) {
      await fetchAdvertisementDetails();
    }

    isFetching.value = false;
  }

  // ───────── STATE CHANGE ─────────
  void onStateChanged(String state) {
    selectedState.value = state;
    selectedDistrict.value = '';
    districtList.clear();
    fetchDistricts(state);
  }

  // ───────── STATES ─────────
  Future<void> fetchStates() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getStates-fordistrict'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        stateList.value =
            (data['data'] as List).map((e) => e['state'].toString().trim()).toList();
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  // ───────── DISTRICTS ─────────
  Future<void> fetchDistricts(String state) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/district-admin/districts'),
        headers: jsonHeaders,
        body: jsonEncode({'state': state}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        districtList.value =
            (data['data'] as List).map((e) => e.toString().trim()).toList();
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  // ───────── FETCH AD ─────────
  Future<void> fetchAdvertisementDetails() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/district-admin/advertisement'),
        headers: jsonHeaders,
        body: jsonEncode({'advertisement_id': advertisementId}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final ad = data['data'];

        advertisementController.text = ad['advertisement'] ?? '';
        bannerImageUrl.value = ad['banner_image'] ?? '';

        // ✅ MATCH STATE (kerala → Kerala)
        final apiState = (ad['state'] ?? '').toString().toLowerCase();

        selectedState.value = stateList.firstWhere(
              (s) => s.toLowerCase() == apiState,
          orElse: () => '',
        );

        // ✅ LOAD DISTRICTS
        if (selectedState.value.isNotEmpty) {
          await fetchDistricts(selectedState.value);
        }

        // ✅ MATCH DISTRICT
        final apiDistrict = (ad['district'] ?? '').toString().toLowerCase();

        selectedDistrict.value = districtList.firstWhere(
              (d) => d.toLowerCase() == apiDistrict,
          orElse: () => '',
        );
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  Future<void> pickBannerImage() async {
    try {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked == null) return;

      // Step 1: Crop first — locked 2:1
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: picked.path,
        aspectRatio: const CropAspectRatio(ratioX: 2, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Banner',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Banner',
            aspectRatioLockEnabled: true,
          ),
        ],
      );
      if (croppedFile == null) return;

      // Step 2: Store — exact same variable as your old code
      bannerImage.value = File(croppedFile.path);

    } catch (e) {
      AppSnackbar.error("Image error: $e");
    }
  }

  void removeImage() {
    pickedImageFile.value = null;
    base64Image.value = '';
  }
  // ───────── UPDATE ─────────
  Future<void> updateAdvertisement() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final body = {
        'advertisement_id': advertisementId,
        'advertisement': advertisementController.text.trim(),
        'state': selectedState.value,
        'district': selectedDistrict.value,
      };

      if (base64Image.value.isNotEmpty) {
        body['banner_image'] = base64Image.value;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/district-admin/advertisement/update'),
        headers: jsonHeaders,
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        AppSnackbar.success(data['message'] ?? "Updated successfully");

        Get.offAll(() => Districtadminhomepage());
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }
}