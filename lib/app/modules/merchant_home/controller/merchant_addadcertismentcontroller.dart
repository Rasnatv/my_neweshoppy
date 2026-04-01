
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../views/myadvetisment.dart';

class MerchantAdvertisementController extends GetxController {
  final adNameController = TextEditingController();
  final bannerImage = Rx<File?>(null);

  final isLoading = false.obs;
  final picker = ImagePicker();
  final box = GetStorage();

  late String authToken;

  // District & Area lists
  final districts = <String>[].obs;
  final areas = <String>[].obs;
  final isLoadingDistricts = false.obs;
  final isLoadingAreas = false.obs;

  // Selected values
  final selectedDistrict = Rx<String?>(null);
  final selectedArea = Rx<String?>(null);

  // Toggle: 'district' or 'area' — null = nothing chosen yet
  final locationType = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    authToken = box.read("auth_token") ?? "";
    fetchDistricts();
    fetchAreas();
  }

  @override
  void onClose() {
    adNameController.dispose();
    super.onClose();
  }

  /// Switch location type — resets the other selection
  void setLocationType(String type) {
    locationType.value = type;
    selectedDistrict.value = null;
    selectedArea.value = null;
  }

  /// Fetch Districts
  Future<void> fetchDistricts() async {
    isLoadingDistricts.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/districts"),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );
      final body = jsonDecode(response.body);
      if (body["status"] == true && body["data"] != null) {
        districts.value = List<String>.from(body["data"]);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load districts");
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  /// Fetch Areas
  Future<void> fetchAreas() async {
    isLoadingAreas.value = true;
    try {
      final response = await http.get(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/areas"),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
        },
      );
      final body = jsonDecode(response.body);
      if (body["status"] == true && body["data"] != null) {
        areas.value = List<String>.from(body["data"]);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load areas");
    } finally {
      isLoadingAreas.value = false;
    }
  }

  /// Pick Image
  Future<void> pickBanner() async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      bannerImage.value = File(picked.path);
    }
  }

  /// Convert image to base64
  Future<String> _toBase64(File file) async {
    final bytes = await file.readAsBytes();
    final base64Str = base64Encode(bytes);
    return "data:image/jpeg;base64,$base64Str";
  }

  /// POST ADVERTISEMENT
  Future<void> postAdvertisement() async {
    if (adNameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Enter advertisement name");
      return;
    }

    if (bannerImage.value == null) {
      Get.snackbar("Error", "Upload banner image");
      return;
    }

    if (locationType.value == null) {
      Get.snackbar("Error", "Select District or Area");
      return;
    }

    if (locationType.value == 'district' && selectedDistrict.value == null) {
      Get.snackbar("Error", "Please select a district");
      return;
    }

    if (locationType.value == 'area' && selectedArea.value == null) {
      Get.snackbar("Error", "Please select an area");
      return;
    }

    isLoading.value = true;

    try {
      final base64Image = await _toBase64(bannerImage.value!);

      final postBody = <String, dynamic>{
        "advertisement": adNameController.text.trim(),
        "banner_image": base64Image,
        "district":
        locationType.value == 'district' ? selectedDistrict.value : "",
        "main_location":
        locationType.value == 'area' ? selectedArea.value : "",
      };

      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/advertisement"),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(postBody),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody["status"] == "1" || responseBody["status"] == 1) {
          adNameController.clear();
          bannerImage.value = null;
          selectedDistrict.value = null;
          selectedArea.value = null;
          locationType.value = null;

          Get.snackbar(
            "Success",
            responseBody["message"] ?? "Advertisement added successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          await Future.delayed(const Duration(seconds: 1));
          Get.offAll(() => MyAdvertisements());
        } else {
          Get.snackbar(
              "Failed", responseBody["message"] ?? "Something went wrong");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Session Expired", "Login again");
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}