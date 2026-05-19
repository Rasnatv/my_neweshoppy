
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

  final merchant = Rx<dynamic>(null);
  final isLoading = false.obs;
  final isUpdating = false.obs;
  final isDeleting = false.obs;

  // Edit form controllers
  final editOwnerNameController = TextEditingController();
  final editShopNameController = TextEditingController();
  final editEmailController = TextEditingController();
  final editPhone1Controller = TextEditingController();
  final editPhone2Controller = TextEditingController();
  final editWhatsappController = TextEditingController();
  final editFacebookController = TextEditingController();
  final editInstagramController = TextEditingController();
  final editWebsiteController = TextEditingController();

  // GPS
  final editShopLat = 0.0.obs;
  final editShopLng = 0.0.obs;
  final editPickedLocation =
      'Tap to pick location or use current location'.obs;
  final isGettingCurrentLocation = false.obs;

  // Image
  final editStoreImage = Rx<File?>(null);

  // Dropdowns
  final editSelectedState = ''.obs;
  final editSelectedDistrict = ''.obs;
  final editSelectedLocation = ''.obs;
  final states = <String>[].obs;
  final districts = <String>[].obs;
  final locations = <String>[].obs;
  final isLoadingStates = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingLocations = false.obs;

  static const _detailUrl =
      'https://entenaadu.co.in/api/admin/merchant/details';
  static const _updateUrl =
      'https://entenaadu.co.in/api/admin/update-merchant';
  static const _deleteUrl =
      'https://entenaadu.co.in/api/admin/delete-merchant';
  static const _statesUrl = 'https://entenaadu.co.in/api/merchant/states';
  static const _districtsUrl =
      'https://entenaadu.co.in/api/merchant/districts';
  static const _locationsUrl =
      'https://entenaadu.co.in/api/merchant/locations';

  String get _token => box.read('auth_token') ?? '';
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  /// Trim + deduplicate API list results — fixes the duplicate dropdown crash
  List<String> _dedupe(List<dynamic> raw) {
    final seen = <String>{};
    final result = <String>[];
    for (final item in raw) {
      final v = item.toString().trim();
      if (v.isNotEmpty && seen.add(v)) result.add(v);
    }
    return result;
  }

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

  // ── Fetch Detail ───────────────────────────────────────────────────────────
  Future<void> fetchMerchantDetail(int id) async {
    try {
      isLoading.value = true;
      final res = await http.post(Uri.parse(_detailUrl),
          headers: _headers, body: jsonEncode({'merchant_id': id}));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == true) {
          merchant.value = _parse(data['data']);
        } else {
          AppSnackbar.error(data['message'] ?? 'Failed to load merchant');
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    } finally {
      isLoading.value = false;
    }
  }

  // ── Init Edit Controllers ──────────────────────────────────────────────────
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

    editShopLat.value = double.tryParse(m.latitude) ?? 0.0;
    editShopLng.value = double.tryParse(m.longitude) ?? 0.0;
    editPickedLocation.value = editShopLat.value != 0.0
        ? 'Lat: ${m.latitude}, Lng: ${m.longitude}'
        : 'Tap to pick location or use current location';

    // Values are already trimmed in _parse, so they will match _dedupe output
    editSelectedState.value = m.state;
    editSelectedDistrict.value = m.district;
    editSelectedLocation.value = m.mainLocation;
    editStoreImage.value = null;

    // Clear stale lists before reload
    states.clear();
    districts.clear();
    locations.clear();

    fetchStates(
      preselectedDistrict: m.district,
      preselectedLocation: m.mainLocation,
    );
  }

  // ── Pick Image ─────────────────────────────────────────────────────────────
  Future<void> pickEditImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85);
      if (picked != null) editStoreImage.value = File(picked.path);
    } catch (_) {}
  }

  // ── Current Location ───────────────────────────────────────────────────────
  Future<void> getCurrentLocation() async {
    try {
      isGettingCurrentLocation.value = true;
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        AppSnackbar.error('Location services are disabled');
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
        if (perm == LocationPermission.denied) {
          AppSnackbar.error('Location permission denied');
          return;
        }
      }
      if (perm == LocationPermission.deniedForever) {
        AppSnackbar.error(
            'Permission permanently denied. Enable from settings.');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _applyLocation(pos.latitude, pos.longitude);
      try {
        final marks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (marks.isNotEmpty) {
          final p = marks.first;
          editPickedLocation.value =
          '${p.street ?? ''}, ${p.locality ?? ''}, '
              '${p.administrativeArea ?? ''}, ${p.country ?? ''}';
        }
      } catch (_) {}
      AppSnackbar.success('Current location fetched successfully');
    } catch (e) {
      AppSnackbar.error('Failed to get location: $e');
    } finally {
      isGettingCurrentLocation.value = false;
    }
  }

  void updateEditLocation(double lat, double lng, String address) {
    _applyLocation(lat, lng);
    editPickedLocation.value = address;
  }

  void _applyLocation(double lat, double lng) {
    editShopLat.value = lat;
    editShopLng.value = lng;
  }
  Future<void> updateMerchant(int merchantId) async {
    if (editShopLat.value == 0.0 || editShopLng.value == 0.0) {
      AppSnackbar.warning('Please set the shop location on the map');
      return;
    }

    try {
      isUpdating.value = true;

      final body = <String, dynamic>{
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

        // Optional fields
        'whatsapp_no': editWhatsappController.text.trim(),
        'facebook_link': editFacebookController.text.trim(),
        'instagram_link': editInstagramController.text.trim(),
        'website_link': editWebsiteController.text.trim(),
      };

      // Store image
      if (editStoreImage.value != null) {
        final bytes = await editStoreImage.value!.readAsBytes();

        body['store_image'] =
        'data:image/jpeg;base64,${base64Encode(bytes)}';
      }

      final res = await http.put(
        Uri.parse(_updateUrl),
        headers: _headers,
        body: jsonEncode(body),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);

        if (data['status'] == true) {
          Get.back();

          AppSnackbar.success(
            data['message'] ?? 'Merchant updated successfully',
          );

          await fetchMerchantDetail(merchantId);
        } else {
          AppSnackbar.error(
            data['message'] ?? 'Failed to update merchant',
          );
        }
      } else {
        AppSnackbar.error(
          ApiErrorHandler.handleResponse(res),
        );
      }
    } on SocketException {
      AppSnackbar.error(
        ApiErrorHandler.handleException(
          SocketException(''),
        ),
      );
    } catch (e) {
      AppSnackbar.error(
        ApiErrorHandler.handleException(e),
      );
    } finally {
      isUpdating.value = false;
    }
  }


  // ── Fetch States ───────────────────────────────────────────────────────────
  Future<void> fetchStates({
    String preselectedDistrict = '',
    String preselectedLocation = '',
  }) async {
    try {
      isLoadingStates.value = true;
      final res =
      await http.get(Uri.parse(_statesUrl), headers: _headers);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 1) {
          states.assignAll(_dedupe(data['data'] as List));

          // If saved state no longer in list, clear it
          if (editSelectedState.value.isNotEmpty &&
              !states.contains(editSelectedState.value)) {
            editSelectedState.value = '';
          }

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

  // ── Fetch Districts ────────────────────────────────────────────────────────
  Future<void> fetchDistricts(
      String state, {
        String preselectedDistrict = '',
        String preselectedLocation = '',
      }) async {
    if (_token.isEmpty) return;
    try {
      isLoadingDistricts.value = true;
      districts.clear();
      locations.clear();

      if (preselectedDistrict.isEmpty) {
        editSelectedDistrict.value = '';
        editSelectedLocation.value = '';
      }

      final res = await http.post(Uri.parse(_districtsUrl),
          headers: _headers, body: jsonEncode({'state': state}));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 1) {
          districts.assignAll(_dedupe(data['data'] as List));

          if (preselectedDistrict.isNotEmpty &&
              districts.contains(preselectedDistrict)) {
            editSelectedDistrict.value = preselectedDistrict;
            await fetchLocations(
              state,
              preselectedDistrict,
              preselectedLocation: preselectedLocation,
            );
          } else if (preselectedDistrict.isNotEmpty) {
            // Saved district not found in list — reset
            editSelectedDistrict.value = '';
            editSelectedLocation.value = '';
          }
        }
      }
    } catch (_) {} finally {
      isLoadingDistricts.value = false;
    }
  }

  // ── Fetch Locations ────────────────────────────────────────────────────────
  Future<void> fetchLocations(
      String state,
      String district, {
        String preselectedLocation = '',
      }) async {
    if (_token.isEmpty) return;
    try {
      isLoadingLocations.value = true;
      locations.clear();
      if (preselectedLocation.isEmpty) editSelectedLocation.value = '';

      final res = await http.post(Uri.parse(_locationsUrl),
          headers: _headers,
          body: jsonEncode({'state': state, 'district': district}));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 1) {
          locations.assignAll(_dedupe(data['data'] as List));

          if (preselectedLocation.isNotEmpty &&
              locations.contains(preselectedLocation)) {
            editSelectedLocation.value = preselectedLocation;
          } else if (preselectedLocation.isNotEmpty) {
            // Saved location not found in list — reset
            editSelectedLocation.value = '';
          }
        }
      }
    } catch (_) {} finally {
      isLoadingLocations.value = false;
    }
  }

  // ── Parse ──────────────────────────────────────────────────────────────────
  dynamic _parse(Map<String, dynamic> json) => _MerchantDetail(
    id: json['id'] ?? 0,
    shopName: (json['shop_name'] ?? '').toString().trim(),
    ownerName: (json['owner_name'] ?? '').toString().trim(),
    email: (json['email'] ?? '').toString().trim(),
    phone1: (json['phone_no_1'] ?? '').toString().trim(),
    phone2: (json['phone_no_2'] ?? '').toString().trim(),
    state: (json['state'] ?? '').toString().trim(),
    district: (json['district'] ?? '').toString().trim(),
    mainLocation: (json['main_location'] ?? '').toString().trim(),
    latitude: (json['latitude'] ?? '').toString().trim(),
    longitude: (json['longitude'] ?? '').toString().trim(),
    storeImage: (json['store_image'] ?? '').toString().trim(),
    whatsapp: (json['whatsapp_no'] ?? '').toString().trim(),
    facebook: (json['facebook_link'] ?? '').toString().trim(),
    instagram: (json['instagram_link'] ?? '').toString().trim(),
    website: (json['website_link'] ?? '').toString().trim(),
  );
}

// ── Model ──────────────────────────────────────────────────────────────────────
class _MerchantDetail {
  final int id;
  final String shopName, ownerName, email, phone1, phone2;
  final String state, district, mainLocation, latitude, longitude;
  final String storeImage, whatsapp, facebook, instagram, website;

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