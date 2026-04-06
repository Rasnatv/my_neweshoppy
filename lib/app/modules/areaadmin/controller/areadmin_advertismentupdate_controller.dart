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

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        final List list = data['data'];
        locations.assignAll(list.map((e) => e.toString()).toList());

        if (selectedLocation.value.isNotEmpty &&
            !locations.contains(selectedLocation.value)) {
          selectedLocation.value = '';
        }
      }
    } catch (e) {
      debugPrint("Location fetch error: $e");
    } finally {
      isLocationLoading(false);
    }
  }

  Future<void> fetchAdvertisement() async {
    try {
      isFetching(true);
      hasError(false);

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
          "Authorization": "Bearer $token",
        },
        body: {"ad_id": adId.toString()},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        final model = AreaAdminAdvertisementupdateModel.fromJson(data['data']);
        adName.text = model.advertisement;
        selectedLocation.value = model.mainLocation;
        existingBannerUrl.value = model.bannerImage;
      } else {
        hasError(true);
        errorMessage(data['message'] ?? 'Failed to load advertisement.');
      }
    } catch (e) {
      hasError(true);
      errorMessage('Something went wrong: $e');
    } finally {
      isFetching(false);
    }
  }

  Future<void> pickBannerImage() async {
    final picker = ImagePicker();
    final picked =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) bannerImage.value = File(picked.path);
  }

  void removeBannerImage() => bannerImage.value = null;

  Future<void> updateAdvertisement() async {
    if (adName.text.trim().isEmpty) {
      isTitleEmpty(true);
      return;
    }
    if (selectedLocation.value.isEmpty) {
      Get.snackbar('Validation', 'Please select a location.',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading(true);
      final String? token = box.read("auth_token");
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'No auth token. Please log in again.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final Map<String, String> body = {
        "ad_id": adId.toString(),
        "advertisement": adName.text.trim(),
        "main_location": selectedLocation.value,
      };

      if (bannerImage.value != null) {
        final bytes = await bannerImage.value!.readAsBytes();
        final base64Image = base64Encode(bytes);
        final ext =
        bannerImage.value!.path.split('.').last.toLowerCase();
        final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
        body["banner_image"] = "data:$mimeType;base64,$base64Image";
      }

      final response = await http.put(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/area-admin/advertisement/update"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        Get.snackbar('Success', data['message'] ?? 'Advertisement updated!',
            backgroundColor: Colors.green, colorText: Colors.white);
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAll(() => AreaAdminhomepage()); // ✅ goes back to home and rebuilds it
      }
      else {
        Get.snackbar('Error', data['message'] ?? 'Update failed.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}