
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MerchantGalleryController extends GetxController {
  final ImagePicker picker = ImagePicker();
  final box = GetStorage();

  RxList<File> selectedImages = <File>[].obs;
  RxList<String> uploadedImages = <String>[].obs;
  RxBool isUploading = false.obs;
  RxBool isLoading = false.obs;

  String get token => box.read("auth_token") ?? "";
  final String baseUrl = "https://rasma.astradevelops.in/e_shoppyy/public/api/merchant";

  @override
  void onInit() {
    super.onInit();
    // Only load gallery if we have images to show or API endpoint exists
    // Comment this out if you don't have a load gallery API yet
    // loadGallery();
  }

  /// Pick images
  Future<void> pickImages() async {
    try {
      final images = await picker.pickMultiImage(imageQuality: 70);
      if (images.isNotEmpty) {
        selectedImages.addAll(images.map((e) => File(e.path)));
        Get.snackbar(
          "Success",
          "${images.length} image(s) selected",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick images",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Convert to base64
  String _toBase64(File file) {
    final bytes = file.readAsBytesSync();
    return "data:image/jpeg;base64,${base64Encode(bytes)}";
  }

  /// Load existing gallery images
  Future<void> loadGallery() async {
    if (token.isEmpty) {
      Get.snackbar(
        "Auth Error",
        "Token missing. Please login again.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/gallery-images"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Gallery Response Status: ${response.statusCode}");
      print("Gallery Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          uploadedImages.clear();

          // Check if data exists and is a list
          if (data["data"] != null && data["data"] is List) {
            uploadedImages.addAll(
              (data["data"] as List).map((e) {
                // Handle different response structures
                if (e is String) {
                  return e;
                } else if (e is Map && e.containsKey("image_url")) {
                  return e["image_url"].toString();
                } else if (e is Map && e.containsKey("url")) {
                  return e["url"].toString();
                }
                return "";
              }).where((url) => url.isNotEmpty),
            );
          }
        } else {
          print("API returned status 0: ${data["message"]}");
        }
      } else if (response.statusCode == 404) {
        // API endpoint doesn't exist yet - this is okay
        print("Gallery endpoint not found - skipping load");
      } else {
        print("Failed to load gallery: ${response.statusCode}");
      }
    } catch (e) {
      print("Gallery load error: $e");
      // Don't show error snackbar for gallery load failures
      // since the endpoint might not exist yet
    } finally {
      isLoading.value = false;
    }
  }

  /// Upload images with AUTH TOKEN
  Future<void> uploadImages() async {
    if (selectedImages.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select images first",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (token.isEmpty) {
      Get.snackbar(
        "Auth Error",
        "Token missing. Please login again.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isUploading.value = true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/upload-images"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "images": selectedImages.map((e) => _toBase64(e)).toList(),
        }),
      );

      print("Upload Response Status: ${response.statusCode}");
      print("Upload Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 1) {
        // Add newly uploaded images to the list
        if (data["data"] != null && data["data"] is List) {
          for (var item in data["data"]) {
            String imageUrl = "";

            if (item is String) {
              imageUrl = item;
            } else if (item is Map && item.containsKey("image_url")) {
              imageUrl = item["image_url"].toString();
            } else if (item is Map && item.containsKey("url")) {
              imageUrl = item["url"].toString();
            }

            if (imageUrl.isNotEmpty) {
              uploadedImages.add(imageUrl);
            }
          }
        }

        selectedImages.clear();

        Get.snackbar(
          "Success",
          data["message"] ?? "Images uploaded successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Upload failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      print("Upload error: $e");
      Get.snackbar(
        "Error",
        "Upload failed: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isUploading.value = false;
    }
  }

  /// Delete image from gallery
  Future<void> deleteImage(int index) async {
    if (token.isEmpty) {
      Get.snackbar(
        "Auth Error",
        "Token missing. Please login again.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (index < 0 || index >= uploadedImages.length) {
      Get.snackbar(
        "Error",
        "Invalid image index",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final imageUrl = uploadedImages[index];

    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/delete-image"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "image_url": imageUrl,
        }),
      );

      print("Delete Response Status: ${response.statusCode}");
      print("Delete Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == 1) {
        uploadedImages.removeAt(index);
        Get.snackbar(
          "Success",
          data["message"] ?? "Image deleted successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.colorScheme.onPrimary,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed to delete image",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      }
    } catch (e) {
      print("Delete error: $e");
      // For now, just remove from local list if API fails
      uploadedImages.removeAt(index);
      Get.snackbar(
        "Warning",
        "Image removed locally. Server sync may be needed.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Remove selected image before upload
  void removeSelectedImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  /// Clear all selected images
  void clearSelectedImages() {
    selectedImages.clear();
  }
}