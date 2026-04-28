import 'dart:io';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';
import '../banners/views/adminadvertisment.dart';

class AdminAdvertisementController extends GetxController {

  // ── STORAGE ──
  final box = GetStorage();
  String get authToken => box.read('auth_token') ?? '';

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $authToken',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static const _base =
      'https://eshoppy.co.in/api';

  final ImagePicker picker = ImagePicker();

  // ── STATE ──
  final adName = TextEditingController();
  var bannerImage = Rx<File?>(null);

  var advertisements = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var isTitleEmpty = false.obs;

  // ── FILTER ──
  var selectedFilter = 'all'.obs;
  var expandedId = ''.obs;

  // ── EDIT STATE ──
  var editAdId = ''.obs;
  var isEditLoading = false.obs;
  var isFetchingAd = false.obs;

  final editAdName = TextEditingController();
  var editBannerImage = Rx<File?>(null);

  var editCreatedByType = ''.obs;
  var editCreatedById = ''.obs;
  var editCreatedAt = ''.obs;
  var editNetworkBannerUrl = ''.obs;
  var editIsTitleEmpty = false.obs;

  // ── DROPDOWNS ──
  final statesList = <String>[].obs;
  final districtsList = <String>[].obs;
  final areasList = <String>[].obs;

  final selectedEditState = RxnString();
  final selectedEditDistrict = RxnString();
  final selectedEditArea = RxnString();

  final isLoadingStates = false.obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas = false.obs;

  bool get showMainLocationDropdown =>
      editCreatedByType.value != 'district_admin';

  // ───────────────── INIT ─────────────────
  @override
  void onInit() {
    super.onInit();

    fetchAdvertisements();
    fetchStates();
    fetchDistricts();
    fetchAreas();
  }

  // ───────────────── FILTER ─────────────────
  List<Map<String, dynamic>> get filteredAdvertisements {
    if (selectedFilter.value == 'all') return advertisements;
    return advertisements
        .where((ad) => ad['created_by_type'] == selectedFilter.value)
        .toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    expandedId.value = '';
  }

  void toggleExpand(String id) {
    expandedId.value = (expandedId.value == id) ? '' : id;
  }

  // ───────────────── STATES ─────────────────
  Future<void> fetchStates() async {
    isLoadingStates.value = true;

    try {
      final res =
      await http.get(Uri.parse('$_base/get-states'), headers: _headers);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['status'] == true) {
          statesList.assignAll(List<String>.from(body['data']));
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }

    isLoadingStates.value = false;
  }

  Future<void> fetchDistricts() async {
    isLoadingDistricts.value = true;

    try {
      final res =
      await http.get(Uri.parse('$_base/districts'), headers: _headers);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['status'] == true) {
          districtsList.assignAll(List<String>.from(body['data']));
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }

    isLoadingDistricts.value = false;
  }

  Future<void> fetchAreas() async {
    isLoadingAreas.value = true;

    try {
      final res =
      await http.get(Uri.parse('$_base/areas'), headers: _headers);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['status'] == true) {
          areasList.assignAll(List<String>.from(body['data']));
        }
      } else {
        AppSnackbar.error(ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }

    isLoadingAreas.value = false;
  }

  // ───────────────── IMAGE ─────────────────
  Future<void> pickBannerImage() async {
    try {
      final img = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (img != null) {
        bannerImage.value = File(img.path);
      }
    } catch (e) {
      AppSnackbar.error("Failed to pick image");
    }
  }

  void removeBannerImage() => bannerImage.value = null;

  Future<String> imageToBase64(File file) async {
    final bytes = await file.readAsBytes();
    final ext = file.path.split('.').last.toLowerCase();

    final mime = {
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
    }[ext] ??
        'image/jpeg';

    return 'data:$mime;base64,${base64Encode(bytes)}';
  }

  // ───────────────── ADD ─────────────────
  Future<void> addAdvertisement() async {
    if (adName.text.trim().isEmpty) {
      isTitleEmpty.value = true;
      return AppSnackbar.warning("Enter advertisement title");
    }

    if (bannerImage.value == null) {
      return AppSnackbar.warning("Select banner image");
    }

    try {
      isLoading.value = true;

      final base64Image = await imageToBase64(bannerImage.value!);

      final res = await http.post(
        Uri.parse('$_base/advertisement'),
        headers: _headers,
        body: jsonEncode({
          'advertisement': adName.text.trim(),
          'banner_image': base64Image,
        }),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        if (body['status'] == "1" || body['status'] == true) {
          adName.clear();
          bannerImage.value = null;

          await fetchAdvertisements();

          AppSnackbar.success(body['message'] ?? "Advertisement added");

          Get.back(result: true);
        } else {
          AppSnackbar.error(body['message'] ?? "Failed");
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

  // ───────────────── FETCH LIST ─────────────────
  Future<void> fetchAdvertisements() async {
    try {
      isLoading.value = true;

      final res = await http.get(
        Uri.parse('$_base/admin/advertisements'),
        headers: _headers,
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        final isSuccess =
            body['status'] == true || body['status'] == "1";

        if (isSuccess) {
          advertisements.value = List<Map<String, dynamic>>.from(
            body['data'].map((ad) => {
              "id": ad['id'].toString(),
              "name": ad['advertisement'] ?? '',
              "banner": ad['banner_image'] ?? '',
              "state": ad['state'] ?? '',
              "district": ad['district'] ?? '',
              "main_location": ad['main_location'] ?? '',
              "created_by_type": ad['created_by_type'] ?? '',
            }),
          );
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

  // ───────────────── DELETE ─────────────────
  Future<void> deleteAdvertisement(int index) async {
    if (index >= advertisements.length) return;

    final adId = advertisements[index]['id'];

    try {
      final res = await http.delete(
        Uri.parse('$_base/delete-advertisement-admin'),
        headers: _headers,
        body: jsonEncode({"advertisement_id": adId}),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body['status'] == true) {
        advertisements.removeAt(index);
        AppSnackbar.success(body['message'] ?? "Deleted");
      } else {
        AppSnackbar.error(
            body['message'] ?? ApiErrorHandler.handleResponse(res));
      }
    } catch (e) {
      AppSnackbar.error(ApiErrorHandler.handleException(e));
    }
  }

  // ───────────────── CLEANUP ─────────────────
  @override
  void onClose() {
    adName.dispose();
    editAdName.dispose();
    super.onClose();
  }
}