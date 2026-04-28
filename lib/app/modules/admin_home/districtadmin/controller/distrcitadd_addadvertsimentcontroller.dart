
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../../widgets/areaadminsuccesswidget.dart';
import '../../../merchantlogin/widget/successwidget.dart';
import '../view/districtadmin_home.dart';
import 'districtadminadvertismentgetcontroller.dart';

class DistrictAdminAdvertisementController extends GetxController {

  final TextEditingController adName = TextEditingController();
  final picker = ImagePicker();

  final Rx<File?> bannerImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isTitleEmpty = false.obs;

  final RxList<String> states = <String>[].obs;
  final RxList<String> districts = <String>[].obs;

  final RxString selectedState = ''.obs;
  final RxString selectedDistrict = ''.obs;

  final RxBool isStatesLoading = false.obs;
  final RxBool isDistrictLoading = false.obs;

  final _box = GetStorage();

  static const String _baseUrl =
      // 'https://rasma.astradevelops.in/e_shoppyy/public/api/district-admin';
  "https://eshoppy.co.in/api/district-admin";
  static const String _publicBaseUrl =
      'https://eshoppy.co.in/api';

  String get token => _box.read('auth_token') ?? '';

  Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchStates();
    fetchDistricts();
  }

  @override
  void onClose() {
    adName.dispose();
    super.onClose();
  }

  // ─── FETCH STATES ─────────────────────────────
  Future<void> fetchStates() async {
    if (token.isEmpty) {
      Get.toNamed('/login');
      return;
    }

    try {
      isStatesLoading.value = true;

      final res = await http.get(
        Uri.parse('$_publicBaseUrl/getStates-fordistrict'),
        headers: headers,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        final List data = body['data'] ?? [];
        states.assignAll(
          data.map((e) => (e['state'] ?? '').toString()).toList(),
        );
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isStatesLoading.value = false;
    }
  }

  // ─── FETCH DISTRICTS ──────────────────────────
  Future<void> fetchDistricts() async {

    try {
      isDistrictLoading.value = true;

      final res = await http.get(
        Uri.parse('$_baseUrl/districts'),
        headers: headers,
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        final List data = body['data'] ?? [];
        districts.assignAll(data.map((e) => e.toString()).toList());
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isDistrictLoading.value = false;
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

  void removeBannerImage() => bannerImage.value = null;

  // ─── VALIDATION ───────────────────────────────
  bool validate() {
    if (adName.text.trim().isEmpty) {
      isTitleEmpty.value = true;
      AppSnackbar.warning("Enter advertisement title");
      return false;
    } else if (selectedState.value.isEmpty) {
      AppSnackbar.warning("Select a state");
      return false;
    } else if (selectedDistrict.value.isEmpty) {
      AppSnackbar.warning("Select a district");
      return false;
    } else if (bannerImage.value == null) {
      AppSnackbar.warning("Select banner image");
      return false;
    }
    return true;
  }

  // ─── ADD ADVERTISEMENT ────────────────────────
  Future<void> addAdvertisement() async {
    if (!validate()) return;

    try {
      isLoading.value = true;

      final bytes = await bannerImage.value!.readAsBytes();
      final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';

      final body = {
        "advertisement": adName.text.trim(),
        "state": selectedState.value,
        "district": selectedDistrict.value,
        "banner_image": base64Image,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/create-advertisement'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      final resData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          resData['status'] == true) {

        AppSnackbar.success(
            resData['message'] ?? "Advertisement created");

        if (Get.isRegistered<DistrictAdminAdvertisementGetController>()) {
          Get.find<DistrictAdminAdvertisementGetController>()
              .fetchAdvertisements();
        }

        resetForm();
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

  // ─── RESET ────────────────────────────────────
  void resetForm() {
    adName.clear();
    selectedState.value = '';
    selectedDistrict.value = '';
    bannerImage.value = null;
    isTitleEmpty.value = false;
  }
}