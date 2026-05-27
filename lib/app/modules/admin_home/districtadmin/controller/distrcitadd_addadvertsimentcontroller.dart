
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../data/errors/api_error.dart';
import '../../../merchantlogin/widget/successwidget.dart';
import '../view/districtadmin_home.dart';
import 'districtadminadvertismentgetcontroller.dart';

class DistrictAdminAdvertisementController extends GetxController {

  final TextEditingController adName = TextEditingController();
  final picker = ImagePicker();

  final Rx<File?> bannerImage       = Rx<File?>(null);
  final RxBool    isLoading         = false.obs;
  final RxBool    isTitleEmpty      = false.obs;

  final RxList<String> states    = <String>[].obs;
  final RxList<String> districts = <String>[].obs;

  // Use RxnString so null = nothing selected (cleaner than empty string)
  final selectedState    = RxnString();
  final selectedDistrict = RxnString();

  final RxBool isStatesLoading   = false.obs;
  final RxBool isDistrictLoading = false.obs;

  final _box = GetStorage();

  static const String _baseUrl       = 'https://eshoppy.co.in/api/district-admin';
  static const String _publicBaseUrl = 'https://eshoppy.co.in/api';

  String get token => _box.read('auth_token') ?? '';

  Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Accept'       : 'application/json',
  };

  Map<String, String> get _jsonHeaders => {
    'Authorization': 'Bearer $token',
    'Accept'       : 'application/json',
    'Content-Type' : 'application/json',
  };

  // ─── Lifecycle ────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchStates();
    // Districts are NOT fetched on init — they load after state is chosen
  }

  @override
  void onClose() {
    adName.dispose();
    super.onClose();
  }

  // ─── STATE CHANGED ────────────────────────────
  /// Called when user picks a state from dropdown.
  void onStateChanged(String state) {
    selectedState.value    = state;
    selectedDistrict.value = null; // reset district
    districts.clear();
    fetchDistricts(state);
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

  // ─── FETCH DISTRICTS (POST with state) ────────
  Future<void> fetchDistricts(String state) async {

    try {
      isDistrictLoading.value = true;
      final res = await http.post(
        Uri.parse('$_baseUrl/districts'),
        headers: _jsonHeaders,
        body   : jsonEncode({'state': state}),
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

  // // ─── PICK BANNER ──────────────────────────────
  // Future<void> pickBanner() async {
  //   try {
  //     final picked = await picker.pickImage(
  //       source      : ImageSource.gallery,
  //       imageQuality: 85,
  //     );
  //     if (picked == null) return;
  //
  //     final file  = File(picked.path);
  //     final bytes = await file.readAsBytes();
  //     final decodedImage = await decodeImageFromList(bytes);
  //
  //     final width  = decodedImage.width;
  //     final height = decodedImage.height;
  //     final ratio  = width / height;
  //
  //     debugPrint('>>> Image size: ${width}x${height}, ratio: $ratio');
  //
  //     if (ratio < 1.9 || ratio > 2.1) {
  //       AppSnackbar.error(
  //         'Invalid image ratio ${width}x${height}.\nPlease upload a 2:1 ratio image (e.g. 1200x600)',
  //       );
  //       return;
  //     }
  //
  //     bannerImage.value = file;
  //   } catch (e) {
  //     AppSnackbar.error('Image error: $e');
  //   }
  // }
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

  void removeBannerImage() => bannerImage.value = null;

  // ─── VALIDATION ───────────────────────────────
  bool validate() {
    if (adName.text.trim().isEmpty) {
      isTitleEmpty.value = true;
      AppSnackbar.warning('Enter advertisement title');
      return false;
    }
    if (selectedState.value == null) {
      AppSnackbar.warning('Select a state');
      return false;
    }
    if (selectedDistrict.value == null) {
      AppSnackbar.warning('Select a district');
      return false;
    }
    if (bannerImage.value == null) {
      AppSnackbar.warning('Select banner image');
      return false;
    }
    return true;
  }

  // ─── ADD ADVERTISEMENT ────────────────────────
  Future<void> addAdvertisement() async {
    if (!validate()) return;

    try {
      isLoading.value = true;

      final bytes       = await bannerImage.value!.readAsBytes();
      final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';

      final body = {
        'advertisement': adName.text.trim(),
        'state'        : selectedState.value,
        'district'     : selectedDistrict.value,
        'banner_image' : base64Image,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/create-advertisement'),
        headers: _jsonHeaders,
        body   : jsonEncode(body),
      );

      final resData = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          resData['status'] == true) {
        AppSnackbar.success(resData['message'] ?? 'Advertisement created');

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
    selectedState.value    = null;
    selectedDistrict.value = null;
    districts.clear();
    bannerImage.value  = null;
    isTitleEmpty.value = false;
  }
}