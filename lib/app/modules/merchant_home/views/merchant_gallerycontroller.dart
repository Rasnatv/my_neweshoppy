
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

  // ================= BASE64 =================
  String _toBase64(File file) {
    final bytes = file.readAsBytesSync();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  // ================= GET GALLERY =================
  Future<void> loadGallery() async {
    if (token.isEmpty) return;

    isLoading.value = true;

    try {
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
      }
    } catch (e) {
      print("Load gallery error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  // ================= UPLOAD IMAGES =================
  Future<void> uploadImages() async {
    if (selectedImages.isEmpty || token.isEmpty) return;

    isUploading.value = true;

    try {
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
        loadGallery();
        Get.snackbar("Success", data["message"]);
      }
    } finally {
      isUploading.value = false;
    }
  }


  // ================= DELETE IMAGE =================
  Future<void> deleteImage(int index) async {
    final imageId = uploadedImages[index].id;

    final response = await http.post(
      Uri.parse("$baseUrl/image/delete"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "id": imageId, // ✅ EXACT API KEY
      }),
    );

    final data = jsonDecode(response.body);

    if (data["status"] == 1) {
      uploadedImages.removeAt(index);
      Get.snackbar("Success", data["message"]);
    }
  }
}