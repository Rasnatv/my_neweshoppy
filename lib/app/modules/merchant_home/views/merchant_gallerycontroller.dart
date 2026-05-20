
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../../data/errors/api_error.dart';
import '../../../data/models/merchant_gallerymode.dart';
import '../../merchantlogin/widget/successwidget.dart';


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
      "https://eshoppy.co.in/api/merchant";

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

  void removeSelectedImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

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
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          uploadedImages.value = (data["data"] as List)
              .map((e) => MerchantImage.fromJson(e))
              .toList();
        } else {
          AppSnackbar.error(data["message"] ?? "Failed to load images");
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    } finally {
      isLoading(false);
    }
  }

  // ================= UPLOAD =================
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          selectedImages.clear();
          await loadGallery();
        } else {
          AppSnackbar.error(data["message"] ?? "Upload failed");
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    } finally {
      isUploading(false);
    }
  }

  // ================= DELETE =================
  Future<void> deleteImage(int index) async {
    final String currentToken = box.read("auth_token") ?? "";

    if (currentToken.isEmpty) {
      AppSnackbar.error("Session expired. Please login again");
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
          "Authorization": "Bearer $currentToken",
        },
        body: jsonEncode({"id": imageId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == 1) {
          uploadedImages.removeAt(index);
        } else {
          AppSnackbar.error(data["message"] ?? "Delete failed");
        }
      } else {
        final error = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(error);
      }
    } catch (e) {
      final error = ApiErrorHandler.handleException(e);
      AppSnackbar.error(error);
    } finally {
      deletingIndex.value = -1;
    }
  }
}