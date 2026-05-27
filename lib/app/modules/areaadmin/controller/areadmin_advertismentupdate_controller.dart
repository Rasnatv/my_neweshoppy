

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/areaadmin_updateadvertismentmodel.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../view/area_adminhome.dart';
import '../../../data/errors/api_error.dart';
import 'areaadmin_dashboardcountcnroller.dart';
import 'areaadmin_eventgettingcontroller.dart';
import 'areaadmin_getting_advertismentcontroller.dart';

class AreaAdminUpdateAdvertisementController extends GetxController {
  final int adId;
  AreaAdminUpdateAdvertisementController({required this.adId});

  final box = GetStorage();
  final adName = TextEditingController();

  final stateList = <String>[].obs;
  final districtList = <String>[].obs;
  final locationList = <String>[].obs;

  final selectedState = Rxn<String>();
  final selectedDistrict = Rxn<String>();
  final selectedLocation = Rxn<String>();

  final _picker = ImagePicker();

  final isLoadingStates = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingLocations = false.obs;

  String _prefetchedState = '';
  String _prefetchedDistrict = '';
  String _prefetchedLocation = '';

  // Guard flags so ever() watchers don't double-fire on pre-fill
  bool _suppressDistrictWatch = false;
  bool _suppressLocationWatch = false;

  final bannerImage = Rx<File?>(null);
  final existingBannerUrl = ''.obs;

  final isLoading = false.obs;
  final isFetching = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isTitleEmpty = false.obs;

  String get token => box.read('auth_token') ?? '';

  Map<String, String> get headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();

    fetchAdvertisement();

    // Triggered when user manually changes state after initial load
    ever(selectedState, (state) {
      if (_suppressDistrictWatch) return;
      if (state != null && state.isNotEmpty) {
        selectedDistrict.value = null;
        selectedLocation.value = null;
        districtList.clear();
        locationList.clear();
        fetchDistricts(state);
      }
    });

