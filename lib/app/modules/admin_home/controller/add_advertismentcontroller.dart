
import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import '../banners/views/adminadvertisment.dart';

class AdminAdvertisementController extends GetxController {
  // Text controller for ad title
  final adName = TextEditingController();

  // Banner image picked
  var bannerImage = Rx<File?>(null);

  // List of advertisements
  var advertisements = <Map<String, dynamic>>[].obs;

  // Loading indicator
  var isLoading = false.obs;

  // Validation
  var isTitleEmpty = false.obs;

  final ImagePicker picker = ImagePicker();
  final box = GetStorage();

  String get authToken => box.read('auth_token') ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchAdvertisements();
  }

  // Pick banner image
  Future<void> pickBannerImage() async {
    try {
      final img = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (img != null) bannerImage.value = File(img.path);
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image");
    }
  }

  void removeBannerImage() => bannerImage.value = null;

  // Convert image to Base64
  Future<String> imageToBase64WithDataUri(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    String ext = imageFile.path.split('.').last.toLowerCase();
    String mime = 'image/jpeg';
    if (ext == 'png') mime = 'image/png';
    if (ext == 'gif') mime = 'image/gif';
    if (ext == 'webp') mime = 'image/webp';
    return 'data:$mime;base64,$base64Image';
  }

  // Add advertisement
  Future<void> addAdvertisement() async {
    // Validation
    if (adName.text.trim().isEmpty) {
      isTitleEmpty.value = true;
      Get.snackbar("Error", "Please enter advertisement title");
      return;
    } else {
      isTitleEmpty.value = false;
    }

    if (bannerImage.value == null) {
      Get.snackbar("Error", "Please select banner image");
      return;
    }

    if (authToken.isEmpty) {
      Get.snackbar("Auth Error", "Please login again");
      return;
    }

    try {
      isLoading.value = true;

      String base64Image = await imageToBase64WithDataUri(bannerImage.value!);

      final response = await http.post(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/advertisement'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'advertisement': adName.text.trim(),
          'banner_image': base64Image,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == "1") {
          // Clear input
          adName.clear();
          bannerImage.value = null;

          // Refresh the list after adding
          fetchAdvertisements();

          Get.snackbar("Success", jsonResponse['message'] ?? "Ad added");

          // Navigate back to Advertisement Page
          if (Get.isDialogOpen == false && Get.isBottomSheetOpen == false) {
            Get.offAll(() => AdminAdvertisementPage());
          }
        } else {
          Get.snackbar("Failed", jsonResponse['message'] ?? "Error adding ad");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Auth Error", "Session expired, please login again");
      } else {
        Get.snackbar("Error", "Server error ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all advertisements
  Future<void> fetchAdvertisements() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
            'https://rasma.astradevelops.in/e_shoppyy/public/api/getadvertisement'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == "1") {
          advertisements.value = List<Map<String, dynamic>>.from(
            jsonResponse['data'].map((ad) => {
              "id": ad['id'].toString(),
              "name": ad['advertisement'] ?? '',
              "banner": ad['banner_image'] ?? '',
            }),
          );
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Auth Error", "Session expired, please login again");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch advertisements");
    } finally {
      isLoading.value = false;
    }
  }

  // Delete advertisement locally (optional: can add API delete)
  void deleteAdvertisement(int index) {
    if (index >= 0 && index < advertisements.length) {
      advertisements.removeAt(index);
      Get.snackbar("Deleted", "Advertisement deleted successfully");
    }
  }
}

