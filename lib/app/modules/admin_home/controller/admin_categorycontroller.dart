import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../data/errors/api_error.dart';
import '../../merchantlogin/widget/successwidget.dart';

class ItemData {
  String name;
  List<String> values;

  ItemData({required this.name, required this.values});

  Map<String, dynamic> toJson() {
    return {"name": name, "values": values};
  }
}

class CategoryController extends GetxController {
  final box = GetStorage();
  final picker = ImagePicker();

  /// UI Controllers
  final titleCtrl = TextEditingController();
  final isLoading = false.obs;

  final imageFile = Rx<File?>(null);
  final items = <ItemData>[].obs;

  final String url =
      "https://eshoppy.co.in/api/categories";

  /// 📷 Pick Image
  Future<void> pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);

    if (img == null) return;

    final file = File(img.path);

    // ✅ Optional size validation (1MB)
    final bytes = await file.length();
    if (bytes > 1024 * 1024) {
      AppSnackbar.warning("Image must be less than 1MB");
      return;
    }

    imageFile.value = file;
  }

  /// ➕ Add Attribute
  void addAttribute() {
    items.add(ItemData(name: "", values: []));
  }

  /// ❌ Remove Attribute
  void removeAttribute(int index) {
    items.removeAt(index);
  }

  /// 🚀 Submit Category
  Future<void> submit() async {
    final title = titleCtrl.text.trim();

    /// ✅ Basic validation
    if (title.isEmpty) {
      AppSnackbar.warning("Title is required");
      return;
    }

    if (imageFile.value == null) {
      AppSnackbar.warning("Image is required");
      return;
    }

    /// ✅ Auth check
    final token = box.read("auth_token");

    if (token == null || token.toString().isEmpty) {
      AppSnackbar.error("Session expired. Please login again");
      Get.offAllNamed('/login');
      return;
    }

    /// Clean attributes
    final cleanItems = items
        .where((e) => e.name.trim().isNotEmpty && e.values.isNotEmpty)
        .toList();

    if (cleanItems.isEmpty) {
      AppSnackbar.warning("Add at least one attribute with values");
      return;
    }

    try {
      isLoading(true);

      final request = http.MultipartRequest("POST", Uri.parse(url));

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      /// Fields
      request.fields["title"] = title;

      /// Convert image to base64
      final bytes = await imageFile.value!.readAsBytes();
      request.fields["image"] =
      "data:image/png;base64,${base64Encode(bytes)}";

      /// Attributes
      for (int i = 0; i < cleanItems.length; i++) {
        final item = cleanItems[i];

        request.fields["items_data[$i][name]"] = item.name.trim();

        for (int j = 0; j < item.values.length; j++) {
          request.fields["items_data[$i][values][$j]"] =
              item.values[j].trim();
        }
      }

      /// Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      /// ✅ Success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        AppSnackbar.success(data["message"] ?? "Category added successfully");
        clearForm();
      } else {
        /// ✅ Use API Error Handler
        final errorMessage = ApiErrorHandler.handleResponse(response);
        AppSnackbar.error(errorMessage);
      }
    } catch (e) {
      /// ✅ Exception Handling
      final errorMessage = ApiErrorHandler.handleException(e);
      AppSnackbar.error(errorMessage);
    } finally {
      isLoading(false);
    }
  }

  /// 🧹 Clear form
  void clearForm() {
    titleCtrl.clear();
    imageFile.value = null;
    items.clear();
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    super.onClose();
  }
}