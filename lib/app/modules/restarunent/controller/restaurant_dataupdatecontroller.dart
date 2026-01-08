
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminRestaurantUpdateController extends GetxController {
  final box = GetStorage();

  // Text Controllers
  final ownerCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  final facebookCtrl = TextEditingController();
  final instagramCtrl = TextEditingController();

  final isLoading = false.obs;

  // Images
  final pickedImage = Rx<File?>(null);
  final existingAdditionalImages = <String>[].obs;
  final additionalImages = <File>[].obs;

  final picker = ImagePicker();
  late String restaurantId;

  /// Init data
  void setRestaurantData({
    required String id,
    required Map<String, dynamic> data,
  }) {
    restaurantId = id;

    ownerCtrl.text = data["owner_name"] ?? "";
    phoneCtrl.text = data["phone"] ?? "";
    addressCtrl.text = data["address"] ?? "";
    emailCtrl.text = data["email"] ?? "";
    websiteCtrl.text = data["website"] ?? "";
    whatsappCtrl.text = data["whatsapp"] ?? "";
    facebookCtrl.text = data["facebook_link"] ?? "";
    instagramCtrl.text = data["instagram_link"] ?? "";

    if (data["additional_images"] != null &&
        data["additional_images"] is List) {
      existingAdditionalImages.assignAll(
        List<String>.from(data["additional_images"]),
      );
    }
  }

  /// Pick main image
  Future<void> pickMainImage() async {
    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) pickedImage.value = File(image.path);
  }

  /// Pick additional images
  Future<void> pickAdditionalImages() async {
    final images = await picker.pickMultiImage(imageQuality: 70);
    if (images != null) {
      additionalImages.addAll(images.map((e) => File(e.path)));
    }
  }

  /// Remove images
  void removeExistingImage(int index) {
    existingAdditionalImages.removeAt(index);
  }

  void removeNewImage(int index) {
    additionalImages.removeAt(index);
  }

  String? get mainImageBase64 {
    if (pickedImage.value == null) return null;
    return "data:image/jpeg;base64,${base64Encode(
      pickedImage.value!.readAsBytesSync(),
    )}";
  }

  Future<void> updateRestaurant() async {
    final token = box.read("auth_token");
    if (token == null) {
      Get.snackbar("Error", "Auth token missing");
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        "restaurant_id": restaurantId,
        "owner_name": ownerCtrl.text.trim(),
        "phone": phoneCtrl.text.trim(),
        "address": addressCtrl.text.trim(),
        "email": emailCtrl.text.trim(),
        "website": websiteCtrl.text.trim(),
        "whatsapp": whatsappCtrl.text.trim(),
        "facebook_link": facebookCtrl.text.trim(),
        "instagram_link": instagramCtrl.text.trim(),
        "existing_images": existingAdditionalImages,

        if (mainImageBase64 != null)
          "restaurant_image": mainImageBase64,

        if (additionalImages.isNotEmpty)
          "additional_images": additionalImages
              .map((e) =>
          "data:image/jpeg;base64,${base64Encode(e.readAsBytesSync())}")
              .toList(),
      };

      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/admin/restaurant/update"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      final res = jsonDecode(response.body);

      if (response.statusCode == 200 && res["status"] == "1") {
        Get.snackbar("Success", res["message"]);
        Get.back(result: true);
      } else {
        Get.snackbar("Error", res["message"] ?? "Update failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    ownerCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    emailCtrl.dispose();
    websiteCtrl.dispose();
    whatsappCtrl.dispose();
    facebookCtrl.dispose();
    instagramCtrl.dispose();
    super.onClose();
  }
}
