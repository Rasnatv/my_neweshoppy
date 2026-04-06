
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../data/models/areaadmin_updateadvertismentmodel.dart';
import '../view/area_adminhome.dart';

class AreaAdminUpdateAdvertisementController extends GetxController {
  final int adId;
  AreaAdminUpdateAdvertisementController({required this.adId});

  final box = GetStorage();
  final adName = TextEditingController();
  final selectedLocation = ''.obs;
  final bannerImage = Rx<File?>(null);
  final existingBannerUrl = ''.obs;

  final isLoading = false.obs;
  final isFetching = false.obs;
  final isLocationLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isTitleEmpty = false.obs;

  final locations = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
    fetchAdvertisement();
  }

  @override
  void onClose() {
    adName.dispose();
    super.onClose();
  }

  // ── Fetch Locations ───────────────────────────────────────────────────────

  Future<void> fetchLocations() async {
    try {
      isLocationLoading(true);
      final String? token = box.read("auth_token");
      if (token == null || token.isEmpty) return;

      final response = await http.get(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/main-locations"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          final List list = data['data'];
          locations.assignAll(list.map((e) => e.toString()).toList());

          // Re-validate selectedLocation after locations are loaded
          if (selectedLocation.value.isNotEmpty &&
              !locations.contains(selectedLocation.value)) {
            selectedLocation.value = '';
          }
        }
      }
    } catch (e) {
      debugPrint("Location fetch error: $e");
    } finally {
      isLocationLoading(false);
    }
  }

  // ── Fetch Advertisement ───────────────────────────────────────────────────

  Future<void> fetchAdvertisement() async {
    try {
      isFetching(true);
      hasError(false);
      errorMessage('');

      final String? token = box.read("auth_token");
      if (token == null || token.isEmpty) {
        hasError(true);
        errorMessage('No auth token. Please log in again.');
        return;
      }

      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisement"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer $token",
        },
        body: {"ad_id": adId.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final model =
          AreaAdminAdvertisementupdateModel.fromJson(data['data']);

          adName.text = model.advertisement;
          existingBannerUrl.value = model.bannerImage;

          // Set location — wait for locations list to be ready if needed
          _applyLocation(model.mainLocation);
        } else {
          hasError(true);
          errorMessage(data['message'] ?? 'Failed to load advertisement.');
        }
      } else {
        hasError(true);
        errorMessage('Server error (${response.statusCode}). Please retry.');
      }
    } catch (e) {
      hasError(true);
      errorMessage('Something went wrong: $e');
      debugPrint("fetchAdvertisement error: $e");
    } finally {
      isFetching(false);
    }
  }

  /// Sets the selected location, waiting for the locations list if still loading.
  void _applyLocation(String location) {
    if (location.isEmpty) return;

    if (locations.isNotEmpty) {
      // Locations already loaded — set directly
      selectedLocation.value =
      locations.contains(location) ? location : '';
    } else {
      // Locations still loading — wait and apply
      ever(locations, (List<String> list) {
        if (list.isNotEmpty && selectedLocation.value.isEmpty) {
          selectedLocation.value =
          list.contains(location) ? location : '';
        }
      });
      // Fallback: set optimistically; fetchLocations will clear if invalid
      selectedLocation.value = location;
    }
  }

  // ── Image Picker ──────────────────────────────────────────────────────────

  Future<void> pickBannerImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) bannerImage.value = File(picked.path);
  }

  void removeBannerImage() => bannerImage.value = null;

  // ── Update Advertisement ──────────────────────────────────────────────────

  Future<void> updateAdvertisement() async {
    // Validate title
    if (adName.text.trim().isEmpty) {
      isTitleEmpty(true);
      return;
    }
    isTitleEmpty(false);

    // Validate location
    if (selectedLocation.value.isEmpty) {
      Get.snackbar(
        'Validation',
        'Please select a location.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      final String? token = box.read("auth_token");
      if (token == null || token.isEmpty) {
        Get.snackbar(
          'Error',
          'No auth token. Please log in again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Build request body
      final Map<String, String> body = {
        "ad_id": adId.toString(),
        "advertisement": adName.text.trim(),
        "main_location": selectedLocation.value,
      };

      // Attach banner image as base64 if a new one was picked
      if (bannerImage.value != null) {
        final bytes = await bannerImage.value!.readAsBytes();
        final base64Image = base64Encode(bytes);
        final ext = bannerImage.value!.path.split('.').last.toLowerCase();
        final mimeType = (ext == 'png') ? 'image/png' : 'image/jpeg';
        body["banner_image"] = "data:$mimeType;base64,$base64Image";
      }

      final response = await http.put(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisement/update"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        // Update existing banner URL with the freshly returned URL
        if (data['data'] != null &&
            data['data']['banner_image'] != null) {
          existingBannerUrl.value = data['data']['banner_image'];
          bannerImage.value = null; // clear local file — server copy is canonical
        }

        Get.snackbar(
          'Success',
          data['message'] ?? 'Advertisement updated!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAll(() => AreaAdminhomepage());
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Update failed.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("updateAdvertisement error: $e");
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}