    // Triggered when user manually changes district after initial load
    ever(selectedDistrict, (district) {
      if (_suppressLocationWatch) return;
      if (district != null && district.isNotEmpty) {
        selectedLocation.value = null;
        locationList.clear();
        fetchLocations(district);
      }
    });
  }

  @override
  void onClose() {
    adName.dispose();
    super.onClose();
  }

  // ───────── FETCH AD ─────────
  Future<void> fetchAdvertisement() async {
    try {
      isFetching(true);
      hasError(false);
      errorMessage('');

      final response = await http.post(
        Uri.parse('https://eshoppy.co.in/api/area-admin/advertisement'),
        headers: {
          ...headers,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'ad_id': adId.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if ((data['status'] == true || data['status'] == 1) &&
            data['data'] != null) {
          final model =
          AreaAdminAdvertisementupdateModel.fromJson(data['data']);

          adName.text = model.advertisement;
          existingBannerUrl.value = model.bannerImage;

          _prefetchedState    = data['data']['state']     ?? '';
          _prefetchedDistrict = data['data']['district']  ?? '';
          _prefetchedLocation = model.mainLocation;

          // Suppress ever() watchers during programmatic pre-fill
          _suppressDistrictWatch = true;
          _suppressLocationWatch = true;

          await fetchStates(); // chains → fetchDistricts → fetchLocations
        } else {
          hasError(true);
          errorMessage(data['message'] ?? 'Failed to load advertisement.');
          AppSnackbar.error(errorMessage.value);
        }
      } else {
        final msg = ApiErrorHandler.handleResponse(response);
        hasError(true);
        errorMessage(msg);
        AppSnackbar.error(msg);
      }
    } catch (e) {
      final msg = ApiErrorHandler.handleException(e);
      hasError(true);
      errorMessage(msg);
      AppSnackbar.error(msg);
    } finally {
      isFetching(false);
    }
  }

  // ───────── STATES ─────────
  // Response: { "status": true, "data": ["karnataka", "kerala"] }
  Future<void> fetchStates() async {
    try {
      isLoadingStates(true);

      final response = await http.get(
        Uri.parse('https://eshoppy.co.in/api/get-MerchantStates'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // API returns status as boolean true
        if ((data['status'] == true ||
            data['status'] == 1 ||
            data['status'] == '1') &&
            data['data'] != null) {
          final List<String> states =
          (data['data'] as List).map((e) => e.toString()).toList();
          stateList.assignAll(states);

          if (_prefetchedState.isNotEmpty) {
            final match = states.firstWhereOrNull(
                  (s) => s.toLowerCase() == _prefetchedState.toLowerCase(),
            );
            if (match != null) {
              selectedState.value = match;
              // Chain: now fetch districts for the pre-filled state
              await fetchDistricts(match);
            }
          }
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingStates(false);
    }
  }

  // ───────── DISTRICTS ─────────
  // Response: { "status": true, "data": ["Kasaragod", "Kochi", "Malappuram"] }
  // Data is a flat string array — NOT objects with a 'district' key.
  // ───────── DISTRICTS ─────────
// ✅ Changed: POST with JSON body, not GET with query param
  Future<void> fetchDistricts(String state) async {
    try {
      isLoadingDistricts(true);

      final response = await http.post(
        Uri.parse('https://eshoppy.co.in/api/getMerchant-Districts'),
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode({"state": state}),   // ✅ POST body
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if ((data['status'] == true ||
            data['status'] == 1 ||
            data['status'] == '1') &&
            data['data'] != null) {
          // ✅ flat string list
          final List<String> districts =
          (data['data'] as List).map((e) => e.toString()).toList();
          final unique = districts.toSet().toList();
          districtList.assignAll(unique);

          if (_prefetchedDistrict.isNotEmpty) {
            final match = unique.firstWhereOrNull(
                  (d) => d.toLowerCase() == _prefetchedDistrict.toLowerCase(),
            );
            if (match != null) {
              selectedDistrict.value = match;
              await fetchLocations(match);
            }
          }
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingDistricts(false);
      _suppressDistrictWatch = false;
    }
  }

// ───────── LOCATIONS ─────────
// ✅ Changed: POST with JSON body, not GET with query param
  Future<void> fetchLocations(String district) async {
    try {
      isLoadingLocations(true);

      final response = await http.post(
        Uri.parse('https://eshoppy.co.in/api/area-admin/main-locations'),
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode({"district": district}),   // ✅ POST body
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if ((data['status'] == true ||
            data['status'] == 1 ||
            data['status'] == '1') &&
            data['data'] != null) {
          final List<String> locs =
          (data['data'] as List).map((e) => e.toString()).toList();
          locationList.assignAll(locs);

          if (_prefetchedLocation.isNotEmpty) {
            final match = locs.firstWhereOrNull(
                  (l) => l.toLowerCase() == _prefetchedLocation.toLowerCase(),
            );
            if (match != null) selectedLocation.value = match;
          }
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingLocations(false);
      _suppressLocationWatch = false;
    }
  }

  Future<void> pickBannerImage() async {
    try {
      final picked = await _picker.pickImage(
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

  // ───────── UPDATE ─────────
  Future<void> updateAdvertisement() async {
    if (adName.text.trim().isEmpty) {
      isTitleEmpty(true);
      return;
    }
    isTitleEmpty(false);

    if (selectedState.value == null || selectedState.value!.isEmpty) {
      AppSnackbar.warning("Please select a state.");
      return;
    }

    if (selectedDistrict.value == null || selectedDistrict.value!.isEmpty) {
      AppSnackbar.warning("Please select a district.");
      return;
    }

    if (selectedLocation.value == null || selectedLocation.value!.isEmpty) {
      AppSnackbar.warning("Please select a location.");
      return;
    }

    if (token.isEmpty) {
      AppSnackbar.error("No auth token. Please log in again.");
      return;
    }

    try {
      isLoading(true);

      final body = {
        'ad_id': adId.toString(),
        'advertisement': adName.text.trim(),
        'state': selectedState.value!,
        'district': selectedDistrict.value!,
        'main_location': selectedLocation.value!,
      };

      if (bannerImage.value != null) {
        final bytes = await bannerImage.value!.readAsBytes();
        final base64Image = base64Encode(bytes);
        body['banner_image'] = 'data:image/jpeg;base64,$base64Image';
      }

      final response = await http.put(
        Uri.parse(
          'https://eshoppy.co.in/api/area-admin/advertisement/update',
        ),
        headers: {
          ...headers,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          (data['status'] == true || data['status'] == 1)) {
        if (data['data']?['banner_image'] != null) {
          existingBannerUrl.value = data['data']['banner_image'];
          bannerImage.value = null;
        }

        AppSnackbar.success(data['message'] ?? "Advertisement updated!");

        // await Future.delayed(const Duration(milliseconds: 500));
        // Get.offAll(() => AreaAdminhomepage());
        Get.offAll(() => AreaAdminhomepage());
        await Future.delayed(const Duration(milliseconds: 300));
        if (Get.isRegistered<AreaAdminAdvertisementgetController>()) {
          Get.find<AreaAdminAdvertisementgetController>().fetchAdvertisements();
        }
        if (Get.isRegistered<AreaAdminDashboardController>()) {
          Get.find<AreaAdminDashboardController>().fetchDashboardCount();
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading(false);
    }
  }
}
