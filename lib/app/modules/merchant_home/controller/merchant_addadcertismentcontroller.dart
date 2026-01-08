
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

  @override
  void onInit() {
    super.onInit();
    authToken = box.read("auth_token") ?? "";
  }

  @override
  void onClose() {
    adNameController.dispose();
    super.onClose();
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
    final base64 = base64Encode(bytes);
    return "data:image/jpeg;base64,$base64";
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

    isLoading.value = true;

    try {
      final base64Image = await _toBase64(bannerImage.value!);

      final response = await http.post(
        Uri.parse(
            "https://rasma.astradevelops.in/e_shoppyy/public/api/advertisement"),
        headers: {
          "Authorization": "Bearer $authToken",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "advertisement": adNameController.text.trim(),
          "banner_image": base64Image,
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (body["status"] == "1" || body["status"] == 1) {
          adNameController.clear();
          bannerImage.value = null;

          Get.snackbar(
            "Success",
            body["message"] ?? "Advertisement added successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          await Future.delayed(const Duration(seconds: 1));
                  Get.offAll(()=>MyAdvertisements());
          // Get.back(result: true); // ✅ go to MyAdve/ go back to list page
        } else {
          Get.snackbar("Failed", body["message"]);
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Session Expired", "Login again");
      } else {
        Get.snackbar("Error", "Server error");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
