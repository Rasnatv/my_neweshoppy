
import 'dart:convert';
import 'dart:io';
import 'package:eshoppy/app/widgets/areaadminsuccesswidget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../userlogin/view/login.dart';
import '../view/area_adminhome.dart';
import '../../../data/errors/api_error.dart';        // ← same as merchant


class AreaAdminAdvertisementController extends GetxController {

  // ─── Controllers ─────────────────────────────
  final TextEditingController adName = TextEditingController();

  // ─── Observables ─────────────────────────────
  final Rx<File?> bannerImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isTitleEmpty = false.obs;

  // States
  final RxList<String> states = <String>[].obs;
  final RxString selectedState = ''.obs;
  final RxBool isStateLoading = false.obs;

  // Districts
  final RxList<String> districts = <String>[].obs;
  final RxString selectedDistrict = ''.obs;
  final RxBool isDistrictLoading = false.obs;

  // Locations
  final RxList<String> locations = <String>[].obs;
  final RxString selectedLocation = ''.obs;
  final RxBool isLocationLoading = false.obs;

  final _box = GetStorage();
  final _picker = ImagePicker();

  static const String baseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin';
  static const String publicBaseUrl =
      'https://rasma.astradevelops.in/e_shoppyy/public/api';

  // ─── Token ──────────────────────────────────
  String get token => _box.read('auth_token') ?? '';

  Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchStates();
    fetchLocations();
  }

  @override
  void onClose() {
    adName.dispose();
    super.onClose();
  }

  // ─── Fetch States ────────────────────────────
  Future<void> fetchStates() async {
    try {
      isStateLoading.value = true;

      final res = await http.get(
        Uri.parse('$publicBaseUrl/get-MerchantStates'),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['status'] == '1' || body['status'] == 1) {
          states.assignAll(
              (body['data'] as List).map((e) => e.toString()).toList());
        } else {
          AppSnackbarss.error(body['message'] ?? 'Failed to load states');
        }
      } else if (res.statusCode == 401) {
        _handleUnauthorized();
      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isStateLoading.value = false;
    }
  }

  // ─── Fetch Districts ─────────────────────────
  Future<void> fetchDistricts(String state) async {
    try {
      isDistrictLoading.value = true;
      districts.clear();
      selectedDistrict.value = '';

      final res = await http.get(
        Uri.parse('$publicBaseUrl/getMerchant-Districts?state=$state'),
        headers: headers,
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['status'] == '1' || body['status'] == 1) {
          final List data = body['data'] as List;
          districts.assignAll(
            data.map((e) => e['district'].toString()).toSet().toList(),
          );
        } else {
          AppSnackbarss.error(body['message'] ?? 'Failed to load districts');
        }
      } else if (res.statusCode == 401) {
        _handleUnauthorized();
      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isDistrictLoading.value = false;
    }
  }

  // ─── Fetch Locations ─────────────────────────
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

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['status'] == true || body['status'] == 1) {
          locations.assignAll(
              (body['data'] as List).map((e) => e.toString()).toList());
        } else {
          AppSnackbarss.error(body['message'] ?? 'Failed to load locations');
        }
      } else if (res.statusCode == 401) {
        _handleUnauthorized();
      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isLocationLoading.value = false;
    }
  }

  // ─── On State Selected ───────────────────────
  void onStateChanged(String? state) {
    if (state == null) return;
    selectedState.value = state;
    selectedDistrict.value = '';
    fetchDistricts(state);
  }

  // ─── Image Picker (2:1 ratio enforced) ───────
  Future<void> pickBannerImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked == null) return;

      final file = File(picked.path);

      // Decode image to get actual dimensions
      final bytes = await file.readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);

      final width  = decodedImage.width;
      final height = decodedImage.height;
      final ratio  = width / height;

      debugPrint(">>> Image size: ${width}x${height}, ratio: $ratio");

      // Allow only 2:1 ratio (±0.1 tolerance)
      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbarss.error(
          "Invalid image ratio ${width}x${height}.\nPlease upload a 2:1 ratio image (e.g. 1200x600)",
        );
        return;
      }

      bannerImage.value = file;
    } catch (e) {
      AppSnackbarss.error("Image error: $e");
    }
  }

  void removeBannerImage() {
    bannerImage.value = null;
  }

  // ─── Image → Base64 ──────────────────────────
  Future<String?> _toBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return 'data:image/jpeg;base64,${base64Encode(bytes)}';
    } catch (e) {
      return null;
    }
  }

  // ─── Validation ─────────────────────────────
  bool validate() {
    if (adName.text.trim().isEmpty) {
      isTitleEmpty.value = true;
      AppSnackbarss.error("Enter advertisement title");
      return false;
    } else if (selectedState.value.isEmpty) {
      AppSnackbarss.error("Select state");
      return false;
    } else if (selectedDistrict.value.isEmpty) {
      AppSnackbarss.error("Select district");
      return false;
    } else if (selectedLocation.value.isEmpty) {
      AppSnackbarss.error("Select location");
      return false;
    } else if (bannerImage.value == null) {
      AppSnackbarss.error("Select banner image");
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

      final base64Image = await _toBase64(bannerImage.value!);
      if (base64Image == null) {
        AppSnackbarss.error("Failed to process image");
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/create-advertisement'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "advertisement": adName.text.trim(),
          "state": selectedState.value,
          "district": selectedDistrict.value,
          "main_location": selectedLocation.value,
          "banner_image": base64Image,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = jsonDecode(response.body);

        if (resData['status'] == true ||
            resData['status'] == 1 ||
            resData['status'] == '1') {
          AppSnackbarss.success(resData['message'] ?? "Advertisement created");
          resetForm();
          await Future.delayed(const Duration(milliseconds: 800));
          Get.offAll(() => AreaAdminhomepage());
        } else {
          AppSnackbarss.error(resData['message'] ?? "Failed to create advertisement");
        }
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        AppSnackbarss.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbarss.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Reset ─────────────────────────────────
  void resetForm() {
    adName.clear();
    selectedState.value = '';
    selectedDistrict.value = '';
    districts.clear();
    selectedLocation.value = '';
    bannerImage.value = null;
    isTitleEmpty.value = false;
  }

  // ─── Unauthorized ───────────────────────────
  void _handleUnauthorized() {
    AppSnackbarss.error("Session expired. Please login again.");
    _box.erase();
    Get.offAll(() => LoginPageView());
  }
}