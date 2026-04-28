
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../data/errors/api_error.dart';
import '../../../merchantlogin/widget/successwidget.dart';

class AdminupdateAdvertisementController extends GetxController {
  final _box = GetStorage();

  String get _authToken => _box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_authToken',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ───────────────── STATE ─────────────────
  final isFetchingAd = false.obs;
  final isEditLoading = false.obs;
  final editIsTitleEmpty = false.obs;

  late final TextEditingController editAdName = TextEditingController();

  final editBannerImage = Rx<File?>(null);
  final editNetworkBannerUrl = ''.obs;
  final editCreatedByType = ''.obs;
  final editCreatedById = ''.obs;
  final editCreatedAt = ''.obs;

  String _currentAdId = '';

  final selectedEditState = RxnString();
  final selectedEditDistrict = RxnString();
  final selectedEditArea = RxnString();

  final isLoadingStates = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas = false.obs;

  final statesList = <String>[].obs;
  final districtsList = <String>[].obs;
  final areasList = <String>[].obs;

  bool get showMainLocationDropdown =>
      editCreatedByType.value != 'district_admin';

  // ───────────────── INIT ─────────────────
  @override
  void onInit() {
    super.onInit();

    if (_authToken.isEmpty) {
      Get.offAllNamed('/login');
    }
  }

  // ───────────────── STATES ─────────────────
  Future<void> loadStates() async {
    isLoadingStates.value = true;

    try {
      final res = await http.get(
        Uri.parse('https://eshoppy.co.in/api/get-states'),
        headers: _headers,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data['status'] == true && data['data'] is List) {
          final fetched = List<String>.from(data['data']);
          final current = selectedEditState.value;

          statesList.assignAll(
              current != null && !fetched.contains(current)
                  ? [current, ...fetched]
                  : fetched);
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }

    isLoadingStates.value = false;
  }

  // ───────────────── DISTRICTS ─────────────────
  Future<void> loadDistricts() async {
    isLoadingDistricts.value = true;

    try {
      final res = await http.get(
        Uri.parse('https://eshoppy.co.in/api/districts'),
        headers: _headers,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data['status'] == true && data['data'] is List) {
          final fetched = List<String>.from(data['data']);
          final current = selectedEditDistrict.value;

          districtsList.assignAll(
              current != null && !fetched.contains(current)
                  ? [current, ...fetched]
                  : fetched);
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }

    isLoadingDistricts.value = false;
  }

  // ───────────────── AREAS ─────────────────
  Future<void> loadAreas() async {
    isLoadingAreas.value = true;

    try {
      final res = await http.get(
        Uri.parse('https://eshoppy.co.in/api/areas'),
        headers: _headers,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data['status'] == true && data['data'] is List) {
          final fetched = List<String>.from(data['data']);
          final current = selectedEditArea.value;

          areasList.assignAll(
              current != null && !fetched.contains(current)
                  ? [current, ...fetched]
                  : fetched);
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }

    isLoadingAreas.value = false;
  }

  // ───────────────── FETCH SINGLE ─────────────────
  Future<void> fetchSingleAdvertisement(String adId) async {
    _currentAdId = adId;
    isFetchingAd.value = true;

    try {
      final res = await http.post(
        Uri.parse('https://eshoppy.co.in/api/get-single-advertisement'),
        headers: _headers,
        body: jsonEncode({
          'advertisement_id': int.tryParse(adId) ?? adId,
        }),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == '1') {
        final d = body['data'];

        editAdName.text = d['advertisement'] ?? '';
        editNetworkBannerUrl.value = d['banner_image'] ?? '';
        editCreatedByType.value = d['created_by_type'] ?? '';

        selectedEditState.value = _nullIfEmpty(d['state']);
        selectedEditDistrict.value = _nullIfEmpty(d['district']);
        selectedEditArea.value = _nullIfEmpty(d['main_location']);

        _seedList(statesList, selectedEditState.value);
        _seedList(districtsList, selectedEditDistrict.value);
        _seedList(areasList, selectedEditArea.value);

        await Future.wait([
          loadStates(),
          loadDistricts(),
          if (showMainLocationDropdown) loadAreas(),
        ]);
      } else {
        AppSnackbar.error(
            body['message'] ?? ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }

    isFetchingAd.value = false;
  }

  // ───────────────── UPDATE ─────────────────
  Future<void> updateAdvertisement() async {
    if (editAdName.text.trim().isEmpty) {
      editIsTitleEmpty.value = true;
      AppSnackbar.warning("Enter advertisement name");
      return;
    }

    isEditLoading.value = true;

    try {
      final payload = {
        'advertisement_id': int.tryParse(_currentAdId) ?? _currentAdId,
        'advertisement': editAdName.text.trim(),
        'state': selectedEditState.value ?? '',
        'district': selectedEditDistrict.value ?? '',
        'main_location':
        showMainLocationDropdown ? selectedEditArea.value ?? '' : '',
      };

      final file = editBannerImage.value;
      if (file != null) {
        final bytes = await file.readAsBytes();
        payload['banner_image'] =
        'data:${_mimeFromPath(file.path)};base64,${base64Encode(bytes)}';
      }

      final res = await http.put(
        Uri.parse('https://eshoppy.co.in/api/update-advertisement'),
        headers: _headers,
        body: jsonEncode(payload),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == '1') {
        AppSnackbar.success(body['message'] ?? "Updated successfully");
        Get.back();
      } else {
        AppSnackbar.error(
            body['message'] ?? ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }

    isEditLoading.value = false;
  }

  // ───────────────── IMAGE PICK ─────────────────
  Future<void> pickEditBannerImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (picked == null) return;

      final file = File(picked.path);
      final bytes = await file.readAsBytes();
      final decoded = await decodeImageFromList(bytes);

      final ratio = decoded.width / decoded.height;

      if (ratio < 1.9 || ratio > 2.1) {
        AppSnackbar.warning(
            "Invalid ratio ${decoded.width}x${decoded.height}\nUse 2:1 image");
        return;
      }

      editBannerImage.value = file;
    } catch (e) {
      AppSnackbar.error("Image error");
    }
  }

  void removeEditBannerImage() => editBannerImage.value = null;

  // ───────────────── HELPERS ─────────────────
  String? _nullIfEmpty(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  void _seedList(RxList<String> list, String? value) {
    if (value != null && !list.contains(value)) {
      list.insert(0, value);
    }
  }

  String _mimeFromPath(String path) {
    final ext = path.split('.').last.toLowerCase();
    return {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
    }[ext] ??
        'image/jpeg';
  }

  @override
  void onClose() {
    editAdName.dispose();
    super.onClose();
  }
}
