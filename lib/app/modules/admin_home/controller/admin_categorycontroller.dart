
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
      "https://rasma.astradevelops.in/e_shoppyy/public/api/categories";

  /// 📷 Pick Image
  Future<void> pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      final file = File(img.path);
      imageFile.value = file;
    }
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

    if (title.isEmpty || imageFile.value == null) {
      Get.snackbar("Error", "Title & image are required");
      return;
    }

    final token = box.read("auth_token");
    final role = int.tryParse(box.read("role").toString());

    if (token == null || role != 3) {
      Get.snackbar("Error", "Admin login required");
      return;
    }

    // Clean attributes
    final cleanItems = items
        .where((e) => e.name.trim().isNotEmpty && e.values.isNotEmpty)
        .toList();

    if (cleanItems.isEmpty) {
      Get.snackbar("Error", "Add at least one attribute with values");
      return;
    }

    try {
      isLoading(true);

      // Multipart request
      final request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      // Required fields
      request.fields["title"] = title;

      // Convert image to base64
      final bytes = await imageFile.value!.readAsBytes();
      request.fields["image"] = "data:image/png;base64,${base64Encode(bytes)}";

      // Attributes in indexed format
      for (int i = 0; i < cleanItems.length; i++) {
        final item = cleanItems[i];
        request.fields["items_data[$i][name]"] = item.name.trim();

        for (int j = 0; j < item.values.length; j++) {
          request.fields["items_data[$i][values][$j]"] = item.values[j].trim();
        }
      }

      // Send request
      final response = await request.send();
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", data["message"]);
        clearForm();
      } else {
        Get.snackbar("Error", data["message"] ?? "Failed to add category");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  /// Clear form after submission
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
