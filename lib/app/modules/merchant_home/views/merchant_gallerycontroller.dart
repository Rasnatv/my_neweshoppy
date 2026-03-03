import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/merchant_gallerymode.dart';

class MerchantGalleryController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final box = GetStorage();

  RxList<File> selectedImages = <File>[].obs;
  RxList<MerchantImage> uploadedImages = <MerchantImage>[].obs;

  RxBool isUploading = false.obs;
  RxBool isLoading = false.obs;
  RxInt deletingIndex = (-1).obs;

  String get token => box.read("auth_token") ?? "";

  final String baseUrl =
      "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant";

  @override
  void onInit() {
    super.onInit();
    loadGallery();
  }

  // ================= PICK IMAGES =================
  Future<void> pickImages() async {
    final images = await picker.pickMultiImage(imageQuality: 70);
    if (images.isNotEmpty) {
      selectedImages.addAll(images.map((e) => File(e.path)));
    }
  }

  // ================= REMOVE SELECTED (local only, no API) =================
  void removeSelectedImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  // ================= BASE64 =================
  String _toBase64(File file) {
    final bytes = file.readAsBytesSync();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  // ================= LOAD GALLERY =================
  Future<void> loadGallery() async {
    if (token.isEmpty) return;

    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse("$baseUrl/images"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 1) {
        uploadedImages.value = (data["data"] as List)
            .map((e) => MerchantImage.fromJson(e))
            .toList();
      } else {
        Get.snackbar("Error", data["message"] ?? "Failed to load images");
      }
    } catch (e) {
      Get.snackbar("Error", "Gallery load failed");
      print("Load gallery error: $e");
    } finally {
      isLoading(false);
    }
  }

  // ================= UPLOAD IMAGES =================
  Future<void> uploadImages() async {
    if (selectedImages.isEmpty || token.isEmpty) return;

    try {
      isUploading(true);

      final response = await http.post(
        Uri.parse("$baseUrl/upload-images"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "images": selectedImages.map(_toBase64).toList(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 1) {
        selectedImages.clear();
        await loadGallery();
        Get.snackbar("Success", data["message"]);
      } else {
        Get.snackbar("Error", data["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", "Upload failed");
      print(e);
    } finally {
      isUploading(false);
    }
  }

  // ================= DELETE UPLOADED IMAGE (API call) =================
  Future<void> deleteImage(int index) async {
    // ✅ Re-read token at delete time + show message if missing
    final String currentToken = box.read("auth_token") ?? "";
    if (currentToken.isEmpty) {
      Get.snackbar("Error", "Auth token missing. Please login again.");
      return;
    }

    if (index < 0 || index >= uploadedImages.length) return;

    final imageId = uploadedImages[index].id;
    deletingIndex.value = index;

    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/image/delete"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $currentToken",  // ✅ uses fresh token
        },
        body: jsonEncode({
          "id": imageId,
        }),
      );

      final data = jsonDecode(response.body);
      print("DELETE RESPONSE => $data");

      if (response.statusCode == 200 && data["status"] == 1) {
        uploadedImages.removeAt(index);
        Get.snackbar("Success", data["message"]);
      } else {
        Get.snackbar("Error", data["message"] ?? "Delete failed");
      }
    } catch (e) {
      print("Delete error => $e");
      Get.snackbar("Error", "Delete failed");
    } finally {
      deletingIndex.value = -1;
    }
  }}