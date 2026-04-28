
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/models/areaadmin_updateadvertismentmodel.dart';
import '../../../widgets/areaadminsuccesswidget.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../view/area_adminhome.dart';
import '../../../data/errors/api_error.dart';

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

    ever(selectedState, (state) {
      if (state != null && state.isNotEmpty) {
        selectedDistrict.value = null;
        selectedLocation.value = null;
        districtList.clear();
        locationList.clear();
        fetchDistricts();
      }
    });

    ever(selectedDistrict, (district) {
      if (district != null && district.isNotEmpty) {
        selectedLocation.value = null;
        locationList.clear();
        fetchLocations();
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
        Uri.parse(
            'https://eshoppy.co.in/api/area-admin/advertisement'),
        headers: {
          ...headers,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'ad_id': adId.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final model =
          AreaAdminAdvertisementupdateModel.fromJson(data['data']);

          adName.text = model.advertisement;
          existingBannerUrl.value = model.bannerImage;

          _prefetchedState = data['data']['state'] ?? '';
          _prefetchedDistrict = data['data']['district'] ?? '';
          _prefetchedLocation = model.mainLocation;

          await fetchStates();
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
  Future<void> fetchStates() async {
    try {
      isLoadingStates(true);

      final response = await http.get(
        Uri.parse(
            'https://eshoppy.co.in/api/get-MerchantStates'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1' && data['data'] != null) {
          final List<String> states = List<String>.from(data['data']);
          stateList.assignAll(states);

          if (_prefetchedState.isNotEmpty &&
              states.contains(_prefetchedState)) {
            selectedState.value = _prefetchedState;
          } else {
            final match = states.firstWhereOrNull(
                  (s) => s.toLowerCase() == _prefetchedState.toLowerCase(),
            );
            if (match != null) selectedState.value = match;
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
  Future<void> fetchDistricts() async {
    try {
      isLoadingDistricts(true);

      final response = await http.get(
        Uri.parse(
            'https://eshoppy.co.in/api/getMerchant-Districts'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == '1' && data['data'] != null) {
          final List<String> districts = (data['data'] as List)
              .map((e) => e['district'].toString())
              .toList();

          final unique = districts.toSet().toList();
          districtList.assignAll(unique);

          if (_prefetchedDistrict.isNotEmpty &&
              unique.contains(_prefetchedDistrict)) {
            selectedDistrict.value = _prefetchedDistrict;
          } else {
            final match = unique.firstWhereOrNull(
                  (d) => d.toLowerCase() ==
                  _prefetchedDistrict.toLowerCase(),
            );
            if (match != null) selectedDistrict.value = match;
          }
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoadingDistricts(false);
    }
  }

  // ───────── LOCATIONS ─────────
  Future<void> fetchLocations() async {
    try {
      isLoadingLocations(true);

      final response = await http.get(
        Uri.parse(
            'https://eshoppy.co.in/api/area-admin/main-locations'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if ((data['status'] == 1 || data['status'] == '1') &&
            data['data'] != null) {
          final List<String> locations =
          List<String>.from(data['data']);
          locationList.assignAll(locations);

          if (_prefetchedLocation.isNotEmpty &&
              locations.contains(_prefetchedLocation)) {
            selectedLocation.value = _prefetchedLocation;
          } else {
            final match = locations.firstWhereOrNull(
                  (l) => l.toLowerCase() ==
                  _prefetchedLocation.toLowerCase(),
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
    }
  }

  // ───────── IMAGE PICK ─────────
  Future<void> pickBannerImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked == null) return;

      final file = File(picked.path);
      final bytes = await file.readAsBytes();
      final decodedImage = await decodeImageFromList(bytes);

      final ratio = decodedImage.width / decodedImage.height;

      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbar.error(
            "Invalid image ratio. Use 2:1 (e.g. 1200x600)");
        return;
      }

      bannerImage.value = file;
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
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

    if (selectedDistrict.value == null ||
        selectedDistrict.value!.isEmpty) {
      AppSnackbar.warning("Please select a district.");
      return;
    }

    if (selectedLocation.value == null ||
        selectedLocation.value!.isEmpty) {
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
        body['banner_image'] =
        'data:image/jpeg;base64,$base64Image';
      }

      final response = await http.put(
        Uri.parse(
            'https://eshoppy.co.in/api/area-admin/advertisement/update'),
        headers: {
          ...headers,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        if (data['data']?['banner_image'] != null) {
          existingBannerUrl.value =
          data['data']['banner_image'];
          bannerImage.value = null;
        }

        AppSnackbar.success(
            data['message'] ?? "Advertisement updated!");

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAll(() => AreaAdminhomepage());
      } else {
        AppSnackbar.error(
            ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading(false);
    }
  }
}
