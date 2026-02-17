
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminRestaurantUpdateController extends GetxController {
  final restaurantNameController = TextEditingController();
  final ownerNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final whatsappController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();

  var isLoading = false.obs;
  var isUpdating = false.obs;

  var restaurantImage = Rxn<File>();
  var restaurantImageUrl = ''.obs;
  var additionalImages = <File>[].obs;
  var existingAdditionalImageUrls = <String>[].obs;

  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();

  String? restaurantId;

  // FIX: Guard to prevent loadRestaurantData from running more than once
  bool _isDataLoaded = false;

  static const String _baseUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/";

  @override
  void onClose() {
    restaurantNameController.dispose();
    ownerNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    super.onClose();
  }

  void loadRestaurantData(Map<String, dynamic> restaurantData) {
    // FIX: Only load once
    if (_isDataLoaded) return;
    _isDataLoaded = true;

    restaurantNameController.text = restaurantData['restaurant_name'] ?? '';
    ownerNameController.text = restaurantData['owner_name'] ?? '';
    addressController.text = restaurantData['address'] ?? '';
    phoneController.text = restaurantData['phone'] ?? '';
    emailController.text = restaurantData['email'] ?? '';
    websiteController.text = restaurantData['website'] ?? '';
    whatsappController.text = restaurantData['whatsapp'] ?? '';
    facebookController.text = restaurantData['facebook_link'] ?? '';
    instagramController.text = restaurantData['instagram_link'] ?? '';

    restaurantImageUrl.value = restaurantData['restaurant_image'] ?? '';

    if (restaurantData['additional_images'] != null) {
      existingAdditionalImageUrls.value =
      List<String>.from(restaurantData['additional_images']);
    }
  }

  // FIX: Strip base URL to get relative path for sending to server
  String _stripBaseUrl(String url) {
    if (url.startsWith(_baseUrl)) {
      return url.replaceFirst(_baseUrl, '');
    }
    return url;
  }

  Future<void> pickRestaurantImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        restaurantImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> pickAdditionalImages() async {
    try {
      final List<XFile> pickedFiles =
      await _picker.pickMultiImage(imageQuality: 80);
      if (pickedFiles.isNotEmpty) {
        additionalImages
            .addAll(pickedFiles.map((file) => File(file.path)).toList());
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick images: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeAdditionalImage(int index) {
    additionalImages.removeAt(index);
  }

  void removeExistingAdditionalImage(int index) {
    existingAdditionalImageUrls.removeAt(index);
  }

  bool validateForm() {
    if (restaurantNameController.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Restaurant name is required");
      return false;
    }
    if (ownerNameController.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Owner name is required");
      return false;
    }
    if (addressController.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Address is required");
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Phone number is required");
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Validation Error", "Email is required");
      return false;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      Get.snackbar("Validation Error", "Please enter a valid email");
      return false;
    }
    return true;
  }

  Future<void> updateRestaurant() async {
    if (!validateForm()) return;

    isUpdating.value = true;

    final token = box.read("auth_token");
    if (token == null) {
      Get.snackbar("Error", "Auth token not found. Please login again.");
      isUpdating.value = false;
      return;
    }

    if (restaurantId == null) {
      Get.snackbar("Error", "Restaurant ID is missing");
      isUpdating.value = false;
      return;
    }

    final url = Uri.parse(
        "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurant/update");

    try {
      var request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });
      request.fields['restaurant_id'] = restaurantId.toString(); // ✅ Correct
      // FIX: Ensure ID is always sent as string
      // request.fields['id'] = restaurantId.toString();
      request.fields['restaurant_name'] =
          restaurantNameController.text.trim();
      request.fields['owner_name'] = ownerNameController.text.trim();
      request.fields['address'] = addressController.text.trim();
      request.fields['phone'] = phoneController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['website'] = websiteController.text.trim();
      request.fields['whatsapp'] = whatsappController.text.trim();
      request.fields['facebook_link'] = facebookController.text.trim();
      request.fields['instagram_link'] = instagramController.text.trim();

      // FIX: Send existing image path stripped of base URL
      // Only send if no new image was picked (server keeps existing if not sent,
      // but some APIs require you to re-send it)
      if (restaurantImage.value == null &&
          restaurantImageUrl.value.isNotEmpty) {
        request.fields['existing_restaurant_image'] =
            _stripBaseUrl(restaurantImageUrl.value);
      }

      // New main image
      if (restaurantImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'restaurant_image',
            restaurantImage.value!.path,
          ),
        );
      }

      // FIX: Send existing additional image paths stripped of base URL
      final strippedExisting = existingAdditionalImageUrls
          .map((url) => _stripBaseUrl(url))
          .toList();

      for (var i = 0; i < strippedExisting.length; i++) {
        request.fields['existing_additional_images[$i]'] = strippedExisting[i];
      }

      // New additional images
      for (var i = 0; i < additionalImages.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'additional_images[]',
            additionalImages[i].path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // FIX: Log response for debugging
      debugPrint('Update response [${response.statusCode}]: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body["status"].toString() == "1") {
          Get.snackbar(
            "Success",
            body["message"] ?? "Restaurant updated successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back();
        } else {
          Get.snackbar(
            "Error",
            body["message"] ?? "Failed to update restaurant",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Server returned ${response.statusCode}: ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUpdating.value = false;
    }
  }
}