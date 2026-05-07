
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../data/errors/api_error.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class AdminMerchantDetailController extends GetxController {
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();

  // ─── Merchant detail ───────────────────────────────────────────────────────
  final merchant = Rx<dynamic>(null);
  final isLoading = false.obs;

  // ─── Update / Delete state ─────────────────────────────────────────────────
  final isUpdating = false.obs;
  final isDeleting = false.obs;

  // ─── Edit form controllers ─────────────────────────────────────────────────
  final editOwnerNameController = TextEditingController();
  final editShopNameController = TextEditingController();
  final editEmailController = TextEditingController();
  final editPhone1Controller = TextEditingController();
  final editPhone2Controller = TextEditingController();
  // GPS observables (drive the UI; values also written to lat/lng controllers)
  final editShopLat = 0.0.obs;
  final editShopLng = 0.0.obs;
  final editPickedLocation =
      'Tap to pick location or use current location'.obs;
  final isGettingCurrentLocation = false.obs;

  // Optional
  final editWhatsappController = TextEditingController();
  final editFacebookController = TextEditingController();
  final editInstagramController = TextEditingController();
  final editWebsiteController = TextEditingController();

  // Edit image
  final editStoreImage = Rx<File?>(null);

  // Edit dropdowns
  final editSelectedState = ''.obs;
  final editSelectedDistrict = ''.obs;
  final editSelectedLocation = ''.obs;

  // Dropdown data (shared with add-merchant flow)
  final states = <String>[].obs;
  final districts = <String>[].obs;
  final locations = <String>[].obs;

  final isLoadingStates = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingLocations = false.obs;

  // ─── API URLs ──────────────────────────────────────────────────────────────
  static const _detailUrl =
      'https://eshoppy.co.in/api/admin/merchant/details';
  static const _updateUrl =
      'https://eshoppy.co.in/api/admin/update-merchant';
  static const _deleteUrl =
      'https://eshoppy.co.in/api/admin/delete-merchant';
  static const _statesUrl =
      'https://eshoppy.co.in/api/merchant/states';
  static const _districtsUrl =
      'https://eshoppy.co.in/api/merchant/districts';
  static const _locationsUrl =
      'https://eshoppy.co.in/api/merchant/locations';

  // ─── Auth ──────────────────────────────────────────────────────────────────
  String get _authToken => box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_authToken',
  };

  // ─── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onClose() {
    editOwnerNameController.dispose();
    editShopNameController.dispose();
    editEmailController.dispose();
    editPhone1Controller.dispose();
    editPhone2Controller.dispose();
    editWhatsappController.dispose();
    editFacebookController.dispose();
    editInstagramController.dispose();
    editWebsiteController.dispose();
    super.onClose();
  }

  // ─── Fetch Merchant Detail ─────────────────────────────────────────────────
  Future<void> fetchMerchantDetail(int id) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse(_detailUrl),
        headers: _headers,
        body: jsonEncode({'merchant_id': id}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          merchant.value = _parseMerchant(data['data']);
        } else {
          AppSnackbar.error(
              data['message'] ?? 'Failed to load merchant');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Init Edit Controllers from Current Merchant ───────────────────────────
  void initEditControllers() {
    final m = merchant.value;
    if (m == null) return;

    editOwnerNameController.text = m.ownerName;
    editShopNameController.text = m.shopName;
    editEmailController.text = m.email;
    editPhone1Controller.text = m.phone1;
    editPhone2Controller.text = m.phone2;
    editWhatsappController.text = m.whatsapp;
    editFacebookController.text = m.facebook;
    editInstagramController.text = m.instagram;
    editWebsiteController.text = m.website;

    // Seed GPS observables from saved values
    editShopLat.value = double.tryParse(m.latitude) ?? 0.0;
    editShopLng.value = double.tryParse(m.longitude) ?? 0.0;
    editPickedLocation.value = (editShopLat.value != 0.0)
        ? 'Lat: ${m.latitude}, Lng: ${m.longitude}'
        : 'Tap to pick location or use current location';

    editSelectedState.value = m.state;
    editSelectedDistrict.value = m.district;
    editSelectedLocation.value = m.mainLocation;
    editStoreImage.value = null;

    fetchStates(
      preselectedDistrict: m.district,
      preselectedLocation: m.mainLocation,
    );
  }

  // ─── Pick Edit Image ───────────────────────────────────────────────────────
  Future<void> pickEditImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (picked != null) {
        editStoreImage.value = File(picked.path);
      }
    } catch (_) {}
  }

  // ─── Get Current Location (edit flow) ─────────────────────────────────────
  Future<void> getCurrentLocation() async {
    try {
      isGettingCurrentLocation.value = true;

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackbar.error('Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackbar.error('Location permission denied');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        AppSnackbar.error(
            'Location permission permanently denied. Enable it from settings.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _applyEditLocation(position.latitude, position.longitude);

      try {
        final placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          editPickedLocation.value =
          '${p.street ?? ''}, ${p.locality ?? ''}, '
              '${p.administrativeArea ?? ''}, ${p.country ?? ''}';
        }
      } catch (_) {}

      AppSnackbar.success('Current location fetched successfully');
    } catch (e) {
      AppSnackbar.error('Failed to get location: ${e.toString()}');
    } finally {
      isGettingCurrentLocation.value = false;
    }
  }

  /// Called by map picker result
  void updateEditLocation(double lat, double lng, String address) {
    _applyEditLocation(lat, lng);
    editPickedLocation.value = address;
  }

  void _applyEditLocation(double lat, double lng) {
    editShopLat.value = lat;
    editShopLng.value = lng;
  }


  Future<void> updateMerchant(int merchantId) async {

    // Validate GPS — not covered by form validators
    if (editShopLat.value == 0.0 || editShopLng.value == 0.0) {
      AppSnackbar.warning('Please set the shop location on the map');
      return;
    }
    try {
      isUpdating.value = true;

      final Map<String, dynamic> body = {
        'merchant_id': merchantId,
        'owner_name': editOwnerNameController.text.trim(),
        'shop_name': editShopNameController.text.trim(),
        'email': editEmailController.text.trim(),
        'phone_no_1': editPhone1Controller.text.trim(),
        'phone_no_2': editPhone2Controller.text.trim(),
        'state': editSelectedState.value,
        'district': editSelectedDistrict.value,
        'main_location': editSelectedLocation.value,
        'latitude': editShopLat.value.toString(),
        'longitude': editShopLng.value.toString(),
      };

      // Optional fields
      if (editWhatsappController.text.trim().isNotEmpty) {
        body['whatsapp_no'] = editWhatsappController.text.trim();
      }
      if (editFacebookController.text.trim().isNotEmpty) {
        body['facebook_link'] = editFacebookController.text.trim();
      }
      if (editInstagramController.text.trim().isNotEmpty) {
        body['instagram_link'] = editInstagramController.text.trim();
      }
      if (editWebsiteController.text.trim().isNotEmpty) {
        body['website_link'] = editWebsiteController.text.trim();
      }

      // Include new image only if user picked one
      if (editStoreImage.value != null) {
        final bytes = await editStoreImage.value!.readAsBytes();
        body['store_image'] =
        'data:image/jpeg;base64,${base64Encode(bytes)}';
      }

      final response = await http.put(
        Uri.parse(_updateUrl),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          Get.back(); // close bottom sheet
          AppSnackbar.success(
              data['message'] ?? 'Merchant updated successfully');
          // Refresh detail
          await fetchMerchantDetail(merchantId);
        } else {
          AppSnackbar.error(
              data['message'] ?? 'Failed to update merchant');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } on SocketException {
      AppSnackbar.error(
          ApiErrorHandler.handleException(SocketException('')));
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isUpdating.value = false;
    }
  }

  // ─── Delete Merchant ───────────────────────────────────────────────────────
  Future<void> deleteMerchant(int merchantId) async {

    try {
      isDeleting.value = true;

      final response = await http.post(
        Uri.parse(_deleteUrl),
        headers: _headers,
        body: jsonEncode({'merchant_id': merchantId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          Get.back(); // close confirm dialog
          AppSnackbar.success(
              data['message'] ?? 'Merchant deleted successfully');
          Get.back(); // go back to merchant list
        } else {
          AppSnackbar.error(
              data['message'] ?? 'Failed to delete merchant');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(response));
      }
    } on SocketException {
      AppSnackbar.error(
          ApiErrorHandler.handleException(SocketException('')));
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isDeleting.value = false;
    }
  }

  // ─── Fetch States ──────────────────────────────────────────────────────────
  Future<void> fetchStates({
    String preselectedDistrict = '',
    String preselectedLocation = '',
  }) async {
    try {
      isLoadingStates.value = true;
      final response =
      await http.get(Uri.parse(_statesUrl), headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          states.assignAll(
            List<String>.from(data['data']).toSet().toList(),
          );
          // After states loaded, fetch districts for pre-selected state
          if (editSelectedState.value.isNotEmpty) {
            await fetchDistricts(
              editSelectedState.value,
              preselectedDistrict: preselectedDistrict,
              preselectedLocation: preselectedLocation,
            );
          }
        }
      }
    } catch (_) {} finally {
      isLoadingStates.value = false;
    }
  }

  // ─── Fetch Districts ───────────────────────────────────────────────────────
  Future<void> fetchDistricts(
      String state, {
        String preselectedDistrict = '',
        String preselectedLocation = '',
      }) async {
    if (_authToken.isEmpty) return;
    try {
      isLoadingDistricts.value = true;
      districts.clear();
      locations.clear();

      if (preselectedDistrict.isEmpty) {
        editSelectedDistrict.value = '';
        editSelectedLocation.value = '';
      }

      final response = await http.post(
        Uri.parse(_districtsUrl),
        headers: _headers,
        body: jsonEncode({'state': state}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          districts.assignAll(
            List<String>.from(data['data']).toSet().toList(),
          );
          // Re-apply preselected district if it exists in list
          if (preselectedDistrict.isNotEmpty &&
              districts.contains(preselectedDistrict)) {
            editSelectedDistrict.value = preselectedDistrict;
            await fetchLocations(
              state,
              preselectedDistrict,
              preselectedLocation: preselectedLocation,
            );
          }
        }
      }
    } catch (_) {} finally {
      isLoadingDistricts.value = false;
    }
  }

  // ─── Fetch Locations ───────────────────────────────────────────────────────
  Future<void> fetchLocations(
      String state,
      String district, {
        String preselectedLocation = '',
      }) async {
    if (_authToken.isEmpty) return;
    try {
      isLoadingLocations.value = true;
      locations.clear();

      if (preselectedLocation.isEmpty) {
        editSelectedLocation.value = '';
      }

      final response = await http.post(
        Uri.parse(_locationsUrl),
        headers: _headers,
        body: jsonEncode({'state': state, 'district': district}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          locations.assignAll(
            List<String>.from(data['data']).toSet().toList(),
          );
          // Re-apply preselected location
          if (preselectedLocation.isNotEmpty &&
              locations.contains(preselectedLocation)) {
            editSelectedLocation.value = preselectedLocation;
          }
        }
      }
    } catch (_) {} finally {
      isLoadingLocations.value = false;
    }
  }

  // ─── Parse merchant from API ───────────────────────────────────────────────
  dynamic _parseMerchant(Map<String, dynamic> json) {
    return _MerchantDetail(
      id: json['id'] ?? 0,
      shopName: json['shop_name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      email: json['email'] ?? '',
      phone1: json['phone_no_1'] ?? '',
      phone2: json['phone_no_2'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      mainLocation: json['main_location'] ?? '',
      latitude: (json['latitude'] ?? '').toString(),
      longitude: (json['longitude'] ?? '').toString(),
      storeImage: json['store_image'] ?? '',
      whatsapp: json['whatsapp_no'] ?? '',
      facebook: json['facebook_link'] ?? '',
      instagram: json['instagram_link'] ?? '',
      website: json['website_link'] ?? '',
    );
  }
}

// ─── Internal model ────────────────────────────────────────────────────────────
class _MerchantDetail {
  final int id;
  final String shopName;
  final String ownerName;
  final String email;
  final String phone1;
  final String phone2;
  final String state;
  final String district;
  final String mainLocation;
  final String latitude;
  final String longitude;
  final String storeImage;
  final String whatsapp;
  final String facebook;
  final String instagram;
  final String website;

  _MerchantDetail({
    required this.id,
    required this.shopName,
    required this.ownerName,
    required this.email,
    required this.phone1,
    required this.phone2,
    required this.state,
    required this.district,
    required this.mainLocation,
    required this.latitude,
    required this.longitude,
    required this.storeImage,
    required this.whatsapp,
    required this.facebook,
    required this.instagram,
    required this.website,
  });
}